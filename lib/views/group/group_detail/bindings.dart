import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeGroupDetailController>(() => BeeGroupDetailController());
  }
}
