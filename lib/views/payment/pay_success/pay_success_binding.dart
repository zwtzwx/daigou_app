import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/payment/pay_success/pay_success_controller.dart';

class PaySuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaySuccessController());
  }
}
