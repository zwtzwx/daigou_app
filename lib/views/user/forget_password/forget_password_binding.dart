import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/forget_password/forget_password_controller.dart';

class BeeResetPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeResetPwdLogic());
  }
}
