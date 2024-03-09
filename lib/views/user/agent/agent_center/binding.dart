import 'package:get/get.dart';
import 'package:shop_app_client/views/user/agent/agent_center/controller.dart';

class AgentCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentCenterController());
  }
}
