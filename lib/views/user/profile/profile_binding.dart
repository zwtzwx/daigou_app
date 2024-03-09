import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/profile/profile_controller.dart';

class BeeUserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeUserInfoLogic());
  }
}
