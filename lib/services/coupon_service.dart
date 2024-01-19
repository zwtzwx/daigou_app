/*
  优惠券服务
 */

import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/user_coupon_model.dart';

class CouponService {
  // 积分列表integral
  static const String dataListApi = 'coupon';

  /*
    获取优惠券列表
   */
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": [], 'total': 1, 'pageIndex': page};
    List<UserCouponModel> dataList = <UserCouponModel>[];

    await BeeRequest.instance
        .get(dataListApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(UserCouponModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }
}
