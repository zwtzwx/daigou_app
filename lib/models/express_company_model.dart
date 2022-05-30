/*
  快递公司
 */
class ExpressCompanyModel {
  late int id;
  late String name;
  late String num;
  late int companyId;
  String? createdAt;
  String? updatedAt;

  ExpressCompanyModel();

  ExpressCompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    num = json['num'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['num'] = num;
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
