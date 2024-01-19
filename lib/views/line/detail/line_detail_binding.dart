import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/line/detail/line_detail_controller.dart';

class LineDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LineDetailController());
  }
}
