import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/order/list/order_list_controller.dart';

class BeeOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrdersLogic());
  }
}
