import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
