import 'package:get/get.dart';

import 'controller.dart';

class AgentCommissionHistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentCommissionHistoryController>(() => AgentCommissionHistoryController());
  }
}
