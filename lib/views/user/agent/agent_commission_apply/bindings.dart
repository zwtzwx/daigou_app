import 'package:get/get.dart';

import 'controller.dart';

class AgentCommissionApplyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentCommissionApplyController>(() => AgentCommissionApplyController());
  }
}
