import 'package:get/instance_manager.dart';
import 'package:huanting_shop/views/line/query_result/line_query_result_controller.dart';

class LineQueryResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LineQueryResultController());
  }
}
