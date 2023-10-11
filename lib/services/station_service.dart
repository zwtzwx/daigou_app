import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';

/*
  自提点
*/
class StationService {
  static String listApi = 'self-pickup-stations';

  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = params?['page'] ?? 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    await BeeRequest.instance
        .get(
      listApi,
      queryParameters: params,
    )
        .then((response) {
      List<SelfPickupStationModel> dataList = [];
      response.data.forEach(
          (item) => dataList.add(SelfPickupStationModel.fromJson(item)));
      result = {
        "dataList": dataList,
        "total": response.meta!['last_page'],
        "pageIndex": response.meta!['current_page'],
      };
    });
    return result;
  }
}
