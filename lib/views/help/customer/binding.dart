import 'package:get/get.dart';
import 'package:shop_app_client/views/help/customer/controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomerController());
  }
}
