import 'package:get/get.dart';

import 'controller.dart';

class AgentMemberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentMemberController>(() => AgentMemberController());
  }
}
