import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/webview/webview_controller.dart';

class BeeWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeWebviewLogic());
  }
}
