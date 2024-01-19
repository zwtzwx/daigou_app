import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/order/detail/order_detail_controller.dart';

class BeeOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrderLogic());
  }
}
