import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';

class AddressService {
  // 列表
  static const String listApi = 'address';
  //单个地址
  static const String addressOneApi = 'address/:id/';

  // 地址列表
  static Future<List<ReceiverAddressModel>> getReceiverList(
      [Map<String, dynamic>? params]) async {
    List<ReceiverAddressModel> dataList =
        List<ReceiverAddressModel>.empty(growable: true);
    await HttpClient().get(listApi, queryParameters: params).then((response) {
      var list = response.data;
      list.forEach((item) {
        dataList.add(ReceiverAddressModel.fromJson(item));
      });
    });

    return dataList;
  }

  /*
    删除地址
   */
  static Future<bool> deleteReciever(int id) async {
    bool result = false;
    await HttpClient()
        .delete(addressOneApi.replaceAll(':id', id.toString()),
            queryParameters: null)
        .then((response) {
      result = response.ok;
    });

    return result;
  }

  /*
    修改地址
   */
  static Future<Map> updateReciever(int id, Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': null};
    await HttpClient()
        .put(addressOneApi.replaceAll(':id', id.toString()),
            queryParameters: params)
        .then((response) {
      result = {
        'ok': response.ok,
        'msg': response.msg ?? response.error!.message
      };
    });

    return result;
  }

  /*
    新增地址
   */
  static Future<Map> addReciever(Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': null};
    await HttpClient().post(listApi, data: params).then((response) {
      result = {
        'ok': response.ok,
        'msg': response.msg ?? response.error!.message
      };
    });

    return result;
  }
}
