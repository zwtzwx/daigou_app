import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/express/express_query_controller.dart';

class BeeTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeTrackingController());
  }
}
