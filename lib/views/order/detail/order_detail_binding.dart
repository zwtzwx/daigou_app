import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/order/detail/order_detail_controller.dart';

class BeeOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrderLogic());
  }
}
