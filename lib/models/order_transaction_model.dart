/*
  交易流水
 */
import 'package:jiyun_app_client/models/order_model.dart';

class OrderTransactionModel {
  late int id;
  late int userId;
  late int type;
  late int amount;
  String? orderSn;
  late String wechatSn;
  late String createdAt;
  late String updatedAt;
  late int companyId;
  late String serialNo;
  late int mod4pay;
  late String outSerialNo;
  late String currency;
  late String rate;
  late String transCurrency;
  late String transRate;
  bool? showTrans;
  String? currencySymbol;
  late String payName;
  int? isUsePoint;
  num? pointAmount;
  OrderModel? order;

  OrderTransactionModel(
      {required this.id,
      required this.userId,
      required this.type,
      required this.amount,
      this.orderSn,
      required this.wechatSn,
      required this.createdAt,
      required this.updatedAt,
      required this.companyId,
      required this.serialNo,
      required this.mod4pay,
      required this.outSerialNo,
      required this.currency,
      required this.rate,
      required this.transCurrency,
      required this.transRate,
      // required this.showTrans,
      // required this.currencySymbol,
      required this.payName,
      required this.order});

  OrderTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    type = json['type'];
    amount = json['amount'] ?? 0;
    orderSn = json['order_sn'];
    wechatSn = json['wechat_sn'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    companyId = json['company_id'] ?? 0;
    serialNo = json['serial_no'];
    mod4pay = json['mod4pay'] ?? 0;
    outSerialNo = json['out_serial_no'] ?? '';
    currency = json['currency'] ?? '';
    rate = json['rate'] ?? '';
    transCurrency = json['trans_currency'] ?? '';
    transRate = json['trans_rate'] ?? '';
    isUsePoint = json['is_use_point'];
    pointAmount = json['point_amount'];
    showTrans = json['show_trans'];
    currencySymbol = json['currency_symbol'];
    payName = json['pay_name'];
    order = json['order'] != null ? OrderModel.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['amount'] = amount;
    data['order_sn'] = orderSn;
    data['wechat_sn'] = wechatSn;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['serial_no'] = serialNo;
    data['mod4pay'] = mod4pay;
    data['out_serial_no'] = outSerialNo;
    data['currency'] = currency;
    data['rate'] = rate;
    data['trans_currency'] = transCurrency;
    data['trans_rate'] = transRate;
    data['show_trans'] = showTrans;
    data['currency_symbol'] = currencySymbol;
    data['pay_name'] = payName;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}
