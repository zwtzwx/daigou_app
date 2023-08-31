import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/station/station_controller.dart';

class StationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StationController());
  }
}
