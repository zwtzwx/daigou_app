import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/line/query_result/line_query_result_controller.dart';

class LineQueryResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LineQueryResultController());
  }
}
