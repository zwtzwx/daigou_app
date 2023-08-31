import 'package:get/get.dart';

import 'controller.dart';

class RechargeHistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RechargeHistoryController>(() => RechargeHistoryController());
  }
}
