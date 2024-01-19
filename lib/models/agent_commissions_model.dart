/*
  代理佣金
 */
import 'package:huanting_shop/models/order_model.dart';
import 'package:huanting_shop/models/user_model.dart';

class AgentCommissionsModel {
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
  late String deletedAt;
  late UserModel customer;
  late OrderModel order;

  AgentCommissionsModel(
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
      required this.deletedAt,
      required this.customer,
      required this.order});

  AgentCommissionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'] ?? '';
    orderNumber = json['order_number'];
    orderAmount = json['order_amount'] ?? 0;
    proportion = json['proportion'] ?? 0;
    commissionAmount = json['commission_amount'];
    createdAt = json['created_at'];
    createdDay = json['created_day'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    settled = json['settled'];
    withdrawId = json['withdraw_id'];
    deletedAt = json['deleted_at'] ?? '';
    customer = (json['customer'] != null
        ? UserModel.fromJson(json['customer'])
        : null)!;
    order =
        (json['order'] != null ? OrderModel.fromJson(json['order']) : null)!;
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
    data['deleted_at'] = deletedAt;
    data['customer'] = customer.toJson();
    data['order'] = order.toJson();
    return data;
  }
}
