import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/shop/order_detail/order_detail_controller.dart';

class ShopOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderDetailController());
  }
}
