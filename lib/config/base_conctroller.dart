import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';

class GlobalLogic extends GetxController {
  final currencyModel = Get.find<AppStore>().currencyModel;
  final localModel = Get.find<AppStore>().localModel;

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

  void onCopyData(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
    showSuccess('复制成功');
  }
}
