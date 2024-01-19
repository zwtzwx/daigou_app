// ignore_for_file: constant_identifier_names

import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/localization_model.dart';

class LocalizationService {
  // 列表
  static const String LISTAPI = 'localization';

  // 获列表
  static Future<LocalizationModel?> getInfo(
      [Map<String, dynamic>? params]) async {
    LocalizationModel? result;
    await BeeRequest.instance
        .get(LISTAPI, queryParameters: params)
        .then(
            (response) => {result = LocalizationModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});
    return result;
  }
}
