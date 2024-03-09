import 'package:shop_app_client/common/http_client.dart';
import 'package:shop_app_client/models/coordinate_model.dart';
import 'package:shop_app_client/models/group_model.dart';
import 'package:shop_app_client/models/group_order_model.dart';
import 'package:shop_app_client/models/group_preview_order_model.dart';
import 'package:shop_app_client/models/parcel_model.dart';

class GroupService {
  // 公开拼团列表
  static const String publicListApi = 'group-buying';
  // 我的拼团
  static const String myListApi = 'my-group-buying';
  // 拼团设置
  static const String userConfigApi = 'group-buying/user-config';
  // 拼团规则
  static const String groupProtocolApi = 'group-buying/contents';
  // 发起拼团
  static const String groupBuyApi = 'group-buying';
  // 拼团详情
  static const String groupBuyDetailApi = 'group-buying/:id';
  // 加入拼团
  static const String groupJoinApi = 'group-buying/:id/join';
  // 退出拼团
  static const String groupExistApi = 'group-buying/:id/exit';
  // 添加包裹
  static const String groupAddParcelApi = 'group-buying/:id/add-packages';
  // 拼团仓
  static const String groupAddedApi = 'group-buying/package-added';
  // 拼团仓详情
  static const String groupAddedDetailApi = 'group-buying/:id/packages';
  // 拼团包裹退回原仓库
  static const String groupParcelReturnApi = 'group-buying/:id/remove-packages';
  // 参团详情
  static const String groupMemberDetailApi = 'group-buying/:id/details';
  // 预览拼团订单
  static const String groupOrderPreviewApi = 'group-buying/:id/order-preview';
  // 提交拼团订单
  static const String createdGroupOrderApi = 'group-buying/:id/order-create';
  // 取消拼团
  static const String groupCancelApi = 'group-buying/:id/dismiss';
  // 结束拼团
  static const String groupEndApi = 'group-buying/:id/end';
  // 我的团单列表
  static const String groupOrderListApi = 'group-buying/orders';
  // 团单详情
  static const String groupOrderDetailApi = 'group-buying/orders/:id';
  // 延长拼团天数
  static const String groupDayDelayApi = 'group-buying/:id/prolong';
  // 修改团长有话说
  static const String groupRemarkApi = 'group-buying/:id/remark';
  // 逆地址解析
  static const String locationGeocodeApi = 'google/geocode';
  // 地址解析
  static const String addressGeocodeApi = 'google/geocode-address';
  // 路线规划
  static const String coordinateDirectionApi = 'google/directions';

  // 公共拼团列表
  static Future<Map> getPublicGroups(Map<String, dynamic> params) async {
    var page = params['page'];
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    await ApiConfig.instance
        .get(publicListApi, queryParameters: params)
        .then((res) {
      List<GroupModel> list = [];
      res.data.forEach((item) {
        list.add(GroupModel.fromJson(item));
      });
      result = {
        "dataList": list,
        'total': res.meta?['last_page'],
        'pageIndex': res.meta?['current_page'],
      };
    });
    return result;
  }

  // 我的拼团列表
  static Future<Map> getMyGroups(Map<String, dynamic> params) async {
    var page = params['page'];
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    await ApiConfig.instance
        .get(myListApi, queryParameters: params)
        .then((res) {
      List<GroupModel> list = [];
      res.data.forEach((item) {
        list.add(GroupModel.fromJson(item));
      });
      result = {
        "dataList": list,
        'total': res.meta?['last_page'],
        'pageIndex': res.meta?['current_page'],
      };
    });
    return result;
  }

  // 是否可设为公开拼团
  static Future<bool> getPublicGroupConfig() async {
    bool result = false;
    await ApiConfig.instance.get(userConfigApi).then((res) {
      if (res.ok) {
        result = res.data['create_public_group'];
      }
    });
    return result;
  }

  // 拼团规则
  static Future<List<Map>> getGroupProtocol() async {
    List<Map> result = [];
    await ApiConfig.instance.get(groupProtocolApi).then((res) {
      if (res.ok) {
        res.data.forEach((e) {
          result.add(e);
        });
      }
    });
    return result;
  }

  // 发起拼团
  static Future<Map> onGroupStart(Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance.post(groupBuyApi, data: params).then((res) {
      result = {
        'ok': res.ok,
        'msg': res.msg ?? res.error?.message ?? '',
      };
    });
    return result;
  }

  // 拼团详情
  static Future<GroupModel?> getGroupDetail(int id) async {
    GroupModel? result;
    await ApiConfig.instance
        .get(groupBuyDetailApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        result = GroupModel.fromJson(res.data);
      }
    });
    return result;
  }

  // 加入拼团
  static Future<Map> onGroupJoin(int id) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(groupJoinApi.replaceAll(':id', id.toString()))
        .then((res) =>
            result = {'ok': res.ok, 'msg': res.msg ?? res.error?.message});
    return result;
  }

  // 退出拼团
  static Future<Map> onGroupExist(int id) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(groupExistApi.replaceAll(':id', id.toString()))
        .then((res) =>
            result = {'ok': res.ok, 'msg': res.msg ?? res.error?.message});
    return result;
  }

  // 拼团添加包裹
  static Future<Map> onGroupAddParcel(
      int id, Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(
          groupAddParcelApi.replaceAll(':id', id.toString()),
          data: params,
        )
        .then((res) =>
            result = {'ok': res.ok, 'msg': res.msg ?? res.error?.message});
    return result;
  }

  // 拼团仓
  static Future<Map> getGroupAddedParcels(
      [Map<String, dynamic>? params]) async {
    Map result = {"dataList": null, 'total': 1, 'pageIndex': 1};
    await ApiConfig.instance
        .get(groupAddedApi, queryParameters: params)
        .then((res) {
      List<GroupModel> list = [];
      res.data.forEach((item) {
        list.add(GroupModel.fromJson(item));
      });
      result['dataList'] = list;
    });
    return result;
  }

  // 拼团仓详情
  static Future<Map> getGroupAddedParcelsDetail(int id) async {
    Map result = {"dataList": null, 'total': 1, 'pageIndex': 1};
    await ApiConfig.instance
        .get(groupAddedDetailApi.replaceAll(':id', id.toString()))
        .then((res) {
      List<ParcelModel> list = [];
      res.data.forEach((item) {
        list.add(ParcelModel.fromJson(item));
      });
      result['dataList'] = list;
    });
    return result;
  }

  // 拼团退回包裹
  static Future<Map> onGroupParcelReturn(
      int id, Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(
          groupParcelReturnApi.replaceAll(':id', id.toString()),
          data: params,
        )
        .then((res) =>
            result = {'ok': res.ok, 'msg': res.msg ?? res.error?.message});
    return result;
  }

  // 参团详情
  static Future<GroupModel?> getGroupMemberDetail(int id) async {
    GroupModel? result;
    await ApiConfig.instance
        .get(groupMemberDetailApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        result = GroupModel.fromJson(res.data);
      }
    });
    return result;
  }

  // 预览拼团订单
  static Future<GroupPreviewOrderModel?> onGroupOrderPreview(int id) async {
    GroupPreviewOrderModel? result;
    await ApiConfig.instance
        .get(groupOrderPreviewApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        result = GroupPreviewOrderModel.fromJson(res.data);
      }
    });
    return result;
  }

  // 提交订单
  static Future<Map> onCreatedOrder(int id, Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(
      createdGroupOrderApi.replaceAll(':id', id.toString()),
      data: params,
    )
        .then((res) {
      result = {
        'ok': res.ok,
        'msg': res.msg ?? res.error?.message,
      };
    });
    return result;
  }

  // 取消拼团
  static Future<Map> onCancelGroup(int id) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(groupCancelApi.replaceAll(':id', id.toString()))
        .then((res) {
      result = {
        'ok': res.ok,
        'msg': res.msg ?? res.error?.message,
      };
    });
    return result;
  }

  // 结束拼团
  static Future<Map> onEndGroup(int id) async {
    Map result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(groupEndApi.replaceAll(':id', id.toString()))
        .then((res) {
      result = {
        'ok': res.ok,
        'msg': res.msg ?? res.error?.message,
      };
    });
    return result;
  }

  // 我的团单
  static Future<Map> getGroupOrders(Map<String, dynamic> params) async {
    var page = params['page'];
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    await ApiConfig.instance
        .get(
      groupOrderListApi,
      queryParameters: params,
    )
        .then((res) {
      if (res.ok) {
        List<GroupOrderModel> list = [];
        res.data.forEach((item) {
          list.add(GroupOrderModel.fromJson(item));
        });
        result = {
          "dataList": list,
          'total': res.meta?['last_page'],
          'pageIndex': res.meta?['current_page'],
        };
      }
    });
    return result;
  }

  // 团单详情
  static Future<GroupOrderModel?> getGroupOrderDetail(int id) async {
    GroupOrderModel? result;
    await ApiConfig.instance
        .get(groupOrderDetailApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        result = GroupOrderModel.fromJson(res.data);
      }
    });
    return result;
  }

  // google 逆地址解析
  static Future<String?> onLocationGeocode(Map<String, dynamic> params) async {
    String? result;
    await ApiConfig.instance
        .get(
      locationGeocodeApi,
      queryParameters: params,
    )
        .then((res) {
      if (res.ok) {
        result = res.data;
      }
    });
    return result;
  }

  // google 地址解析
  static Future<CoordinateModel?> onAddressGeocode(
      Map<String, dynamic> params) async {
    CoordinateModel? result;
    await ApiConfig.instance
        .get(
      addressGeocodeApi,
      queryParameters: params,
    )
        .then((res) {
      if (res.ok && res.data is Map) {
        var location = res.data['location'];
        result = CoordinateModel(
            latitude: location['lat'], longitude: location['lng']);
      }
    });
    return result;
  }

  // google 路线规划
  // static Future<Set<Polyline>> onAddressDirection(
  //     Map<String, dynamic> params) async {
  //   Set<Polyline> list = {};
  //   await ApiConfig.instance
  //       .get(
  //     coordinateDirectionApi,
  //     queryParameters: params,
  //   )
  //       .then((res) {
  //     if (res.ok && res.data['status'] == 'OK') {
  //       var steps = res.data['routes'][0]['legs'][0]['steps'];
  //       steps.forEach((item) {
  //         list.add(
  //           Polyline(
  //             polylineId: PolylineId(item['polyline']['points']),
  //             points: [
  //               LatLng(item['start_location']['lat'],
  //                   item['start_location']['lng']),
  //               LatLng(
  //                   item['end_location']['lat'], item['end_location']['lng']),
  //             ],
  //             width: 2,
  //             color: ColorConfig.primary,
  //           ),
  //         );
  //       });
  //     }
  //   });
  //   return list;
  // }

  // 延长拼团
  static Future<Map<String, dynamic>> onDayDelay(
      int id, Map<String, dynamic> params) async {
    Map<String, dynamic> result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(
          groupDayDelayApi.replaceAll(':id', id.toString()),
          data: params,
        )
        .then(
          (res) => result = {
            'ok': res.ok,
            'msg': res.msg ?? res.error?.message,
          },
        );
    return result;
  }

  // 修改团长有话说
  static Future<Map<String, dynamic>> onGroupRemarkChange(
      int id, Map<String, dynamic> params) async {
    Map<String, dynamic> result = {'ok': false, 'msg': ''};
    await ApiConfig.instance
        .put(
          groupRemarkApi.replaceAll(':id', id.toString()),
          data: params,
        )
        .then(
          (res) => result = {
            'ok': res.ok,
            'msg': res.msg ?? res.error?.message,
          },
        );
    return result;
  }
}
