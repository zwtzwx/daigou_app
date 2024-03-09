import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/shop/center/shop_center_controller.dart';

class ShopCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopCenterController());
  }
}
