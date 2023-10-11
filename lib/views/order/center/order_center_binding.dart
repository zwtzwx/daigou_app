import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/order/center/order_center_controller.dart';

class BeeOrderIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrderIndexLogic());
  }
}
