import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupOrderDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeGroupOrderDetailController>(
        () => BeeGroupOrderDetailController());
  }
}
