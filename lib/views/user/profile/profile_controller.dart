import 'dart:io';

import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/services/user_service.dart';

class BeeUserInfoLogic extends GlobalLogic {
  final btnList = <Map<String, dynamic>>[
    {
      'name': '更换手机号',
      'route': BeeNav.changeMobileAndEmail,
      'params': {'type': 1},
    },
    {
      'name': '更换邮箱',
      'route': BeeNav.changeMobileAndEmail,
      'params': {'type': 2},
    },
    {
      'name': '更改密码',
      'route': BeeNav.password,
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
      BeeNav.redirect(BeeNav.home);
    } else {
      showError(res['msg']);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
