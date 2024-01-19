/*
  物流
 */

import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/tracking_model.dart';

class TrackingService {
  // 列表
  static const String listApi = 'tracking/query';

  // 获列表
  static Future<List<TrackingModel>> getList(
      [Map<String, dynamic>? params]) async {
    List<TrackingModel> result = [];
    await BeeRequest.instance
        .get(listApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        result.add(TrackingModel.fromJson(item));
      });
    });
    return result;
  }
}
