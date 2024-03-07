import 'package:get/get.dart';
import 'package:huanting_shop/views/help/customer/controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomerController());
  }
}
