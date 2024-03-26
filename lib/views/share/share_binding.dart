import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/share/share_controller.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShareLogic());
  }
}
