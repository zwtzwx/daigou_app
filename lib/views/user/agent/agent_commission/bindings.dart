import 'package:get/get.dart';

import 'controller.dart';

class AgentCommissionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentCommissionController>(() => AgentCommissionController());
  }
}
