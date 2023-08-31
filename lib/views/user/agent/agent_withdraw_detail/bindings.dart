import 'package:get/get.dart';

import 'controller.dart';

class AgentWithdrawDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentWithdrawDetailController>(() => AgentWithdrawDetailController());
  }
}
