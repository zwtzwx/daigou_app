import 'package:get/get.dart';
import 'package:shop_app_client/views/user/agent/agent_apply_instruction/controller.dart';

class AgentApplyInstructionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentApplyInstructionController());
  }
}
