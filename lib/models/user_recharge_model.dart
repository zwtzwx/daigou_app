/*
  用户充值记录模型
 */

import 'package:jiyun_app_client/models/pay_type_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';

class UserRechargeModel {
  late int id;
  late int paymentTypeId;
  late int userId;
  late int confirmAmount;
  late int status;
  late String customerRemark;
  late List<String> images;
  late String serialNo;
  late String outerSerialNo;
  late String operator;
  late String createdAt;
  late String updatedAt;
  // late int companyId;
  // late String deletedAt;
  late String payType;
  late UserModel user;
  late PayTypeModel paymentType;
  late bool select;

  late String remark;
  late num tranAmount;
  late String transferAccount;

  UserRechargeModel(
      {required this.id,
      required this.paymentTypeId,
      required this.userId,
      required this.confirmAmount,
      required this.status,
      required this.customerRemark,
      required this.images,
      required this.serialNo,
      required this.outerSerialNo,
      required this.operator,
      required this.createdAt,
      required this.updatedAt,
      // required this.companyId,
      // required this.deletedAt,
      required this.payType,
      required this.user,
      required this.paymentType,
      this.select = false});

  UserRechargeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentTypeId = json['payment_type_id'];
    userId = json['user_id'];
    confirmAmount = json['confirm_amount'];
    status = json['status'];
    customerRemark = json['customer_remark'] ?? "";
    images = json['images'].cast<String>();
    if (json['info'] != null) {
      remark = json['info']['remark'] ?? "";
      tranAmount = num.parse(json['info']['tran_amount'].toString());
      transferAccount = json['info']['transfer_account'] ?? "";
    }
    serialNo = json['serial_no'];
    outerSerialNo = json['outer_serial_no'];
    operator = (json['operator'] ?? "").toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // companyId = json['company_id'];
    // deletedAt = json['deleted_at'];
    payType = json['pay_type'];

    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }

    if (json['payment_type'] != null) {
      paymentType = PayTypeModel.fromJson(json['payment_type']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_type_id'] = paymentTypeId;
    data['user_id'] = userId;
    data['confirm_amount'] = confirmAmount;
    data['status'] = status;
    data['customer_remark'] = customerRemark;
    data['images'] = images;

    data['serial_no'] = serialNo;
    data['outer_serial_no'] = outerSerialNo;
    data['operator'] = operator;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['pay_type'] = payType;

    data['user'] = user.toJson();

    data['payment_type'] = paymentType.toJson();

    data['remark'] = remark;
    data['tran_amount'] = tranAmount;
    data['transfer_account'] = transferAccount;
    return data;
  }
}
