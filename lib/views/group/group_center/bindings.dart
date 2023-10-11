import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeGroupController>(() => BeeGroupController());
  }
}
