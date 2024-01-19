import 'package:get/get.dart';
import 'package:huanting_shop/views/shop/manual_order/controller.dart';

class ManualOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ManualOrderController());
  }
}
