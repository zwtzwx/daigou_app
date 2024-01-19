import 'dart:convert';

import 'package:get/instance_manager.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static String tokenSpKey = "jiyun-token";
  static String userInfo = 'jiyun-user-info';
  static String agentStatus = 'agentStatus';
  static String deviceToken = 'device-token';
  static String accountInfo = 'account-info';
  static String versionTime = 'version-time';

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
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(userInfo, jsonEncode(v.toJson()));
  }

  static void setDeviceToken(String data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(deviceToken, data);
  }

  static String? getDeviceToken() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    return sp.getString(deviceToken);
  }

  // 账号密码信息
  static void setAccountInfo(Map data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setString(accountInfo, jsonEncode(data));
  }

  static void clearnAccountInfo() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.remove(accountInfo);
  }

  static Map? getAccountInfo() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    var json = sp.getString(accountInfo);
    if (json != null) {
      return jsonDecode(json);
    }
    return null;
  }

  // 版本更新时间
  static void setVersionTime(int data) {
    SharedPreferences sp = Get.find<SharedPreferences>();
    sp.setInt(versionTime, data);
  }

  static int? getVersionTime() {
    SharedPreferences sp = Get.find<SharedPreferences>();
    return sp.getInt(versionTime);
  }
}
