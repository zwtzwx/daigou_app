/*
  代理信息
 */
import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/agent_commission_record_model.dart';
import 'package:huanting_shop/models/agent_data_count_model.dart';
import 'package:huanting_shop/models/agent_model.dart';
import 'package:huanting_shop/models/bank_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/models/withdrawal_item_model.dart';
import 'package:huanting_shop/models/withdrawal_model.dart';
import 'package:huanting_shop/services/base_service.dart';
import 'package:flutter/foundation.dart';

class AgentService {
  // 代理信息
  static const String agentProfileApi = 'agent/info';

  // 代理信息统计数据
  static const String agentSubCountApi = 'agent/my-sub-count';

  // 可以提现的订单的列表
  static const String availableWithDrawApi = 'commission/normal-list';

  // 已提现订单列表
  static const String withdrawedApi = 'commission/withdraw-normal-list';

  // 成交记录列表
  static const String commissionListApi = 'commission';

  // 提现订单详情
  static const String withdrawDetailApi = 'balance/apply-commission-detail/:id';

  // 佣金报表列表
  static const String allWithDrawApi = 'balance/apply-commission-list';

  // 提现接口
  static const String agentCommissionWithdrawApi =
      'balance/apply-commission-withdraw';

  // 申请成为代理
  static const String applyAgentApi = 'agent/apply';

  // 推广好友
  static const String agentSubApi = 'agent/my-sub';

  // 银行名称列表
  static const String bankListApi = 'bank';

  // 绑定提现信息
  static const String agentBindApi = 'agent/bind';

  static const String agentCommissionInfoApi = 'agent/commission-info';

  /*
    得到统计信息
   */
  static Future<AgentDataCountModel?> getDataCount() async {
    AgentDataCountModel? result;

    await BeeRequest.instance
        .get(agentSubCountApi, queryParameters: null)
        .then((response) =>
            {result = AgentDataCountModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});

    return result;
  }

  /*
    得到代理信息
    基础信息, 包括二维码，基础信息，银行卡
   */
  static Future<AgentModel?> getProfile() async {
    AgentModel? result;

    await BeeRequest.instance.get(agentProfileApi).then((response) {
      if (kDebugMode) {
        print(response);
      }
      result = AgentModel.fromJson(response.data["agent"]);
    });
    return result;
  }

  /*
    申请提现
   */
  static Future<Map> applyWithDraw(Map params) async {
    Map result = {'ok': false, 'msg': ''};

    await BeeRequest.instance
        .post(agentCommissionWithdrawApi, data: params)
        .then((response) => {
              result = {
                'ok': response.ok,
                'msg': response.msg ?? response.error!.message
              }
            })
        .onError((error, stackTrace) => {});

    return result;
  }

  /*
    可以提现的订单的列表
   */
  static Future<Map> getAvailableWithDrawList(
      [Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<WithdrawalModel> dataList = <WithdrawalModel>[];

    await BeeRequest.instance
        .get(availableWithDrawApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(WithdrawalModel.fromJson(item));
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
    已提现订单列表
   */
  static Future<Map> getWithdrawedList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<WithdrawalModel> dataList = <WithdrawalModel>[];

    await BeeRequest.instance
        .get(withdrawedApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(WithdrawalModel.fromJson(item));
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
    提现订单详情
   */
  static Future<WithdrawalItemModel?> getWithdrawDetail(int id) async {
    WithdrawalItemModel? result;
    await BeeRequest.instance
        .get(withdrawDetailApi.replaceAll(':id', id.toString()))
        .then((res) => result = WithdrawalItemModel.fromJson(res.data));
    return result;
  }

  /*
    获取佣金报表列表
    包括提现中
   */
  static Future<Map> getCheckoutWithDrawList(
      [Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<WithdrawalItemModel> dataList = <WithdrawalItemModel>[];

    await BeeRequest.instance
        .get(allWithDrawApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(WithdrawalItemModel.fromJson(item));
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
    成交记录
   */
  static Future<Map> getCommissionList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<AgentCommissionRecordModel> dataList = <AgentCommissionRecordModel>[];

    await BeeRequest.instance
        .get(commissionListApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(AgentCommissionRecordModel.fromJson(item));
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
    申请成为代理
   */
  static Future<Map> applyAgent([Map<String, dynamic>? params]) async {
    Map result = {"ok": false, "msg": ''};
    await BeeRequest.instance
        .post(applyAgentApi, data: params)
        .then((response) => {
              result = {
                "ok": response.ok,
                "msg": response.msg ?? response.error?.message ?? '',
              }
            })
        .onError((error, stackTrace) => {});

    return result;
  }

  /* 
    推广好友
   */
  static Future<Map> getSubList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<UserModel> dataList = [];
    await BeeRequest.instance
        .get(agentSubApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(UserModel.fromJson(item));
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
    银行列表
   */
  static Future<Map> getBankList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<BankModel> dataList = <BankModel>[];

    await BeeRequest.instance
        .get(bankListApi, queryParameters: params)
        .then((response) {
      response.data?.forEach((item) {
        dataList.add(BankModel.fromJson(item));
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
    绑定提现信息
  */
  static Future<void> agentBind(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await BeeRequest.instance.put(agentBindApi, data: params).then((response) {
      if (response.ok) {
        onSuccess(response.msg);
      } else {
        onFail(response.error!.message);
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }

  // 已提现金额
  static Future<Map?> getAgentCommissionInfo() async {
    Map? res;
    await BeeRequest.instance
        .get(
      agentCommissionInfoApi,
    )
        .then((response) {
      if (response.ok) {
        res = response.data;
      }
    });
    return res;
  }
}
