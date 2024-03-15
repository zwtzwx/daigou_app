import 'dart:io';

import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/user_service.dart';

class BeeUserInfoLogic extends GlobalController {
  final btnList = <Map<String, dynamic>>[
    {
      'name': '更换手机号',
      'route': GlobalPages.changeMobileAndEmail,
      'params': {'type': 1},
    },
    {
      'name': '更换邮箱',
      'route': GlobalPages.changeMobileAndEmail,
      'params': {'type': 2},
    },
    {
      'name': '更改密码',
      'route': GlobalPages.password,
    },
    {
      'name': '关于我们',
      'route': GlobalPages.abountMe,
    },
  ].obs;

  final userInfoModel = Get.find<AppStore>();

  @override
  onInit() {
    super.onInit();
    getStatus();
  }

  getStatus() async {
    var result = await UserService.getThirdLoginStatus();
    if (!result && Platform.isIOS) {
      btnList.add(
        {
          'name': '注销账号',
        },
      );
    }
  }

  // 注销
  onLogout() async {
    showLoading();
    var res = await UserService.userDeletion();
    hideLoading();
    if (res['ok']) {
      showSuccess('注销成功');
      userInfoModel.clear();
      GlobalPages.redirect(GlobalPages.home);
    } else {
      showError(res['msg']);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
