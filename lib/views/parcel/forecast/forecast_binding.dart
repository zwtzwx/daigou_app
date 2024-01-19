import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/parcel/forecast/forecast_controller.dart';

class BeeParcelCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeParcelCreateLogic());
  }
}
