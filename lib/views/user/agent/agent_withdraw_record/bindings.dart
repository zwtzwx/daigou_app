import 'package:get/get.dart';

import 'controller.dart';

class AgentWithdrawRecordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentWithdrawRecordController>(() => AgentWithdrawRecordController());
  }
}
