import 'package:get/get.dart';
import 'package:shop_app_client/views/shop/cart/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController());
  }
}
