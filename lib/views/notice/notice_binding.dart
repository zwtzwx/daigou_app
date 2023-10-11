import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/notice/notice_controller.dart';

class InformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InformationLogic());
  }
}
