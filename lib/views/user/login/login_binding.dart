import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
