import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/vip/center/vip_center_controller.dart';

class BeeSuperUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeSuperUserLogic());
  }
}
