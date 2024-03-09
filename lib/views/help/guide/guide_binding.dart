import 'package:get/get.dart';
import 'package:shop_app_client/views/help/guide/guide_controller.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideController());
  }
}
