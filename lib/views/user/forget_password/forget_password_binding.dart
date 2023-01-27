import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/forget_password/forget_password_controller.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgetPasswordController());
  }
}
