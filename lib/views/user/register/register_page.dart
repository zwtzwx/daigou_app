/*
  登录页面
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/user/register/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: ZHTextLine(
          str: controller.pageTitle.value,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: BaseStylesConfig.white,
      // bottomNavigationBar: buildOtherSignIn(),
      body: SingleChildScrollView(
        child: SizedBox(
          // color: Colors.red,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight -
              ScreenUtil().statusBarHeight -
              ScreenUtil().bottomBarHeight,
          child: Column(
            children: [
              logoCell(context),
              loginCell(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoCell(BuildContext context) {
    var headerView = Container(
      height: 200,
      color: Colors.white,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          "assets/images/AboutMe/about-logo.png",
          height: 80,
          width: 80,
        ),
      ),
    );
    return headerView;
  }

  /*
  开始集运演示Cell
  */
  Widget loginCell(BuildContext context) {
    return Container(
        color: BaseStylesConfig.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: <Widget>[
            Obx(() => controller.loginType.value == 1
                ? inputPhoneView(context)
                : inPutEmailNumber(context)),
            passwordCell(context),
            inPutVeritfyNumber(context),
            captchaVerify(context),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Obx(() => controller.loginType.value != 3
                  ? GestureDetector(
                      onTap: () {
                        controller.loginType.value =
                            controller.loginType.value == 1 ? 2 : 1;
                      },
                      child: ZHTextLine(
                        str: controller.loginType.value == 1
                            ? '邮箱注册'.ts
                            : '手机号注册'.ts,
                      ),
                    )
                  : const SizedBox()),
            ),
            Sized.vGap10,
            SizedBox(
              height: 40,
              width: double.infinity,
              child: MainButton(
                text: '注册',
                borderRadis: 4,
                onPressed: controller.onRegister,
              ),
            ),
          ],
        ));
  }

  inPutEmailNumber(BuildContext context) {
    var inputAccountView = Container(
      decoration: const BoxDecoration(
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
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
                      borderSide: BorderSide(color: BaseStylesConfig.line),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: BaseStylesConfig.line),
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

  inPutVeritfyNumber(BuildContext context) {
    var inputVerifyNumber = Container(
      decoration: const BoxDecoration(
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
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
                  hintText: controller.loginType.value == 3
                      ? '请输入密码'.ts
                      : '请输入验证码'.ts,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: BaseStylesConfig.line),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: BaseStylesConfig.line),
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
                () => ZHTextLine(
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
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
      child: Obx(
        () => TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.black87),
          controller: controller.passwordController,
          decoration: InputDecoration(
            hintText: '请输入密码'.ts,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: BaseStylesConfig.line),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: BaseStylesConfig.line),
            ),
          ),
        ),
      ),
    );
    return passwordCell;
  }

  // 图形验证码
  captchaVerify(BuildContext context) {
    var captchaVerify = Container(
      decoration: const BoxDecoration(
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Obx(
              () => TextField(
                style: const TextStyle(color: Colors.black87),
                controller: controller.captchaController,
                decoration: InputDecoration(
                  hintText: '请输入图形验证码'.ts,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: BaseStylesConfig.line),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: BaseStylesConfig.line),
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            return controller.captcha.value != null
                ? GestureDetector(
                    onTap: controller.getCaptcha,
                    child: Image.memory(controller.captcha.value!.img))
                : Sized.empty;
          })
        ],
      ),
    );
    return captchaVerify;
  }

  inputPhoneView(BuildContext context) {
    var inputAccountView = Container(
      decoration: const BoxDecoration(
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
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
                        color: BaseStylesConfig.textNormal,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: BaseStylesConfig.textNormal,
                ),
              ],
            ),
          ),
          Sized.hGap10,
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
                  // borderSide: BorderSide(color: BaseStylesConfig.line),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const UnderlineInputBorder(
                  // borderSide: BorderSide(color: BaseStylesConfig.line),
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
