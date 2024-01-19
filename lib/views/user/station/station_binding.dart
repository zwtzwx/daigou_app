import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/station/station_controller.dart';

class StationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StationController());
  }
}
