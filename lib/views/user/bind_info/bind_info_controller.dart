import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';

class BeePhoneLogic extends GlobalLogic {
  final textEditingController = TextEditingController();
  final timezone = '0007'.obs;
  final sent = '获取验证码'.obs;
  final isButtonEnable = true.obs;
  final resetTimer = Rxn<Timer?>();
  final count = 60.obs;
  final codeColor = '#FFFFFF'.obs;
  final flagBool = 0.obs; // 1 改手机号  2 改邮箱号（绑定邮箱）
  final emailFlag = false.obs; // true 更换绑定邮箱  false 绑定邮箱
  final phoneFlag = false.obs; // true 更换手机号  false 绑定手机号

// 旧手机号
  final oldPhoneNumber = "".obs;
// 新联系电话
  final mobileNumber = "".obs;
// 验证码
  final verifyCode = "".obs;

  // 新号码
  final TextEditingController newNumberController = TextEditingController();
  final FocusNode newNumber = FocusNode();
  // 验证码
  final TextEditingController validationController = TextEditingController();
  final FocusNode validation = FocusNode();

  UserModel? userInfo = Get.find<UserInfoModel>().userInfo.value;

  @override
  void onReady() {
    super.onReady();
    var arguments = Get.arguments;
    flagBool.value = arguments['type'];
    if (flagBool.value == 1) {
      phoneFlag.value = userInfo!.phone != null && userInfo!.phone!.isNotEmpty;
    } else {
      emailFlag.value = userInfo!.email != null && userInfo!.email!.isNotEmpty;
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (resetTimer.value?.isActive ?? false) {
      resetTimer.value?.cancel();
    }
    validation.dispose();
    newNumber.dispose();
  }

  // 发送验证码
  onGetCode() {
    if (isButtonEnable.value) {
      //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
      UserService.getVerifyCode({
        'receiver': (flagBool.value == 1 ? timezone.value : '') +
            newNumberController.text,
        'action': flagBool.value == 1
            ? 3 // 更改手机号
            : emailFlag.value
                ? 2 // 更改邮箱
                : 1 // 绑定邮箱
      }, (data) {
        if (data.ok) {
          _buttonClickListen();
        }
      }, (message) {});
    }
  }

  // 绑定
  onSubmit() async {
    if (flagBool.value == 1) {
      Map<String, dynamic> params = {
        'phone': timezone.value + newNumberController.text,
        'code': verifyCode.value,
      };
      await UserService.changePhone(params, (msg) {
        onResult(true, msg);
      }, (error) => onResult(false, error));
    } else {
      Map<String, dynamic> params = {
        'email': newNumberController.text,
        'code': verifyCode.value,
      };
      if (emailFlag.value) {
        await UserService.changeEmail(params, (msg) {
          onResult(true, msg);
        }, (error) => onResult(false, error));
      } else {
        await UserService.bindEmail(params, (msg) {
          onResult(true, msg);
        }, (error) => onResult(false, error));
      }
    }
  }

  onResult(bool ok, String msg) {
    if (ok) {
      BeeNav.pop();
    }
  }

  // 选择手机区号
  void onTimezone() async {
    var s = await BeeNav.push(BeeNav.country);
    if (s != null) {
      CountryModel a = s as CountryModel;
      timezone.value = a.timezone!;
    }
  }

  String formatTimezone(String timezone) {
    var reg = RegExp(r'^0{1,}');
    return timezone.replaceAll(reg, '');
  }

  void _buttonClickListen() {
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      _initTimer();
    }
  }

  void _initTimer() {
    resetTimer.value =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      count.value--;
      if (count.value == 0) {
        timer.cancel(); //倒计时结束取消定时器
        isButtonEnable.value = true; //按钮可点击
        count.value = 60; //重置时间
        codeColor.value = '#8A8A8A';
        sent.value = '获取验证码'; //重置按钮文本
      } else {
        sent.value = '重新发送'.ts + '($count)'; //更新文本内容
      }
    });
  }
}
