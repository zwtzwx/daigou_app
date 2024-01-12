/*
  登录页面
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/user/register/register_controller.dart';

class BeeSignUpPage extends GetView<BeeSignUpLogic> {
  const BeeSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: AppText(
          str: controller.pageTitle.value,
          fontSize: 17,
        ),
      ),
      backgroundColor: AppColors.white,
      // bottomNavigationBar: buildOtherSignIn(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            logoCell(context),
            loginCell(context),
          ],
        ),
      ),
    );
  }

  Widget logoCell(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      alignment: Alignment.center,
      child: ImgItem(
        'Center/logo',
        width: 80.w,
        height: 80.w,
      ),
    );
  }

  /*
  开始集运演示Cell
  */
  Widget loginCell(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          children: <Widget>[
            Obx(() => controller.loginType.value == 1
                ? inputPhoneView(context)
                : inPutEmailNumber(context)),
            passwordCell(context),
            inPutVeritfyNumber(context),
            inPutInviteNumber(context),
            30.verticalSpaceFromWidth,
            SizedBox(
              height: 38.h,
              width: double.infinity,
              child: BeeButton(
                text: '注册',
                onPressed: controller.onRegister,
              ),
            ),
            15.verticalSpaceFromWidth,
            Container(
              alignment: Alignment.centerRight,
              child: Obx(() => controller.loginType.value != 3
                  ? GestureDetector(
                      onTap: () {
                        controller.loginType.value =
                            controller.loginType.value == 1 ? 2 : 1;
                      },
                      child: AppText(
                        str: controller.loginType.value == 1
                            ? '邮箱注册'.ts
                            : '手机号注册'.ts,
                        color: AppColors.primary,
                      ),
                    )
                  : const SizedBox()),
            ),
          ],
        ));
  }

  inPutEmailNumber(BuildContext context) {
    var inputAccountView = Container(
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
              child: Obx(
                () => TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: '请输入邮箱'.ts,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return inputAccountView;
  }

  inPutInviteNumber(BuildContext context) {
    var inputAccountView = Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Obx(
        () => TextField(
          style: const TextStyle(color: Colors.black87),
          controller: controller.inviteController,
          decoration: InputDecoration(
            hintText: '请输入邀请码(选填)'.ts,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.line),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.line),
            ),
          ),
        ),
      ),
    );
    return inputAccountView;
  }

  inPutVeritfyNumber(BuildContext context) {
    var inputVerifyNumber = Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.line, style: BorderStyle.solid)),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Obx(
              () => TextField(
                obscureText: controller.loginType.value == 3 ? true : false,
                style: const TextStyle(color: Colors.black87),
                controller: controller.validationController,
                decoration: InputDecoration(
                  hintText: '请输入验证码'.ts,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
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
              onPressed: controller.onGetCode,
            ),
          ),
        ],
      ),
    );
    return inputVerifyNumber;
  }

  passwordCell(BuildContext context) {
    var passwordCell = Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.line,
            style: BorderStyle.solid,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      alignment: Alignment.center,
      child: Obx(
        () => TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.black87),
          controller: controller.passwordController,
          decoration: InputDecoration(
            hintText: '请输入密码'.ts,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
    return passwordCell;
  }

  inputPhoneView(BuildContext context) {
    var inputAccountView = Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.line, style: BorderStyle.solid)),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              controller.onTimezone();
            },
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Text(
                      '+' +
                          controller
                              .formatTimezone(controller.areaNumber.value),
                      style: const TextStyle(
                        fontSize: 16.0, //textsize
                        color: AppColors.textNormal,
                      ),
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
          ),
          10.horizontalSpace,
          Expanded(
              child: Container(
            height: 40,
            margin: const EdgeInsets.only(right: 10),
            child: TextField(
              style: const TextStyle(color: Colors.black87),
              controller: controller.mobileNumberController,
              decoration: InputDecoration(
                hintText: '请输入手机号'.ts,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ))
        ],
      ),
    );
    return inputAccountView;
  }
}
