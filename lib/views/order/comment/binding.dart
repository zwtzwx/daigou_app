import 'package:get/get.dart';
import 'package:huanting_shop/views/order/comment/controller.dart';

class OrderCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderCommentController());
  }
}
