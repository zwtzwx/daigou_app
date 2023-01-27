import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/order/detail/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderDetailController());
  }
}
