/*
  忘记密码
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiyun_app_client/views/user/forget_password/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: ZHTextLine(
          str: '忘记密码'.ts,
          color: BaseStylesConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: BaseStylesConfig.white,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            logoCell(context),
            loginSubmitCell(context),
          ],
        ),
      ),
    );
  }

  Widget logoCell(BuildContext context) {
    var headerView = Container(
        height: 200,
        color: Colors.white,
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/AboutMe/about-logo.png",
          height: 80,
          width: 80,
        ));
    return headerView;
  }

  /*
  重置
  */
  Widget loginSubmitCell(BuildContext context) {
    return Container(
        color: BaseStylesConfig.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: <Widget>[
            inputAccountView(context),
            inPutVeritfyNumber(context),
            inPutEmailNumber(context),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: MainButton(
                text: '确认并登录',
                borderRadis: 4.0,
                onPressed: controller.onSubmit,
              ),
            ),
          ],
        ));
  }

  inPutEmailNumber(BuildContext context) {
    var inputAccountView = Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
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
          Expanded(
              flex: 11,
              child: SizedBox(
                height: 40,
                child: TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  controller: controller.emailController,
                  decoration: InputDecoration(
                      hintText: '请输入密码'.ts,
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
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
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
                () => ZHTextLine(
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
        color: BaseStylesConfig.white,
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: BaseStylesConfig.line,
                style: BorderStyle.solid)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: GestureDetector(
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
          ),
          Expanded(
              flex: 11,
              child: Container(
                height: 40,
                margin: controller.loginType == 2
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.only(right: 10, left: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.black87),
                  controller: controller.mobileNumberController,
                  decoration: InputDecoration(
                      hintText:
                          (controller.loginType == 1 ? '请输入手机号' : '请输入邮箱').ts,
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
}
