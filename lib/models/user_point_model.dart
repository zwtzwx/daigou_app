/*
  积分总览模型
 */
class UserPointModel {
  late int id;
  late int companyId;
  late int userId;
  late int growthValue;
  late int point;
  late String createdAt;
  late String updatedAt;
  int? levelId;
  late int memberLevelId;
  late String memberLevelName;
  late String allPoint;
  late int configPoint;
  late String configAmount;

  UserPointModel();

  UserPointModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    growthValue = json['growth_value'];
    point = json['point'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    levelId = json['level_id'];
    memberLevelId = json['member_level_id'];
    memberLevelName = json['member_level_name'];
    allPoint = json['all_point'];
    configPoint = json['config_point'] ?? 0;
    configAmount = json['config_amount'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['user_id'] = userId;
    data['growth_value'] = growthValue;
    data['point'] = point;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['level_id'] = levelId;
    data['member_level_id'] = memberLevelId;
    data['member_level_name'] = memberLevelName;
    data['all_point'] = allPoint;
    data['config_point'] = configPoint;
    data['config_amount'] = configAmount;
    return data;
  }
}
