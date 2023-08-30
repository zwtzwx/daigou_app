class InsuranceItemModel {
  late int id;
  late int insuranceProportion;
  late int enabled;
  late int companyId;
  late String createdAt;
  late String updatedAt;
  late String name;
  late int insuranceType;
  late int start;
  late String remark;
  late int isForce;
  num? max;
  num? min;

  InsuranceItemModel();

  InsuranceItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    insuranceProportion = json['insurance_proportion'];
    enabled = json['enabled'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    max = json['max'];
    min = json['min'];
    insuranceType = json['insurance_type'];
    start = json['start'];
    remark = json['remark'];
    isForce = json['is_force'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['insurance_proportion'] = insuranceProportion;
    data['enabled'] = enabled;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['insurance_type'] = insuranceType;
    data['start'] = start;
    data['remark'] = remark;
    data['is_force'] = isForce;
    return data;
  }
}
