/*
  优惠券服务
 */

import 'package:shop_app_client/common/http_client.dart';
import 'package:shop_app_client/models/user_coupon_model.dart';
import 'package:shop_app_client/services/base_service.dart';

class CouponService {
  // 积分列表integral
  static const String dataListApi = 'coupon';
  // 兑换
  static const String exchangeApi = 'coupon-redemption';


  /*
    获取优惠券列表
   */
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": [], 'total': 1, 'pageIndex': page};
    List<UserCouponModel> dataList = <UserCouponModel>[];

    await ApiConfig.instance
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

/*
  兑换优惠券
 */
  static Future<bool> exchangeCoupon(Map<String, dynamic> params,OnSuccess onSuccess, OnFail onFail) async {
    bool result = false;

    await ApiConfig.instance
        .put(exchangeApi, data: params)
        .then((response) {
      result = response.ok;
      if(response.ok){
        onSuccess(response.msg);
      }else {
        onFail(response.error!.message);
      }
    });

    return result;
  }
}
