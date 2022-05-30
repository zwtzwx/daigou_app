class SubAreaModel {
  late num id;
  late String code;
  late String name;
  late num enabled;
  late String apiCode;
  late String postcode;
  late num parentId;
  late num companyId;
  late num countryId;
  late String createdAt;
  num? isFaraway;
  late String updatedAt;
  int? notificationId;

  SubAreaModel(
      {required this.id,
      required this.code,
      required this.name,
      required this.enabled,
      required this.apiCode,
      required this.postcode,
      required this.parentId,
      required this.companyId,
      required this.countryId,
      required this.createdAt,
      required this.isFaraway,
      required this.updatedAt,
      required this.notificationId});

  SubAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    enabled = json['enabled'];
    apiCode = json['api_code'];
    postcode = json['postcode'];
    parentId = json['parent_id'];
    companyId = json['company_id'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    isFaraway = json['is_faraway'];
    updatedAt = json['updated_at'];
    notificationId = json['notification_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['enabled'] = enabled;
    data['api_code'] = apiCode;
    data['postcode'] = postcode;
    data['parent_id'] = parentId;
    data['company_id'] = companyId;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['is_faraway'] = isFaraway;
    data['updated_at'] = updatedAt;
    data['notification_id'] = notificationId;
    return data;
  }
}
