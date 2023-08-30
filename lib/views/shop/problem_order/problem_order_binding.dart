import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/shop/problem_order/problem_order_controller.dart';

class ProblemOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProblemOrderController());
  }
}
