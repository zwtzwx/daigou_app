import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/line/detail/line_detail_controller.dart';

class LineDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LineDetailController());
  }
}
