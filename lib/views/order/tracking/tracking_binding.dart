import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/order/tracking/tracking_controller.dart';

class BeeOrderTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeOrderTrackLogic());
  }
}
