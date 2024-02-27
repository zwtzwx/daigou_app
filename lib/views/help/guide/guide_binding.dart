import 'package:get/get.dart';
import 'package:huanting_shop/views/help/guide/guide_controller.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideController());
  }
}
