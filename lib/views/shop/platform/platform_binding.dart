import 'package:get/get.dart';
import 'package:huanting_shop/views/shop/platform/platform_controller.dart';

class PlatformBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlatformController());
  }
}
