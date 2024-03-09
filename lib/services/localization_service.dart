// ignore_for_file: constant_identifier_names

import 'package:shop_app_client/common/http_client.dart';
import 'package:shop_app_client/models/localization_model.dart';

class LocalizationService {
  // 列表
  static const String LISTAPI = 'localization';

  // 获列表
  static Future<LocalizationModel?> getInfo(
      [Map<String, dynamic>? params]) async {
    LocalizationModel? result;
    await ApiConfig.instance
        .get(LISTAPI, queryParameters: params)
        .then(
            (response) => {result = LocalizationModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});
    return result;
  }
}
