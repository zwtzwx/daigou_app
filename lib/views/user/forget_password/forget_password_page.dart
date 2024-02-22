/*
  忘记密码
*/

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/user/forget_password/forget_password_controller.dart';

class BeeResetPwdPage extends GetView<BeeResetPwdLogic> {
  const BeeResetPwdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          str: '忘记密码'.ts,
          fontSize: 17,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            logoCell(),
            loginSubmitCell(context),
          ],
        ),
      ),
    );
  }

  Widget logoCell() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: ImgItem(
          'Center/logo',
          width: 80.w,
          height: 80.w,
        ),
      ),
    );
  }

  /*
  重置
  */
  Widget loginSubmitCell(BuildContext context) {
    return Container(
        color: AppColors.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: <Widget>[
            inputAccountView(context),
            inPutVeritfyNumber(context),
            inPutEmailNumber(context),
            40.verticalSpaceFromWidth,
            SizedBox(
              height: 38.h,
              width: double.infinity,
              child: BeeButton(
                text: '确认并登录',
                onPressed: controller.onSubmit,
              ),
            ),
            15.verticalSpaceFromWidth,
            Container(
              alignment: Alignment.centerRight,
              child: Obx(() => GestureDetector(
                    onTap: () {
                      controller.loginType.value =
                          controller.loginType.value == 1 ? 2 : 1;
                    },
                    child: AppText(
                      str: controller.loginType.value == 1
                          ? '邮箱验证'.ts
                          : '手机号验证'.ts,
                      color: AppColors.primary,
                    ),
                  )),
            ),
          ],
        ));
  }

  inPutEmailNumber(BuildContext context) {
    var inputAccountView = Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.line, style: BorderStyle.solid)),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 11,
              child: SizedBox(
                height: 40,
                child: TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  controller: controller.emailController,
                  decoration: InputDecoration(
                      hintText: '请输入新密码'.ts,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(controller.validation);
                  },
                ),
              ))
        ],
      ),
    );
    return inputAccountView;
  }

  inPutVeritfyNumber(BuildContext context) {
    var inputVerifyNumber = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.line, style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: TextField(
              obscureText: false,
              style: const TextStyle(color: Colors.black87),
              controller: controller.validationController,
              decoration: InputDecoration(
                  hintText: '请输入验证码'.ts,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
              onSubmitted: (res) {
                FocusScope.of(context).requestFocus(controller.validation);
              },
            ),
          ),
          SizedBox(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
              ),
              child: Obx(
                () => AppText(
                  str: controller.sent.value,
                  color: controller.codeColor.value,
                ),
              ),
              onPressed: controller.getCode,
            ),
          ),
        ],
      ),
    );
    return inputVerifyNumber;
  }

  inputAccountView(BuildContext context) {
    var inputAccountView = Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.line, style: BorderStyle.solid)),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Obx(
        () => Row(
          children: <Widget>[
            controller.loginType.value == 1
                ? GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.onTimezone();
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            '+' +
                                controller.formatTimezone(
                                    controller.areaNumber.value),
                            style: const TextStyle(
                              fontSize: 16.0, //textsize
                              color: AppColors.textNormal,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textNormal,
                        ),
                      ],
                    ),
                  )
                : AppGaps.empty,
            Expanded(
              child: Container(
                height: 40,
                margin: controller.loginType.value == 2
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.only(right: 10, left: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: controller.mobileNumberController,
                  decoration: InputDecoration(
                    hintText:
                        (controller.loginType.value == 1 ? '请输入手机号' : '请输入邮箱')
                            .ts,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(controller.validation);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return inputAccountView;
  }
}
