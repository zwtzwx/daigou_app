import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/shop/chat_detail/order_chat_detail_controller.dart';

class ShopOrderChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopOrderChatDetailController());
  }
}
