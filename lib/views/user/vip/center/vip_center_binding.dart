import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/vip/center/vip_center_controller.dart';

class VipCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VipCenterController());
  }
}
