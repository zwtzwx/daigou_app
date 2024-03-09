import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/shop/chat_detail/order_chat_detail_controller.dart';

class ShopOrderChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderChatDetailController());
  }
}
