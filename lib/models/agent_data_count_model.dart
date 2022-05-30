/*
  代理数据统计
 */
class AgentDataCountModel {
  late int all;
  late int hasOrder;
  late int orderCount;
  late String withdrableAmount;
  late String withdrawedAmount;

  AgentDataCountModel(
      {required this.all,
      required this.hasOrder,
      required this.orderCount,
      required this.withdrableAmount,
      required this.withdrawedAmount});

  AgentDataCountModel.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    hasOrder = json['has_order'];
    orderCount = json['order_count'];
    withdrableAmount = json['withdrable_amount'].toString();
    withdrawedAmount = json['withdrawed_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    data['has_order'] = hasOrder;
    data['order_count'] = orderCount;
    data['withdrable_amount'] = withdrableAmount;
    data['withdrawed_amount'] = withdrawedAmount;
    return data;
  }
}
