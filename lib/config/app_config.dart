// 这里是通过配置文件
// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrls {
  static String getBaseApi() {
    return dotenv.env['API_URL'] ?? "";
  }

  static String getUUID() {
    return dotenv.env['UUID'] ?? "";
  }

  static String getImageApi() {
    return dotenv.env['IMAGE_URL'] ?? "";
  }
}
