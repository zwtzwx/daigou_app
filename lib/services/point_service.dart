/*
  积分服务
 */
import 'package:shop_app_client/common/http_client.dart';
import 'package:shop_app_client/models/user_point_item_model.dart';
import 'package:shop_app_client/models/user_point_model.dart';
import 'package:shop_app_client/models/user_vip_rule_model.dart';

class PointService {
  // 积分列表integral
  static const String dataListApi = 'user-member/point-record/index';

  // 个人积分详情
  static const String summaryApi = 'user-member/member-show';

  // 积分规则
  static const String ruleApi = 'user-member/rule-status';

  // 成长值列表
  static const String growthValueListApi =
      'user-member/growth-value-record/index';

  /*
    获取积分概览
   */
  static Future<UserPointModel?> getSummary(
      [Map<String, dynamic>? params]) async {
    UserPointModel? result;

    await ApiConfig.instance
        .get(summaryApi, queryParameters: params)
        .then((response) => {result = UserPointModel.fromJson(response.data)});

    return result;
  }

  /*
    获取积分列表
   */
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<UserPointItemModel> dataList = [];
    await ApiConfig.instance
        .get(dataListApi, queryParameters: params)
        .then((response) {
      response.data?.forEach((item) {
        dataList.add(UserPointItemModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.meta?['last_page'],
        'pageIndex': response.meta?['current_page']
      };
    });

    return result;
  }

  /*
    获取成长值列表
   */
  static Future<Map> getGrowthValueList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<UserPointItemModel> dataList = [];

    await ApiConfig.instance
        .get(growthValueListApi, queryParameters: params)
        .then((response) {
      response.data?.forEach((item) {
        dataList.add(UserPointItemModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.meta?['last_page'],
        'pageIndex': response.meta?['current_page']
      };
    });

    return result;
  }

  /*
    获取积分规则
  */
  static Future<UserVipRuleModel?> getPointRule() async {
    UserVipRuleModel? result;
    await ApiConfig.instance
        .get(ruleApi)
        .then((res) => result = UserVipRuleModel.fromJson(res.data));
    return result;
  }
}
