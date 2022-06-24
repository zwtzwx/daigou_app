// 这里是通过配置文件
// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String getBaseApi() {
    return dotenv.env['API_URL'] ?? "https://dev-api.haiouoms.com/api/client/";
  }

  static String getUUID() {
    return dotenv.env['UUID'] ?? "4b8ab68b-7cf7-4e3b-9c00-cbd4dbf96f27";
  }

  static String getImageApi() {
    return dotenv.env['IMAGE_URL'] ?? "https://dev-api.haiouoms.com";
  }
}
