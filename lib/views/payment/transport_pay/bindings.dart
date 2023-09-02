import 'package:get/get.dart';

import 'controller.dart';

class TransportPayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransportPayController>(() => TransportPayController());
  }
}
