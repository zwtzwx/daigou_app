/*
  用户会员统计
  包括积分，成长值，当前等级
 */
class UserVipCountModel {
  late num userId;
  late num currentGrowthValue;
  late num point;
  late int levelId;
  late num lockPoint;
  late num nextGrowthValue;
  late String levelName;

  UserVipCountModel({
    required this.userId,
    required this.currentGrowthValue,
    required this.point,
    required this.levelId,
    required this.levelName,
    required this.nextGrowthValue,
  });

  UserVipCountModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    currentGrowthValue = json['growth_value'];
    point = json['point'];
    levelId = json['member_level_id'];
    levelName = json['member_level_name'];
    nextGrowthValue = json['next_level_growth_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['growth_value'] = currentGrowthValue;
    data['point'] = point;
    data['level_id'] = levelId;
    data['member_level_name'] = levelName;
    data['next_level_growth_value'] = nextGrowthValue;
    return data;
  }
}
