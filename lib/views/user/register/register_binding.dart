import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/register/register_controller.dart';

class RegisterBingding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}
