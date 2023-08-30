import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/localization_model.dart';

class BaseController extends GetxController {
  LocalizationModel? localModel = Get.find<LocalizationModel?>();

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
