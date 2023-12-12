import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/user/setting_password/setting_password_controller.dart';

class BeeNewPwdPage extends GetView<BeeNewPwdLogic> {
  const BeeNewPwdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        elevation: 0.5,
        title: AppText(
          str: '修改密码'.ts,
          fontSize: 18,
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        child: SafeArea(
          child: SizedBox(
            height: 33.h,
            child: BeeButton(
              text: '提交',
              onPressed: controller.onSubmit,
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.bgGray,
      body: Column(
        children: [
          InputTextItem(
            title: '新密码'.ts,
            isRequired: true,
            inputText: NormalInput(
              hintText: '请输入新密码'.ts,
              contentPadding: const EdgeInsets.only(right: 15),
              controller: controller.newPasswordController,
              focusNode: controller.newPaddwordNode,
              autoFocus: false,
              isScureText: true,
              maxLines: 1,
              onSubmitted: (value) {
                FocusScope.of(context)
                    .requestFocus(controller.confirmPaddwordNode);
              },
              keyboardType: TextInputType.text,
            ),
          ),
          InputTextItem(
            title: '确认密码'.ts,
            isRequired: true,
            inputText: NormalInput(
              hintText: '请确认密码'.ts,
              contentPadding: const EdgeInsets.only(right: 15),
              controller: controller.confirmPasswordController,
              focusNode: controller.confirmPaddwordNode,
              autoFocus: false,
              isScureText: true,
              maxLines: 1,
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}
