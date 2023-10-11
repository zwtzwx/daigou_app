import 'package:get/get.dart';

import 'controller.dart';

class BeeSupportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeeSupportLogic>(() => BeeSupportLogic());
  }
}
