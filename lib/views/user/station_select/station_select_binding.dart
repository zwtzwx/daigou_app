import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/station_select/station_select_controller.dart';

class StationSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StationSelectController());
  }
}
