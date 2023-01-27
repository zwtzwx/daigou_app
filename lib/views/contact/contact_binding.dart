import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/contact/contact_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ContactController());
  }
}
