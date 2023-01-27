import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/address/add/address_add_edit_controller.dart';

class AddressAddEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddressAddEditController());
  }
}
