import 'package:get/get.dart';

import 'controller.dart';

class GroupOrderProcessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupOrderProcessController>(() => GroupOrderProcessController());
  }
}
