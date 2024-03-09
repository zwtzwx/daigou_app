import 'package:get/get.dart';
import 'package:shop_app_client/views/shop/manual_order/controller.dart';

class ManualOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ManualOrderController());
  }
}
