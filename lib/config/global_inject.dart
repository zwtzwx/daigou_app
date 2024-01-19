import 'package:get/instance_manager.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/state/i10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstanceInit {
  static Future<void> init() async {
    await Get.putAsync<SharedPreferences>(
        () => SharedPreferences.getInstance());
    Get.put(AppStore());
    Get.put(I10n());
  }
}
