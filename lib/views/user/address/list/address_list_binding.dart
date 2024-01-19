import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/address/list/address_list_controller.dart';

class BeeShippingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeShippingLogic());
  }
}
