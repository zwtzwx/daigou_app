import 'package:get/get.dart';
import 'package:shop_app_client/views/user/logged_guide/controller.dart';

class LoggedGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoggedGuideController());
  }
}
