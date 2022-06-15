/*
  余额类的服务
  余额列表，充值之类
 */
import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/bank_model.dart';
import 'package:jiyun_app_client/models/default_amount_model.dart';
import 'package:jiyun_app_client/models/order_transaction_model.dart';
import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/models/user_recharge_model.dart';
import 'package:jiyun_app_client/services/base_service.dart';

class BalanceService {
  // 订单支付方式列表
  static const String payTypeApi = 'order/pay-method';
  // 余额充值微信支付
  static const String balancePayByWechatApi = 'balance/wechat-recharge';
  // 充值档次
  static const String defaultAmountApi = 'order/default-amount';
  // 交易列表
  static const String transactionHistoryApi = 'transaction';
  // 充值列表
  static const String rechargeApi = 'balance/apply-recharge-list';

  // 会员充值转账支付
  static const String buyVipTransApi = 'user-member/tran-info';
  // 会员转账
  static const String rechargeTransApi = 'balance/tran-info';
  // 会员转账
  static const String orderTransApi = 'order/tran-info';
  // 余额支付订单
  static const String balancePayOrder = 'order/pay/balance';
  // 订单货到付款
  static const String onDeliveryPayOrder = 'order/pay-on-delivery';
  // 会员充值微信支付
  static const String buyVipWechatPayApi = 'user-member/pay/wechat';
  // 会员充值余额支付
  static const String buyVipBalanceApi = 'user-member/pay/balance';
  // 获取微信支付数据
  static const String orderPayWeChatApi = 'order/pay/:id';

  /*
    获取支付方式列表
   */
  static Future<List<PayTypeModel>> getPayTypeList(
      {noBalanceType = false, noDelivery = true}) async {
    List<PayTypeModel> result = <PayTypeModel>[];

    await HttpClient().get(payTypeApi, queryParameters: null).then((response) {
      Map list = response.data;

      List<dynamic> keyList = [];
      keyList.addAll(list.keys);

      for (var item in keyList) {
        if (list[item] == 1) {
          if (noBalanceType && item == "balance") continue;
          if (noDelivery && item == 'on_delivery') continue;
          PayTypeModel payModel = PayTypeModel.empty();
          payModel.name = item;
          payModel.enabled = 1;
          result.add(payModel);
        }
      }
      list['other'].forEach((v) {
        PayTypeModel payModel = PayTypeModel.fromJson(v);
        if (payModel.enabled == 1) {
          result.add(payModel);
        }
      });
    });
    return result;
  }

  /*
    获取充值档次
   */
  static Future<List<DefaultAmountModel>> getDefaultAmountList(
      {Map<String, dynamic>? params}) async {
    List<DefaultAmountModel> result = <DefaultAmountModel>[];

    await HttpClient()
        .get(defaultAmountApi, queryParameters: params)
        .then((response) {
      response.data.forEach((item) {
        result.add(DefaultAmountModel.fromJson(item));
      });
    });

    return result;
  }

  /*
    余额充值
    微信支付
  */
  static Future rechargePayByWeChat(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    return await HttpClient()
        .post(balancePayByWechatApi, data: params)
        .then((response) {
      if (response.ok) {
        onSuccess(response);
      } else {
        onFail(response.msg.toString());
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }

  /*
    交易列表
   */
  static Future<Map> getTransactionList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<OrderTransactionModel> dataList = <OrderTransactionModel>[];

    await HttpClient()
        .get(transactionHistoryApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(OrderTransactionModel.fromJson(item));
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
    充值记录列表
   */
  static Future<Map> getRechargeList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<UserRechargeModel> dataList = <UserRechargeModel>[];

    await HttpClient()
        .get(rechargeApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(UserRechargeModel.fromJson(item));
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
    买会员（转账支付）
   */
  static Future<Map> buyVipTransfer(Map params) async {
    Map result = {"ok": false, "msg": null};
    await HttpClient().post(buyVipTransApi, data: params).then((response) => {
          result = {
            "ok": response.ok,
            "msg": response.msg ?? response.error!.message,
          }
        });

    return result;
  }

  /*
    买会员（转账支付）
   */
  static Future<Map> buyVipBalance(Map params) async {
    Map result = {"ok": false, "msg": null};
    await HttpClient().post(buyVipBalanceApi, data: params).then((response) => {
          result = {
            "ok": response.ok,
            "msg": response.msg ?? response.error!.message,
          }
        });

    return result;
  }

  /*
    充值余额
   */
  static Future<Map> rechargeTransfer(Map params) async {
    Map result = {"ok": false, "msg": null};
    await HttpClient().post(rechargeTransApi, data: params).then((response) => {
          result = {
            "ok": response.ok,
            "msg": response.msg ?? response.error!.message,
          }
        });

    return result;
  }

  /*
    订单
   */
  static Future<Map> orderPayTransfer(Map params) async {
    Map result = {"ok": false, "msg": null};
    await HttpClient().post(orderTransApi, data: params).then((response) => {
          result = {
            "ok": response.ok,
            "msg": response.msg ?? response.error!.message,
          }
        });

    return result;
  }

  /*
    订单余额支付
   */
  static Future<Map> orderBalancePay(Map params) async {
    Map result = {'ok': false, 'msg': null};
    await HttpClient().post(balancePayOrder, data: params).then((response) => {
          result = {
            'ok': response.ok,
            'msg': response.msg ?? response.error!.message,
          }
        });

    return result;
  }

  /*
    订单微信支付
   */
  static Future orderWechatPay(int id, Map<String, dynamic> params,
      OnSuccess onSuccess, OnFail onFail) async {
    return await HttpClient()
        .post(orderPayWeChatApi.replaceAll(':id', id.toString()), data: params)
        .then((response) {
      if (response.ok) {
        onSuccess(response);
      } else {
        onFail(response.msg.toString());
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }

  /*
    订单货到付款
   */
  static Future<Map> orderOnDelivery(Map params) async {
    Map result = {'ok': false, 'msg': null};
    await HttpClient()
        .post(onDeliveryPayOrder, data: params)
        .then((response) => {
              result = {
                'ok': response.ok,
                'msg': response.msg ?? response.error!.message,
              }
            });

    return result;
  }

  /*
    会员充值微信支付
   */
  static Future buyVipWechatPay(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    return await HttpClient()
        .post(buyVipWechatPayApi, data: params)
        .then((response) {
      if (response.ok) {
        onSuccess(response);
      } else {
        onFail(response.msg.toString());
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }
}
