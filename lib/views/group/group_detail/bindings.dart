import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupDetailBinding implements Bindings {
  BeeGroupDetailBinding();

  @override
  void dependencies() {
    Get.lazyPut<BeeGroupDetailController>(() => BeeGroupDetailController());
  }
}
