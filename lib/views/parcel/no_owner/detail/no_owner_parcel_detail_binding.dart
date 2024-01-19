import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/parcel/no_owner/detail/no_owner_parcel_detail_controller.dart';

class BeeParcelClaimBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeParcelClaimLogic());
  }
}
