import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/input/input_text_item.dart';
import 'package:huanting_shop/views/components/input/normal_input.dart';
import 'package:huanting_shop/views/user/bind_info/bind_info_controller.dart';

class BeePhonePage extends GetView<BeePhoneLogic> {
  const BeePhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.1,
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: controller.flagBool.value == 1
                ? controller.phoneFlag.value
                    ? '更改手机号'.ts
                    : '绑定手机'.ts
                : controller.emailFlag.value
                    ? '更换邮箱'.ts
                    : '绑定邮箱'.ts,
            color: AppColors.textBlack,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: AppColors.bgGray,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 38.h,
          margin: EdgeInsets.symmetric(horizontal: 14.w),
          child: BeeButton(
            text: '确定',
            onPressed: controller.onSubmit,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: <Widget>[
                InputTextItem(
                  title: controller.flagBool.value == 1 ? '联系电话'.ts : '现邮箱'.ts,
                  inputText: Container(
                    height: 55,
                    alignment: Alignment.centerLeft,
                    child: AppText(
                      str: controller.flagBool.value == 1
                          ? controller.userInfo?.phone ?? '无'.ts
                          : controller.userInfo?.email ?? '无'.ts,
                    ),
                  ),
                ),
                InputTextItem(
                  height: 55,
                  title: controller.flagBool.value == 2 ? '新邮箱'.ts : '新号码'.ts,
                  inputText: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        controller.flagBool.value == 1
                            ? GestureDetector(
                                onTap: controller.onTimezone,
                                child: Row(
                                  children: [
                                    AppText(
                                      str: '+' +
                                          controller.formatTimezone(
                                              controller.timezone.value),
                                    ),
                                    AppGaps.hGap4,
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: AppColors.textNormal,
                                    ),
                                    AppGaps.hGap5,
                                  ],
                                ),
                              )
                            : AppGaps.empty,
                        Expanded(
                            child: NormalInput(
                          hintText: controller.flagBool.value == 2
                              ? '请输入新邮箱'.ts
                              : '请输入新号码'.ts,
                          textAlign: TextAlign.left,
                          contentPadding: const EdgeInsets.only(left: 0),
                          controller: controller.newNumberController,
                          focusNode: controller.newNumber,
                          autoFocus: false,
                          keyboardType: TextInputType.text,
                          onSubmitted: (res) {
                            FocusScope.of(context)
                                .requestFocus(controller.validation);
                          },
                          onChanged: (res) {
                            controller.mobileNumber.value = res;
                          },
                        ))
                      ],
                    ),
                  ),
                ),
                InputTextItem(
                  title: '验证码'.ts,
                  isRequired: true,
                  inputText: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: NormalInput(
                          hintText: '请输入验证码'.ts,
                          textAlign: TextAlign.left,
                          contentPadding: const EdgeInsets.only(left: 0),
                          controller: controller.validationController,
                          focusNode: controller.validation,
                          autoFocus: false,
                          keyboardType: TextInputType.text,
                          onChanged: (res) {
                            controller.verifyCode.value = res;
                          },
                        )),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 150.w,
                          ),
                          child: Container(
                            margin:
                                EdgeInsets.only(right: 15.w, top: 8, bottom: 8),
                            child: BeeButton(
                              text: controller.sent.value,
                              backgroundColor: controller.isButtonEnable.value
                                  ? AppColors.primary
                                  : AppColors.bgGray,
                              textColor: controller.isButtonEnable.value
                                  ? AppColors.textDark
                                  : Colors.grey,
                              onPressed: controller.onGetCode,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
