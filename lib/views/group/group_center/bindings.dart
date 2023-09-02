import 'package:get/get.dart';

import 'controller.dart';

class GroupCenterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupCenterController>(() => GroupCenterController());
  }
}
