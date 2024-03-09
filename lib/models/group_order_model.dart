import 'package:shop_app_client/models/order_model.dart';
import 'package:shop_app_client/models/receiver_address_model.dart';
import 'package:shop_app_client/models/self_pickup_station_model.dart';
import 'package:shop_app_client/models/self_pickup_station_order_model.dart';
import 'package:shop_app_client/models/warehouse_model.dart';

class GroupOrderModel {
  late int id;
  late String orderSn;
  int? status;
  int? mode;
  int? subOrdersCount;
  WareHouseModel? warehouse;
  ReceiverAddressModel? address;
  SelfPickupStationModel? station;
  int? finished;
  int? all;
  String? createdAt;
  SelfPickupStationOrderModel? stationOrder;

  List<OrderModel>? subOrders;
  int? packagesCount;
  num? packagesWeight;
  num? packagesVolumeWeight;
  num? paymentWeight;
  num? actualPaymentFee;

  GroupOrderModel({
    required this.id,
    required this.orderSn,
  });

  GroupOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderSn = json['order_sn'];
    status = json['status'];
    mode = json['mode'];
    subOrdersCount = json['sub_orders_count'];
    finished = json['finished'];
    all = json['all'];
    packagesCount = json['packages_count'];
    packagesVolumeWeight = json['packages_volume_weight'];
    packagesWeight = json['packages_weight'];
    paymentWeight = json['payment_weight'];
    actualPaymentFee = json['actual_payment_fee'];
    createdAt = json['created_at'];
    if (json['warehouse'] != null) {
      warehouse = WareHouseModel(
        id: json['warehouse']['id'],
        warehouseName: json['warehouse']['name'],
      );
    }
    if (json['address'] != null) {
      address = ReceiverAddressModel.fromJson(json['address']);
    }
    if (json['station'] != null) {
      station = SelfPickupStationModel.fromJson(json['station']);
    }
    if (json['station_order'] != null) {
      stationOrder =
          SelfPickupStationOrderModel.fromJson(json['station_order']);
    }
    if (json['sub_orders'] != null) {
      subOrders = List.empty(growable: true);
      json['sub_orders'].forEach((v) {
        subOrders!.add(OrderModel.fromJson(v));
      });
    }
  }
}
