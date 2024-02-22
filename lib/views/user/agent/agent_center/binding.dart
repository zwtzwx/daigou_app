import 'package:get/get.dart';
import 'package:huanting_shop/views/user/agent/agent_center/controller.dart';

class AgentCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentCenterController());
  }
}
