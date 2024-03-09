import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/bind_info/bind_info_controller.dart';

class BeePhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeePhoneLogic());
  }
}
