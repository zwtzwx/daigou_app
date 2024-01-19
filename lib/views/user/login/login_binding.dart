import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/login/login_controller.dart';

class BeeSignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeSignInLogic());
  }
}
