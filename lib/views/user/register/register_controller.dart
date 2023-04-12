import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/logined_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/token_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class RegisterController extends BaseController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // 新号码
  final TextEditingController mobileNumberController = TextEditingController();
  // 新号码
  final TextEditingController emailController = TextEditingController();
  // 密码
  final TextEditingController passwordController = TextEditingController();
  // 验证码
  final TextEditingController validationController = TextEditingController();

  RxString pageTitle = '注册'.ts.obs;
  RxInt loginType = 2.obs; // 1、手机号验证码 2: 邮箱验证码
  RxString sent = '获取验证码'.ts.obs;
  RxString code = ''.obs;
  RxBool isButtonEnable = true.obs;
  final timer = Rxn<Timer?>();
  RxInt count = 60.obs;
  Rx<Color> codeColor = BaseStylesConfig.textBlack.obs;
  // 电话区号
  RxString areaNumber = '0007'.obs;
  // 电话号码
  RxString mobileNumber = ''.obs;
  // 验证码
  RxString verifyCode = ''.obs;

  // 登录
  onRegister() async {
    try {
      showLoading();
      Map<String, dynamic> map = {
        'verify_code': validationController.text,
        'password': passwordController.text,
        'confirm_password': passwordController.text,
      };
      //  1 手机号验证码 2 邮箱验证码
      if (loginType.value == 2) {
        map['email'] = emailController.text;
      } else if (loginType.value == 1) {
        map['phone'] = areaNumber.value + mobileNumberController.text;
      }
      var res = await UserService.register(map);
      hideLoading();
      if (res['ok']) {
        await EasyLoading.showSuccess(res['msg']);
        Routers.pop(loginType.value == 1
            ? mobileNumberController.text
            : emailController.text);
      } else {
        showToast(res['msg']);
      }
    } catch (e) {
      hideLoading();
      showToast(e.toString());
    }
  }

  // 发送验证码
  void onGetCode() async {
    if (isButtonEnable.value) {
      //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
      // int LoginType = 1; //  2 手机号验证码 4邮箱验证码
      Map<String, dynamic> map = {
        'receiver': loginType.value == 1
            ? areaNumber + mobileNumberController.text
            : emailController.text,
        'action': loginType.value == 1
            ? 5 // 手机登录验证码
            : 4 // 邮箱登录验证码
      };
      showLoading();
      UserService.getVerifyCode(map, (data) {
        hideLoading();
        showSuccess(data.msg);

        sent.value = '重新发送'.ts + '  ($count)'; //更新文本内容
        buttonClickListen();
      }, (msg) {
        hideLoading();
        showError(msg.toString());
      });
    }
  }

  // 选择手机区号
  void onTimezone() async {
    var s = await Routers.push(Routers.country);
    if (s != null) {
      CountryModel a = s as CountryModel;
      areaNumber.value = a.timezone!;
    }
  }

  // 监听按钮是否可点击
  void buttonClickListen() {
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      codeColor.value = BaseStylesConfig.textGray;
      initTimer();
    }
  }

  void initTimer() {
    timer.value = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      count.value--;
      if (count.value == 0) {
        timer.cancel(); //倒计时结束取消定时器
        isButtonEnable.value = true; //按钮可点击
        count.value = 60; //重置时间
        codeColor.value = BaseStylesConfig.textBlack;
        sent.value = '发送验证码'.ts; //重置按钮文本
      } else {
        sent.value = '重新发送'.ts + ' ($count)'; //更新文本内容
      }
    });
  }

  String formatTimezone(String timezone) {
    var reg = RegExp(r'^0{1,}');
    return timezone.replaceAll(reg, '');
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    emailController.dispose();
    validationController.dispose();
    if (timer.value != null) {
      timer.value!.cancel(); //销毁计时器
      timer.value = null;
    }
    super.onClose();
  }
}
