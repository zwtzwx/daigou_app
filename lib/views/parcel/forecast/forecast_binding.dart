import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/parcel/forecast/forecast_controller.dart';

class ForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForecastController());
  }
}
