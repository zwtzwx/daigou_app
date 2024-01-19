import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/payment/recharge/recharge_controller.dart';

class RechargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RechargeController());
  }
}
