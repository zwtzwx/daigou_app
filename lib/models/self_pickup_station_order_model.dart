/*
  自提点订单
 */
class SelfPickupStationOrderModel {
  late int id;
  late int status;
  late int orderId;

  SelfPickupStationOrderModel(
      {required this.id, required this.status, required this.orderId});

  SelfPickupStationOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['order_id'] = orderId;
    return data;
  }
}
