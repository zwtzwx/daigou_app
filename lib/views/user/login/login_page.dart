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
        title: AppText(
          str: controller.pageTitle.value,
          color: AppColors.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppColors.white,
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
  //                     color: AppColors.textGray,
  //                   ),
  //                 ),
  //                 AppGaps.hGap5,
  //                 AppText(
  //                   str: Translation.t(context, '其它登录方式'),
  //                   color: AppColors.textGray,
  //                 ),
  //                 AppGaps.hGap5,
  //                 Expanded(
  //                   child: Container(
  //                     height: 1,
  //                     color: AppColors.textGray,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           AppGaps.vGap15,
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
  //                           border: Border.all(color: AppColors.textGray),
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
  //                   : AppGaps.empty,
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
        color: AppColors.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: <Widget>[
            Obx(
              () => Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.onLoginType(2);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: controller.loginType.value == 2
                                ? AppColors.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                      height: 40,
                      child: AppText(
                        str: '邮箱登录'.ts,
                        fontSize: 17,
                        fontWeight: controller.loginType.value == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        lines: 2,
                      ),
                    ),
                  ),
                  15.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      controller.onLoginType(1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: controller.loginType.value == 1
                                ? AppColors.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                      height: 40,
                      child: AppText(
                        str: '手机号登录'.ts,
                        fontSize: 17,
                        fontWeight: controller.loginType.value == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        lines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppGaps.vGap50,
            Obx(() => controller.loginType.value == 1
                ? inputPhoneView(context)
                : inPutEmailNumber(context)),
            inPutVeritfyNumber(context),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: controller.saveAccount.value,
                            onChanged: controller.onSaveAccount,
                            activeColor: AppColors.primary,
                          ),
                        ),
                        AppGaps.hGap10,
                        AppText(
                          str: '记住密码'.ts,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.toForgetPassword,
                    child: AppText(
                      str: '忘记密码'.ts + '？',
                      color: AppColors.primary,
                    ),
                  )
                ],
              ),
            ),
            AppGaps.vGap10,
            SizedBox(
              height: 40,
              width: double.infinity,
              child: MainButton(
                text: '登录',
                borderRadis: 4,
                onPressed: controller.onLogin,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: controller.onRegister,
                child: AppText(
                  str: '注册'.ts,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Container(
            //   child: Obx(
            //     () => GestureDetector(
            //       onTap: () {
            //         controller.loginType.value =
            //             controller.loginType.value == 1 ? 2 : 1;
            //         controller.validationController.text = '';
            //         controller.emailController.text = '';
            //         controller.mobileNumberController.text = '';
            //       },
            //       child: AppText(
            //         str: controller.loginType.value == 1
            //             ? '邮箱登录'.ts
            //             : '手机号登录'.ts,
            //         color: AppColors.primary,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ));
  }

  inPutEmailNumber(BuildContext context) {
    var inputAccountView = Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5, color: AppColors.line, style: BorderStyle.solid)),
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
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.line),
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
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 0.5, color: AppColors.line, style: BorderStyle.solid)),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Obx(
              () => TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
                controller: controller.validationController,
                decoration: InputDecoration(
                    hintText: '请输入密码'.ts,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.line),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.line),
                    )),
                onSubmitted: (res) {
                  FocusScope.of(context).requestFocus(controller.validation);
                },
              ),
            ),
          ),
          // Obx(() {
          //   return controller.loginType.value == 1 ||
          //           controller.loginType.value == 2
          //       ? SizedBox(
          //           child: TextButton(
          //             style: ButtonStyle(
          //               overlayColor: MaterialStateColor.resolveWith(
          //                   (states) => Colors.transparent),
          //             ),
          //             child: AppText(
          //                 str: controller.sent.value,
          //                 color: controller.codeColor.value),
          //             onPressed: controller.onGetCode,
          //           ),
          //         )
          //       : AppGaps.empty;
          // })
        ],
      ),
    );
    return inputVerifyNumber;
  }

  // 图形验证码
  // captchaVerify(BuildContext context) {
  //   var captchaVerify = Container(
  //     decoration: const BoxDecoration(
  //       color: AppColors.white,
  //       border: Border(
  //           bottom: BorderSide(
  //               width: 0.5,
  //               color: AppColors.line,
  //               style: BorderStyle.solid)),
  //     ),
  //     alignment: Alignment.center,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         Expanded(
  //           flex: 8,
  //           child: Obx(
  //             () => TextField(
  //               style: const TextStyle(color: Colors.black87),
  //               controller: controller.captchaController,
  //               decoration: InputDecoration(
  //                   hintText: '请输入图形验证码'.ts,
  //                   enabledBorder: const UnderlineInputBorder(
  //                     borderSide: BorderSide(color: AppColors.line),
  //                   ),
  //                   focusedBorder: const UnderlineInputBorder(
  //                     borderSide: BorderSide(color: AppColors.line),
  //                   )),
  //               onSubmitted: (res) {
  //                 FocusScope.of(context).requestFocus(controller.validation);
  //               },
  //             ),
  //           ),
  //         ),
  //         Obx(() {
  //           return controller.captcha.value != null
  //               ? GestureDetector(
  //                   onTap: controller.getCaptcha,
  //                   child: Image.memory(controller.captcha.value!.img))
  //               : AppGaps.empty;
  //         })
  //       ],
  //     ),
  //   );
  //   return captchaVerify;
  // }

  inputPhoneView(BuildContext context) {
    var inputAccountView = Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.line, style: BorderStyle.solid)),
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
          AppGaps.hGap10,
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
                  // borderSide: BorderSide(color: AppColors.line),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const UnderlineInputBorder(
                  // borderSide: BorderSide(color: AppColors.line),
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
