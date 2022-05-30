import 'dart:convert';

import 'package:jiyun_app_client/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static String tokenSpKey = "jiyun-token";
  static String userInfo = 'jiyun-user-info';
  static String agentStatus = 'agentStatus';
  static String environmentKey = 'environment';

  static Future<void> clearToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(userInfo, '');
    sp.setString(tokenSpKey, '');
  }

  static Future<String> getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(tokenSpKey) ?? '';
  }

  static Future<bool> setToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(tokenSpKey, token);
  }

  static Future<UserModel?> getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final jsonStr = sp.getString(userInfo);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(jsonStr);
      final model = UserModel.fromJson(json);
      return model;
    }
    return null;
  }

  static Future<bool> setUserInfo(UserModel v) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(userInfo, jsonEncode(v.toJson()));
  }

  static Future<bool> setEnvironment(String data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString(environmentKey, data);
  }

  static Future<String> getEnvironment() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(environmentKey) ?? 'production';
  }
}
