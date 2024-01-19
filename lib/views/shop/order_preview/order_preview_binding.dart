import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/shop/order_preview/order_preview_controller.dart';

class OrderPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderPreviewController());
  }
}
