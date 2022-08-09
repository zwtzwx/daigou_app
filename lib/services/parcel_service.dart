// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';

import 'base_service.dart';

class ParcelService {
  // 批量提交包裹接口
  static const String _BATCHAPI = 'package/batch';
  // 动态获取包裹的增值服务
  static const String _VALUEADDEDSERVICE_API = 'package-opservice';
  // 异常件
  static const String noOwnerListApi = 'packages/no-owner';
  // 信息不全的包裹数
  static const String notConfirmedApi = 'package/not-confirmed-count';
  // 认领异常件
  static const String noOwnerOneApi = 'packages/claim/:id';
  //同步信息包裹列表
  static const String syncListApi = 'packages/syncs';
  // 包裹列表
  static const String parcelListApi = 'package';
  // 包裹详细
  static const String parcelOneApi = 'package/:id';

  // 新增预报
  static Future store(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient()
        .post(_BATCHAPI, data: params)
        .then((response) => {
              if (response.ok)
                {onSuccess(response)}
              else
                {onFail(response.msg!)}
            })
        .onError((error, stackTrace) {
      onFail(error.toString());
      return {};
    });
  }

  /*
    修改预报
   */
  static Future<bool> update(int id, Map<String, dynamic> params) async {
    bool result = false;

    await HttpClient()
        .put(parcelOneApi.replaceAll(':id', id.toString()), data: params)
        .then((response) => {result = (response.ok)});

    return result;
  }

  // 获取包裹增值服务
  static Future<List<ValueAddedServiceModel>> getValueAddedServiceList(
      [Map<String, dynamic>? params]) async {
    List<ValueAddedServiceModel> result =
        List<ValueAddedServiceModel>.empty(growable: true);
    await HttpClient()
        .get(_VALUEADDEDSERVICE_API, queryParameters: params)
        .then((response) => {
              response.data?.forEach((good) {
                result.add(ValueAddedServiceModel.fromJson(good));
              })
            });
    return result;
  }

  /*
    异常件认领列表
    无主件
   */
  static Future<Map> getOnOwnerList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<ParcelModel> dataList = <ParcelModel>[];

    //为啥API是POST
    await HttpClient()
        .post(noOwnerListApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(ParcelModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });

    return result;
  }

  /*
    同步信息包裹列表
    主要用于认领中
   */
  static Future<List<ParcelModel>> getSyncsList() async {
    List<ParcelModel> result = List<ParcelModel>.empty(growable: true);
    await HttpClient()
        .get(syncListApi, queryParameters: null)
        .then((response) => {
              response.data?.forEach((good) {
                result.add(ParcelModel.fromSimpleJson(good));
              })
            });
    return result;
  }

  /*
    认领异常件
   */
  static Future<Map> setNoOwnerToMe(int id, ParcelModel parcel) async {
    Map result = {'ok': false, 'msg': ''};
    await HttpClient().put(noOwnerOneApi.replaceAll(':id', id.toString()),
        queryParameters: {
          "express_num": parcel.expressNum,
          "sync_id": parcel.id
        }).then((response) => {
          result = {
            'ok': response.ok,
            'msg': response.msg ?? response.error?.message,
          }
        });

    return result;
  }

  // 获取包裹列表
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = params?['page'] ?? 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<ParcelModel> dataList = <ParcelModel>[];

    await HttpClient()
        .get(parcelListApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(ParcelModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }

  /*
    删除包裹
   */
  static Future<bool> delete(int id) async {
    bool result = false;
    await HttpClient()
        .delete(parcelOneApi.replaceAll(':id', id.toString()))
        .then((response) => {result = response.ok});

    return result;
  }

  // 更新包裹数据
  static Future<ParcelModel?> getDetail(int id) async {
    ParcelModel? result;
    await HttpClient()
        .get(parcelOneApi.replaceAll(':id', id.toString()))
        .then((response) {
      if (response.ok) {
        result = ParcelModel.fromJson(response.data);
      }
    }).onError((error, stackTrace) => null);
    return result;
  }

  /*
    信息不全的包裹数
   */
  static Future<int> getNotConfirmedParcelCount() async {
    int count = 0;
    await HttpClient().get(notConfirmedApi).then((res) {
      if (res.ok) {
        count = res.data['count'];
      }
    });
    return count;
  }
}
