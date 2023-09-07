import 'package:get/get.dart';

import 'controller.dart';

class GroupDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupDetailController>(() => GroupDetailController());
  }
}
