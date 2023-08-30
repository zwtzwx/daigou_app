import 'package:jiyun_app_client/models/shop/cart_model.dart';
import 'package:jiyun_app_client/models/shop/consult_model.dart';
import 'package:jiyun_app_client/models/shop/shop_order_model.dart';

class ProblemOrderModel {
  int? id;
  int? status;
  int? problemType;
  String? problemTypeName;
  String? amount;
  ShopOrderModel? order;
  List<ProblemOrderSkuModel>? problemSkus;
  ProblemDetailInfo? oaf;
  late ConsultModel consult;

  ProblemOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    problemType = json['problem_type'];
    problemTypeName = json['problem_type_name'];
    amount = json['amount'];
    if (json['order'] != null) {
      order = ShopOrderModel.fromJson(json['order']);
    }
    if (json['problem_skus'] is List) {
      problemSkus = [];
      for (var e in json['problem_skus']) {
        problemSkus!.add(ProblemOrderSkuModel.fromJson(e));
      }
    }
    if (json['oaf'] != null) {
      oaf = ProblemDetailInfo.fromJson(json['oaf']);
    }
    if (json['consult'] != null) {
      consult = ConsultModel.fromJson(json['consult']);
    } else {
      consult = ConsultModel(
        contents: [],
        content: '',
        problemOrderId: id,
        orderSn: order?.orderSn,
        orderId: order?.id,
      );
    }
  }
}

class ProblemDetailInfo {
  String? remark;
  int? id;
  String? sn;

  ProblemDetailInfo.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    id = json['id'];
    sn = json['sn'];
  }
}

class ProblemOrderSkuModel {
  int? type;
  int? id;
  String? problemReason;
  String? remark;
  String? amount;
  CartModel? sku;

  ProblemOrderSkuModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    problemReason = json['problem_reason'];
    remark = json['remark'];
    amount = json['amount'];
    if (json['sku'] != null) {
      Map<String, dynamic> shop = {
        'id': json['sku']['sku_info']['shop_id'],
        'name': json['sku']['sku_info']['shop_name'],
      };
      sku = CartModel.fromJson({
        'shop': shop,
        'skus': [json['sku']]
      });
    }
  }
}
