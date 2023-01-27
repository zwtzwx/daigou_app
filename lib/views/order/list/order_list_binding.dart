import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/order/list/order_list_controller.dart';

class OrderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderListController());
  }
}
