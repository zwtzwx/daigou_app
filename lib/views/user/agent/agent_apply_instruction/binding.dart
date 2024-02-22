import 'package:get/get.dart';
import 'package:huanting_shop/views/user/agent/agent_apply_instruction/controller.dart';

class AgentApplyInstructionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentApplyInstructionController());
  }
}
