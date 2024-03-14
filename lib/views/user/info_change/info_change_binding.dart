import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/info_change/info_change_controller.dart';

class BeeInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeInfoLogic());
  }
}