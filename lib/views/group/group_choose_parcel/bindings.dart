import 'package:get/get.dart';

import 'controller.dart';

class BeeGroupParcelSelectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeGroupParcelSelectController>(
        () => BeeGroupParcelSelectController());
  }
}
