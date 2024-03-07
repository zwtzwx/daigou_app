import 'package:get/get.dart';
import 'package:huanting_shop/views/user/logged_guide/controller.dart';

class LoggedGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoggedGuideController());
  }
}
