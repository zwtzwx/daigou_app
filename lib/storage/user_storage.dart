import 'dart:convert';

import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static String tokenSpKey = "jiyun-token";
  static String userInfo = 'jiyun-user-info';
  static String agentStatus = 'agentStatus';
  static String deviceToken = 'device-token';

  static void clearToken() {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(userInfo, '');
    sp.setString(tokenSpKey, '');
  }

  static String getToken() {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    return sp.getString(tokenSpKey) ?? '';
  }

  static void setToken(String token) {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(tokenSpKey, token);
  }

  static UserModel? getUserInfo() {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    final jsonStr = sp.getString(userInfo);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(jsonStr);
      final model = UserModel.fromJson(json);
      return model;
    }
    return null;
  }

  static void setUserInfo(UserModel v) {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(userInfo, jsonEncode(v.toJson()));
  }

  static void setDeviceToken(String data) {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(deviceToken, data);
  }

  static String? getDeviceToken() {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    SharedPreferences sp = Get.find<SharedPreferences>();
    return sp.getString(deviceToken);
  }
}
