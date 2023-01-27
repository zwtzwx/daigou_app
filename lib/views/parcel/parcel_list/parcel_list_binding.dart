import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/parcel/parcel_list/parcel_list_controller.dart';

class ParcelListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ParcelListController());
  }
}
