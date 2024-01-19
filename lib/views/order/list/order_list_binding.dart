import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/order/list/order_list_controller.dart';

class BeeOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrdersLogic());
  }
}
