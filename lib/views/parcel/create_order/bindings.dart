import 'package:get/get.dart';

import 'controller.dart';

class CreateOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderController>(() => CreateOrderController());
  }
}
