import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/profile/profile_controller.dart';

class BeeUserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeUserInfoLogic());
  }
}
