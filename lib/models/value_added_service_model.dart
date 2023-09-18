/*
  增值服务
 */

class ValueAddedServiceModel {
  late int id;
  late String content;
  late String remark;
  late int enabled;
  late int? charge;
  late String createdAt;
  late String updatedAt;
  late int companyId;
  late bool isOpen;
  late String? name;
  late num? price;

  ValueAddedServiceModel(
      {required this.id,
      required this.content,
      required this.remark,
      required this.enabled,
      required this.charge,
      required this.createdAt,
      required this.updatedAt,
      required this.companyId,
      this.isOpen = false});

  ValueAddedServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'] ?? "";
    remark = json['remark'];
    enabled = json['enabled'] ?? 0;
    charge = json['charge'] ?? 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    name = json['name'] ?? "";
    price = json['price'] ?? 0;
    isOpen = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['remark'] = remark;
    data['enabled'] = enabled;
    data['charge'] = charge;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['name'] = name;
    return data;
  }
}
