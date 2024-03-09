import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/vip/point/point_controller.dart';

class IntergralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IntergralLogic());
  }
}
