/*
  订单异常说明
 */

import 'package:huanting_shop/config/app_config.dart';

class OrderExceptionalModel {
  late int id;
  late int orderId;
  late String remark;
  String? restoreRemark;
  late List<String> images;
  late String operator;
  late String createdAt;
  late String updatedAt;
  late int companyId;

  OrderExceptionalModel(
      {required id,
      required orderId,
      required remark,
      restoreRemark,
      required images,
      required operator,
      required createdAt,
      required updatedAt,
      required companyId});

  OrderExceptionalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    remark = json['remark'];
    restoreRemark = json['restore_remark'];
    List<String> list = [];
    for (var item in json['images']) {
      list.add(AppConfig.getImageApi() + item);
    }
    images = list;
    operator = json['operator'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['remark'] = remark;
    data['restore_remark'] = restoreRemark;
    data['images'] = images;
    data['operator'] = operator;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    return data;
  }
}
