import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/user/abount/about_me_controller.dart';

class BeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeLogic());
  }
}
