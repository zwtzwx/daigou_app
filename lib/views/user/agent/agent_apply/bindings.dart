import 'package:get/get.dart';

import 'controller.dart';

class AgentApplyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentApplyController>(() => AgentApplyController());
  }
}
