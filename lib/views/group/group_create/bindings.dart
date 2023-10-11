import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupCreateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeGroupCreateController>(() => BeeGroupCreateController());
  }
}
