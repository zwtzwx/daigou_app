import 'package:get/get.dart';

import 'controller.dart';

class TransferPaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferPaymentController>(() => TransferPaymentController());
  }
}
