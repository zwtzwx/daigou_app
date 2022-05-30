/*
 * VIP会员等级
 */
class UserVipLevel {
  late int id;
  late String name;
  late int growthValue;

  UserVipLevel(
      {required this.id, required this.name, required this.growthValue});

  UserVipLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    growthValue = json['growth_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = name;
    data['growth_value'] = growthValue;
    return data;
  }
}
