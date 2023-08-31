import 'package:get/get.dart';

import 'controller.dart';

class HelpCenterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpCenterController>(() => HelpCenterController());
  }
}
