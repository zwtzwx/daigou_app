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
import 'package:jiyun_app_client/views/user/login/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
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

  // Widget buildOtherSignIn() {
  //   return SafeArea(
  //     child: SizedBox(
  //       height: 120,
  //       child: Column(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 40),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: Container(
  //                     height: 1,
  //                     color: BaseStylesConfig.textGray,
  //                   ),
  //                 ),
  //                 Sized.hGap5,
  //                 ZHTextLine(
  //                   str: Translation.t(context, '其它登录方式'),
  //                   color: BaseStylesConfig.textGray,
  //                 ),
  //                 Sized.hGap5,
  //                 Expanded(
  //                   child: Container(
  //                     height: 1,
  //                     color: BaseStylesConfig.textGray,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Sized.vGap15,
  //           Row(
  //             mainAxisAlignment: Platform.isIOS
  //                 ? MainAxisAlignment.spaceEvenly
  //                 : MainAxisAlignment.center,
  //             children: [
  //               GestureDetector(
  //                 onTap: () async {
  //                   // String? idToken = await _auth.signInGoogle();
  //                   if (idToken != null) {
  //                     loginWith('social', {'token': idToken});
  //                   }
  //                 },
  //                 child: Container(
  //                   color: Colors.white,
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: BaseStylesConfig.textGray),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         padding: const EdgeInsets.all(7),
  //                         child: SvgPicture.asset(
  //                           'assets/images/Home/google.svg',
  //                           width: 25,
  //                           height: 25,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Platform.isIOS
  //                   ? GestureDetector(
  //                       onTap: () async {
  //                         String? idToken = await _auth.signInApple();
  //                         if (idToken != null) {
  //                           loginWith('social', {'token': idToken});
  //                         }
  //                       },
  //                       child: Container(
  //                         decoration: const BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: Colors.black,
  //                         ),
  //                         width: 40,
  //                         height: 40,
  //                         alignment: Alignment.center,
  //                         child: const Icon(
  //                           Icons.apple,
  //                           color: Colors.white,
  //                           size: 38,
  //                         ),
  //                       ),
  //                     )
  //                   : Sized.empty,
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
            inPutVeritfyNumber(context),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: MainButton(
                text: '登录注册',
                borderRadis: 4,
                onPressed: controller.onLogin,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      controller.loginType.value =
                          controller.loginType.value == 3 ? 1 : 3;
                    },
                    child: Obx(
                      () => ZHTextLine(
                          str: controller.loginType.value == 3
                              ? '验证码登录'.ts
                              : '密码登录'.ts),
                    ),
                  ),
                  Obx(() => controller.loginType.value != 3
                      ? GestureDetector(
                          onTap: () {
                            controller.loginType.value =
                                controller.loginType.value == 1 ? 2 : 1;
                          },
                          child: ZHTextLine(
                            str: controller.loginType.value == 1
                                ? '邮箱登录'.ts
                                : '手机号登录'.ts,
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
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
                      hintText: controller.loginType.value == 3
                          ? '请输入手机号或邮箱'.ts
                          : '请输入邮箱'.ts,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: BaseStylesConfig.line),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: BaseStylesConfig.line),
                      )),
                  onSubmitted: (res) {
                    FocusScope.of(context).requestFocus(controller.validation);
                  },
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
      margin: const EdgeInsets.only(left: 10, right: 10),
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
                    )),
                onSubmitted: (res) {
                  FocusScope.of(context).requestFocus(controller.validation);
                },
              ),
            ),
          ),
          Obx(() {
            return controller.loginType.value == 1 ||
                    controller.loginType.value == 2
                ? SizedBox(
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      child: ZHTextLine(
                          str: controller.sent.value,
                          color: controller.codeColor.value),
                      onPressed: controller.onGetCode,
                    ),
                  )
                : SizedBox(
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      child: ZHTextLine(
                          str: '忘记密码'.ts + '？',
                          color: BaseStylesConfig.textBlack),
                      onPressed: () async {
                        Routers.push(Routers.forgetPassword,
                            {'type': controller.loginType.value});
                      },
                    ),
                  );
          })
        ],
      ),
    );
    return inputVerifyNumber;
  }

  inputPhoneView(BuildContext context) {
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
                                controller.formatTimezone(
                                    controller.areaNumber.value),
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
                  ))),
          Expanded(
              flex: 11,
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
