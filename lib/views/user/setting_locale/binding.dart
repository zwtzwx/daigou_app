import 'package:get/get.dart';
import 'package:shop_app_client/views/user/setting_locale/controller.dart';

class SettingLocaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingLocaleController());
  }
}
