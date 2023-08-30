class PlatformGoodsServiceModel {
  int? id;
  String? name;
  String? remark;
  num? fee;
  int? status;
  int? feeType;
  num? serviceFee;

  PlatformGoodsServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    remark = json['remark'];
    fee = json['fee'];
    status = json['status'];
    feeType = json['fee_type'];
    serviceFee = json['service_fee'];
  }
}
