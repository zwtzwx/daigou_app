import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageStore {
  static const String languageKey = 'language';
  static const String translateKey = 'translate';
  static const String currencyKey = 'currency';

  static void setLanguage(String data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(languageKey, data);
  }

  static String getLanguage() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    return sp.getString(languageKey) ?? 'zh_CN';
  }

  static void setTranslate(Map<String, dynamic> data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(translateKey, jsonEncode(data));
  }

  static Map<String, dynamic>? geTranslate() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    var value = sp.getString(translateKey);
    return value == null ? null : jsonDecode(value);
  }

  static Future<void> setCurrency(String data) async {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(currencyKey, data);
  }

  static Future<Map?> getCurrency() async {
    SharedPreferences sp = Get.find<SharedPreferences>();
    // sp.remove(currencyKey);
    var data = sp.getString(currencyKey);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
}
