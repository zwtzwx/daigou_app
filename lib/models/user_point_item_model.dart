/*
  积分成长值明细
 */
class UserPointItemModel {
  late int id;
  late String ruleName;
  late int type;
  late int value;
  late int isValid;
  late String createdAt;

  UserPointItemModel(
      {required this.id,
      required this.ruleName,
      required this.type,
      required this.value,
      required this.isValid,
      required this.createdAt});

  UserPointItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ruleName = json['rule_name'];
    type = json['type'];
    value = json['value'];
    isValid = json['is_valid'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rule_name'] = ruleName;
    data['type'] = type;
    data['value'] = value;
    data['is_valid'] = isValid;
    data['created_at'] = createdAt;
    return data;
  }
}
