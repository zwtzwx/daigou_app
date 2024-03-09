import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/address/list/address_list_controller.dart';

class BeeShippingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeShippingLogic());
  }
}
