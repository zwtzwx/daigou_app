/*
  登录页面
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/user/login/login_controller.dart';

class BeeSignInPage extends GetView<BeeSignInLogic> {
  const BeeSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
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
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              logoCell(),
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
  开始集运演示Cell
  */
  Widget loginCell(BuildContext context) {
    return Container(
        color: AppColors.white,
        padding: const EdgeInsets.only(right: 40, left: 40),
        child: Column(
          children: [
            Obx(
              () => SizedBox(
                height: 25.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.onLoginType(2);
                      },
                      child: AppText(
                        str: '邮箱登录'.ts,
                        fontSize: controller.loginType.value == 2 ? 17 : 16,
                        fontWeight: controller.loginType.value == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        alignment: TextAlign.center,
                      ),
                    ),
                    30.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        controller.onLoginType(1);
                      },
                      child: AppText(
                        str: '手机号登录'.ts,
                        fontSize: controller.loginType.value == 1 ? 17 : 16,
                        fontWeight: controller.loginType.value == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        alignment: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            30.verticalSpaceFromWidth,
            Obx(() => controller.loginType.value == 1
                ? inputPhoneView(context)
                : inPutEmailNumber(context)),
            inPutVeritfyNumber(context),
            15.verticalSpaceFromWidth,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Obx(
                //   () => Row(
                //     children: [
                //       SizedBox(
                //         width: 24,
                //         height: 24,
                //         child: Checkbox(
                //           value: controller.saveAccount.value,
                //           onChanged: controller.onSaveAccount,
                //           activeColor: AppColors.primary,
                //         ),
                //       ),
                //       AppGaps.hGap10,
                //       AppText(
                //         str: '记住密码'.ts,
                //       ),
                //     ],
                //   ),
                // ),
                Flexible(
                    child: GestureDetector(
                  onTap: controller.toForgetPassword,
                  child: AppText(
                    str: '忘记密码'.ts + '？',
                    color: AppColors.green,
                    alignment: TextAlign.end,
                    lines: 2,
                  ),
                )),
              ],
            ),
            20.verticalSpaceFromWidth,
            SizedBox(
              height: 38.h,
              width: double.infinity,
              child: BeeButton(
                text: '登录',
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
              )),
          onSubmitted: (res) {
            FocusScope.of(context).requestFocus(controller.validation);
          },
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
      child: TextField(
        obscureText: true,
        style: const TextStyle(color: Colors.black87),
        controller: controller.validationController,
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
              width: 1, color: AppColors.line, style: BorderStyle.solid),
        ),
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
                      style: TextStyle(
                        fontSize: 16.sp, //textsize
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15.sp,
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
