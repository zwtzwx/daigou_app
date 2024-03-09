import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/shop/order/shop_order_controller.dart';

class ShopOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderController());
  }
}
