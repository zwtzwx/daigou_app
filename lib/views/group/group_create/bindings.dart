import 'package:get/get.dart';

import 'controller.dart';

class GroupCreateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupCreateController>(() => GroupCreateController());
  }
}
