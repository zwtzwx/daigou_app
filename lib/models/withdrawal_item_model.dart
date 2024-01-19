/*
  代理佣金提现记录
 */
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/models/withdrawal_model.dart';

class WithdrawalItemModel {
  late int id;
  late num amount;
  late num confirmAmount;
  late int type;
  late int status;
  late String remark;
  late String customerRemark;
  List<String>? customerImages;
  late String operator;
  late int userId;
  late int companyId;
  late String createdAt;
  late String updatedAt;
  late String account;
  late String serialNo;
  late String fullname;
  late String idcard;
  late String bankCode;
  late String bankName;
  late String bankNumber;
  late String phone;
  late String email;
  late String address;
  late String faceImg;
  late String backImg;
  late String withdrawTypeName;
  UserModel? user;
  List<WithdrawalModel>? commissions;

  WithdrawalItemModel({
    required this.id,
    required this.amount,
    required this.confirmAmount,
    required this.type,
    required this.status,
    required this.remark,
    required this.customerRemark,
    required this.customerImages,
    required this.operator,
    required this.userId,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.account,
    required this.serialNo,
    required this.fullname,
    required this.idcard,
    required this.bankCode,
    required this.bankName,
    required this.bankNumber,
    required this.phone,
    required this.email,
    required this.address,
    required this.faceImg,
    required this.backImg,
    required this.withdrawTypeName,
    this.user,
    this.commissions,
  });

  WithdrawalItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    confirmAmount = json['confirm_amount'];
    type = json['type'];
    status = json['status'];
    remark = json['remark'];
    customerRemark = json['customer_remark'] ?? '';
    if (json['customer_images'] != null) {
      customerImages = json['customer_images'].cast<String>();
    }
    operator = json['operator'] ?? '';
    userId = json['user_id'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    account = json['account'] ?? '';
    serialNo = json['serial_no'];
    fullname = json['fullname'];
    idcard = json['idcard'];
    bankCode = json['bank_code'];
    bankName = json['bank_name'];
    bankNumber = json['bank_number'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    faceImg = json['face_img'];
    backImg = json['back_img'];
    withdrawTypeName = json['withdraw_type_name'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    if (json['commissions'] != null) {
      List<WithdrawalModel> list = [];
      for (var item in json['commissions']) {
        list.add(WithdrawalModel.fromJson(item));
      }
      commissions = list;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['confirm_amount'] = confirmAmount;
    data['type'] = type;
    data['status'] = status;
    data['remark'] = remark;
    data['customer_remark'] = customerRemark;
    data['customer_images'] = customerImages;
    data['operator'] = operator;
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['account'] = account;
    data['serial_no'] = serialNo;
    data['fullname'] = fullname;
    data['idcard'] = idcard;
    data['bank_code'] = bankCode;
    data['bank_name'] = bankName;
    data['bank_number'] = bankNumber;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['face_img'] = faceImg;
    data['back_img'] = backImg;
    data['withdraw_type_name'] = withdrawTypeName;
    data['user'] = user?.toJson();
    return data;
  }
}
