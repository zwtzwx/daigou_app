import 'package:shared_preferences/shared_preferences.dart';

class LanguageStore {
  static const String languageKey = 'language';

  static Future<void> setLanguage(String data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(languageKey, data);
  }

  static Future<String> getLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(languageKey) ?? 'zh_CN';
  }
}
