import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/vip/point/point_controller.dart';

class PointBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PointController());
  }
}
