import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/shop/center/shop_center_controller.dart';

class ShopCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopCenterController());
  }
}
