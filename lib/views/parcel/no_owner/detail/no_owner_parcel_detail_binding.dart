import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/parcel/no_owner/detail/no_owner_parcel_detail_controller.dart';

class NoOwnerParcelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoOwnerParcelDetailController());
  }
}
