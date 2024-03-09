import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeStorage {
  static String uniqueKey = 'notice-unique';

  static void setUniqueId(String data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    // SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(uniqueKey, data);
  }

  static String getUniqueId() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    // SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(uniqueKey) ?? '';
  }
}
