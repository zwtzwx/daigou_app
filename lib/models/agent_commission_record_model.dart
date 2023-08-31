/*
  成交记录
 */
import 'package:jiyun_app_client/models/agent_commissions_model.dart';

class AgentCommissionRecordModel {
  late num commissionAmount;
  late num orderAmount;
  late String createdAt;
  late List<AgentCommissionsModel> data;
  bool isOpen = false;
  int? id;

  AgentCommissionRecordModel({
    required this.commissionAmount,
    required this.orderAmount,
    required this.createdAt,
    required this.data,
  });

  AgentCommissionRecordModel.fromJson(Map<String, dynamic> json) {
    commissionAmount = json['commission_amount'];
    orderAmount = json['order_amount'];
    createdAt = json['created_at'];
    if (json['data'] != null) {
      List<AgentCommissionsModel> list = [];
      for (var item in json['data']) {
        list.add(AgentCommissionsModel.fromJson(item));
      }
      data = list;
    }
  }
}
