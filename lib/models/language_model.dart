/*
  语言
 */

class LanguageModel {
  late int id;
  late String name;
  late String languageCode;
  late int isDefault;
  late int enabled;
  late int companyId;
  String? createdAt;
  String? updatedAt;

  LanguageModel(
      {required this.id,
      required this.name,
      required this.languageCode,
      required this.isDefault,
      required this.enabled,
      required this.companyId,
      this.createdAt,
      this.updatedAt});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    languageCode = json['language_code'];
    isDefault = json['is_default'];
    enabled = json['enabled'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['language_code'] = languageCode;
    data['is_default'] = isDefault;
    data['enabled'] = enabled;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
