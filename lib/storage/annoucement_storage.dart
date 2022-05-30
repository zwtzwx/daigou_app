import 'package:shared_preferences/shared_preferences.dart';

class AnnoucementStorage {
  static String uniqueKey = 'notice-unique';

  static Future<void> setUniqueId(String data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(uniqueKey, data);
  }

  static Future<String> getUniqueId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(uniqueKey) ?? '';
  }
}
