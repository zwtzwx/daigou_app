// 这里是通过配置文件
// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // 上线

  static const bool isTest = true;

  static Future<String> getEnvironment() async {
    String environment = await UserStorage.getEnvironment();
    return environment;
  }

  static String getBaseApi() {
    return dotenv.env['API_URL'] ?? "https://dev-api.haiouoms.com/api/client/";
  }

  static Future<String> getUUID() async {
    return dotenv.env['UUID'] ?? "4b8ab68b-7cf7-4e3b-9c00-cbd4dbf96f27";
  }
}
