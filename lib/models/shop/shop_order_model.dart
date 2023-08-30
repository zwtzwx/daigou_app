import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/shop/cart_model.dart';

class ShopOrderModel {
  late int id;
  late String orderSn;
  int? mode;
  ReceiverAddressModel? address;
  ShipLineModel? expressLine;
  num? amount;
  num? goodsAmount;
  num? freightFee;
  num? serviceFee;
  num? packageServiceFee;
  String? remark;
  String? paidAt;
  late int status;
  String? statusName;
  List<CartModel>? skus;
  String? createdAt;
  int? orderType;
  String? payEndAt;
  int? payStatus;
  String? shopId;

  ShopOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderSn = json['order_sn'];
    mode = json['mode'];
    packageServiceFee = json['package_service_fee'];
    if (json['address'] != null) {
      address = ReceiverAddressModel.fromJson(json['address']);
    }
    if (json['shop_id'] is num) {
      shopId = json['shop_id'].toString();
    } else {
      shopId = json['shop_id'];
    }
    freightFee = json['freight_fee'];
    serviceFee = json['service_fee'];
    orderType = json['order_type'];
    payStatus = json['pay_status'];
    payEndAt = json['pay_end_at'];
    amount = json['amount'];
    goodsAmount = json['goods_amount'];
    remark = json['remark'];
    status = json['status'];
    statusName = json['status_name'];
    paidAt = json['paid_at'];
    createdAt = json['created_at'];
    if (json['skus'] is List) {
      skus = [];
      Map<String, dynamic> shop = {
        'id': json['skus'].first['sku_info']['shop_id'],
        'name': json['skus'].first['sku_info']['shop_name'],
      };
      skus!.add(CartModel.fromJson({
        'skus': json['skus'],
        'shop': shop,
      }));
    }
    if (json['express_line'] != null) {
      expressLine = ShipLineModel.fromJson(json['express_line']);
    }
  }
}
