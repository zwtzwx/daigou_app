/*
  提现模型
 */

import 'package:shop_app_client/models/user_model.dart';

class WithdrawalModel {
  late int id;
  late String agentId;
  late String orderNumber;
  late int orderAmount;
  late int proportion;
  late int commissionAmount;
  late String createdAt;
  late String createdDay;
  late String updatedAt;
  late int companyId;
  late int settled;
  late int withdrawId;
  UserModel? customer;
  late Map<String, dynamic> order;
  bool select = false;

  WithdrawalModel(
      {required this.id,
      required this.agentId,
      required this.orderNumber,
      required this.orderAmount,
      required this.proportion,
      required this.commissionAmount,
      required this.createdAt,
      required this.createdDay,
      required this.updatedAt,
      required this.companyId,
      required this.settled,
      required this.withdrawId,
      required this.customer,
      required this.order,
      this.select = false});

  WithdrawalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    orderNumber = json['order_number'];
    orderAmount = json['order_amount'];
    proportion = json['proportion'];
    commissionAmount = json['commission_amount'];
    createdAt = json['created_at'];
    createdDay = json['created_day'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    settled = json['settled'];
    withdrawId = json['withdraw_id'];
    customer = (json['customer'] != null
        ? UserModel.fromJson(json['customer'])
        : null)!;
    order = json['order'];
    select = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['agent_id'] = agentId;
    data['order_number'] = orderNumber;
    data['order_amount'] = orderAmount;
    data['proportion'] = proportion;
    data['commission_amount'] = commissionAmount;
    data['created_at'] = createdAt;
    data['created_day'] = createdDay;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['settled'] = settled;
    data['withdraw_id'] = withdrawId;
    data['customer'] = customer!.toJson();
    data['order'] = order;
    return data;
  }
}
