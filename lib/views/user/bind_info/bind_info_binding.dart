import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/bind_info/bind_info_controller.dart';

class BindInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BindInfoController());
  }
}
