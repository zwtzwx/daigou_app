import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/line/query/line_query_controller.dart';

class LineQueryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LineQueryController());
  }
}
