import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/parcel/parcel_detail/parcel_detail_controller.dart';

class ParcelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ParcelDetailController());
  }
}
