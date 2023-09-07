import 'package:get/get.dart';

import 'controller.dart';

class GroupOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupOrderController>(() => GroupOrderController());
  }
}
