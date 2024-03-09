import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/order/tracking/tracking_controller.dart';

class BeeOrderTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrderTrackLogic());
  }
}
