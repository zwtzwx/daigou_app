import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/address/list/address_list_controller.dart';

class AddressListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddressListController());
  }
}
