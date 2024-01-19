import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/parcel/no_owner/list/no_owner_parcel_controller.dart';

class AbnomalParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AbnomalParcelLogic());
  }
}
