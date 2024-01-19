import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/warehouse/warehouse_controller.dart';

class BeeCangKuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeCangKuLogic());
  }
}
