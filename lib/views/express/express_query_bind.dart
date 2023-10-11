import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/express/express_query_controller.dart';

class BeeTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeTrackingController());
  }
}
