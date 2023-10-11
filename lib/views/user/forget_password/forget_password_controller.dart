import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
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

class BeeResetPwdLogic extends GlobalLogic {
  final loginType = 2.obs; //  1 手机号 2 邮箱

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final sent = '发送验证码'.ts.obs;

  final isButtonEnable = true.obs;

  final timer = Rxn<Timer?>();

  final count = 60.obs;

  final codeColor = AppColors.textBlack.obs;

  // 新号码
  final TextEditingController mobileNumberController = TextEditingController();
  // 新号码
  final TextEditingController emailController = TextEditingController();
  // 验证码
  final TextEditingController validationController = TextEditingController();
  final FocusNode validation = FocusNode();

  // 电话区号
  final areaNumber = "0007".obs;
  // 电话号码
  final mobileNumber = "".obs;
  // 验证码
  final verifyCode = "".obs;
  final userModelInfo = Get.find<UserInfoModel>();

  // 选择手机区号
  void onTimezone() async {
    var s = await BeeNav.push(BeeNav.country);
    if (s != null) {
      CountryModel a = s as CountryModel;
      areaNumber.value = a.timezone!;
    }
  }

  // 获取验证码
  void getCode() async {
    if (isButtonEnable.value) {
      if (mobileNumberController.text.isEmpty) {
        if (loginType.value == 1) {
          showToast('请输入手机号');
        } else {
          showToast('请输入邮箱号');
        }
        return;
      }
      //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
      Map<String, dynamic> map = {
        'receiver': loginType.value == 1
            ? areaNumber + mobileNumberController.text
            : mobileNumberController.text,
        'action': 6 // 重置密码 获取验证码
      };
      showLoading();
      UserService.getVerifyCode(map, (data) {
        hideLoading();
        showSuccess(data.msg);
        onCountdown();
      }, (message) {
        hideLoading();
        showError(message);
      });
    }
  }

  String formatTimezone(String timezone) {
    var reg = RegExp(r'^0{1,}');
    return timezone.replaceAll(reg, '');
  }

  void onCountdown() {
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      _initTimer();
      codeColor.value = AppColors.textGray;
    }
  }

  void _initTimer() {
    timer.value = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      count.value--;
      if (count.value == 0) {
        timer.cancel(); //倒计时结束取消定时器
        isButtonEnable.value = true; //按钮可点击
        count.value = 60; //重置时间
        codeColor.value = AppColors.textBlack;
        sent.value = '发送验证码'.ts; //重置按钮文本
      } else {
        sent.value = '重新发送'.ts + '($count)'; //更新文本内容
      }
    });
  }

  onSubmit() async {
    try {
      Map<String, dynamic> map = {
        'account': loginType.value == 1
            ? areaNumber.value + mobileNumberController.text
            : mobileNumberController.text,
        'verify_code': validationController.text,
        'password': emailController.text,
        'confirm_password': emailController.text
      };
      TokenModel? tokenModel = await UserService.resetPaswordAndLogin(map);
      if (tokenModel == null) {
        return;
      }
      // 清除记住的账号密码
      Get.find<UserInfoModel>().clearAccount();
      //发送登录事件
      ApplicationEvent.getInstance().event.fire(LoginedEvent());
      ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent());
      //更新状态管理器
      userModelInfo.saveInfo(
          tokenModel.tokenType + ' ' + tokenModel.accessToken,
          tokenModel.user!);

      String? dt = UserStorage.getDeviceToken();
      if (dt != null) {
        await CommonService.saveDeviceToken({
          'type': 1,
          'token': dt,
        });
      }
      BeeNav.redirect(BeeNav.home);
    } catch (err) {
      EasyLoading.dismiss();
      CommonMethods.showToast(err.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    validationController.dispose();
    timer.value?.cancel(); //销毁计时器
    super.onClose();
  }
}
