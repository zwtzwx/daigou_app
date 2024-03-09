import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/shop/order_chat/shop_order_chat_controller.dart';

class ShopOrderChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderChatController());
  }
}
