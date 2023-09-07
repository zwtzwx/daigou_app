import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/state/i10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalInject {
  static Future<void> init() async {
    await Get.putAsync<SharedPreferences>(
        () => SharedPreferences.getInstance());
    Get.put(UserInfoModel());
    Get.put(I10n());
  }
}
