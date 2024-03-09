import 'package:get/get.dart';
import 'package:shop_app_client/views/order/comment/controller.dart';

class OrderCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderCommentController());
  }
}
