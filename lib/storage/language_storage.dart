import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageStore {
  static const String languageKey = 'language';

  static void setLanguage(String data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    // SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(languageKey, data);
  }

  static String getLanguage() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    // SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(languageKey) ?? 'zh_CN';
  }
}
