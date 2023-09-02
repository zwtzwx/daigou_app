import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageStore {
  static const String languageKey = 'language';
  static const String currencyKey = 'currency';

  static void setLanguage(String data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(languageKey, data);
  }

  static String getLanguage() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    return sp.getString(languageKey) ?? 'zh_CN';
  }

  static Future<void> setCurrency(String data) async {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(currencyKey, data);
  }

  static Future<Map?> getCurrency() async {
    SharedPreferences sp = Get.find<SharedPreferences>();
    var data = sp.getString(currencyKey);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
}
