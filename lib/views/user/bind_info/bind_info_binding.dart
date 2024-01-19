import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/bind_info/bind_info_controller.dart';

class BeePhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeePhoneLogic());
  }
}
