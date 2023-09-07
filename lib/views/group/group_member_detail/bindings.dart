import 'package:get/get.dart';

import 'controller.dart';

class GroupMemberDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupMemberDetailController>(() => GroupMemberDetailController());
  }
}
