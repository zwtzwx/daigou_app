import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/parcel/parcel_detail/parcel_detail_controller.dart';

class BeePackageDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeePackageDetailLogic());
  }
}
