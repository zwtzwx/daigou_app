import 'package:get/get.dart';

import 'controller.dart';

class BeeQusBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeQusLogic>(() => BeeQusLogic());
  }
}
