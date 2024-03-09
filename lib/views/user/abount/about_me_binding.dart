import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/abount/about_me_controller.dart';

class BeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeLogic());
  }
}
