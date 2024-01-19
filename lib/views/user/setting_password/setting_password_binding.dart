import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/setting_password/setting_password_controller.dart';

class BeeNewPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeNewPwdLogic());
  }
}
