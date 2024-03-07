import 'package:get/get.dart';
import 'package:huanting_shop/views/user/setting_locale/controller.dart';

class SettingLocaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingLocaleController());
  }
}
