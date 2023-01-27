import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/vip/growth_value/growth_value_controller.dart';

class GrowthValueBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GrowthValueController());
  }
}
