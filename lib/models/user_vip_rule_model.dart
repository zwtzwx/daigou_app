class UserVipRuleModel {
  late bool growthIncrease;
  late bool growthBuy;
  late bool pointDecrease;
  late bool pointIncrease;
  late bool commentPointIncrease;

  UserVipRuleModel(
      {required this.growthIncrease,
      required this.growthBuy,
      required this.pointDecrease,
      required this.pointIncrease,
      required this.commentPointIncrease});

  UserVipRuleModel.fromJson(Map<String, dynamic> json) {
    growthIncrease = json['growth_increase'] == 1 ? true : false;
    growthBuy = json['growth_buy'] == 1 ? true : false;
    pointDecrease = json['point_decrease'] == 1 ? true : false;
    pointIncrease = json['point_increase'] == 1 ? true : false;
    commentPointIncrease = json['comment_point_increase'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['growth_increase'] = growthIncrease;
    data['growth_buy'] = growthBuy;
    data['point_decrease'] = pointDecrease;
    data['point_increase'] = pointIncrease;
    data['comment_point_increase'] = commentPointIncrease;
    return data;
  }
}
