// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/localization_model.dart';

class LocalizationService {
  // 列表
  static const String LISTAPI = 'localization';

  // 获列表
  static Future<LocalizationModel?> getInfo(
      [Map<String, dynamic>? params]) async {
    LocalizationModel? result;
    await HttpClient().get(LISTAPI, queryParameters: params).then(
        (response) => {result = LocalizationModel.fromJson(response.data)});
    return result;
  }
}
