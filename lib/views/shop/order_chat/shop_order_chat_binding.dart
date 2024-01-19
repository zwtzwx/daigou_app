import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/shop/order_chat/shop_order_chat_controller.dart';

class ShopOrderChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderChatController());
  }
}
