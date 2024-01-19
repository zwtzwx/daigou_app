import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/vip/growth_value/growth_value_controller.dart';

class BeeValuesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeValuesLogic());
  }
}
