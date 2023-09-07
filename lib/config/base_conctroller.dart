import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/services/localization_service.dart';

class BaseController extends GetxController {
  final currencyModel = Get.find<UserInfoModel>().currencyModel;
  final localModel = Get.find<UserInfoModel>().localModel;

  // @override
  // onInit() {
  //   super.onInit();
  //   bool localModelRegister = Get.isRegistered<LocalizationModel?>();
  //   if (localModelRegister) {
  //     localModel = Get.find<LocalizationModel?>();
  //   } else {
  //     _initLocalization();
  //   }
  // }

  // void _initLocalization() async {
  //   var data = await LocalizationService.getInfo();
  //   if (data != null) {
  //     Get.put(data);
  //     localModel = data;
  //   }
  // }

  showToast(String msg) {
    EasyLoading.showToast(msg.ts);
  }

  Future<void> showSuccess(String msg) {
    return EasyLoading.showSuccess(msg.ts);
  }

  showError(String msg) {
    EasyLoading.showError(msg.ts);
  }

  showLoading([String? msg]) {
    EasyLoading.show(status: (msg ?? '加载中').ts);
  }

  hideLoading() {
    EasyLoading.dismiss();
  }
}
