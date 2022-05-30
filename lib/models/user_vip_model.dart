/*
 * VIP会员
 */
import 'package:jiyun_app_client/models/user_vip_count_model.dart';
import 'package:jiyun_app_client/models/user_vip_level_model.dart';
import 'package:jiyun_app_client/models/user_vip_price_model.dart';

class UserVipModel {
  //用户基础信息
  late UserVipCountModel profile;
  //购买会员
  late List<UserVipPriceModel> priceList;
  //会员等级
  late List<UserVipLevel> levelList;
  //购买成长值信息
  String? levelRemark;

  UserVipModel(
      {required this.profile,
      required this.priceList,
      required this.levelList,
      this.levelRemark});

  UserVipModel.fromJson(Map<String, dynamic> json) {
    profile = (json['user_member'] != null
        ? UserVipCountModel.fromJson(json['user_member'])
        : null)!;
    if (json['price_list'] != null) {
      priceList = <UserVipPriceModel>[];
      json['price_list'].forEach((v) {
        priceList.add(UserVipPriceModel.fromJson(v));
      });
    }
    if (json['member_level_list'] != null) {
      levelList = <UserVipLevel>[];
      json['member_level_list'].forEach((v) {
        levelList.add(UserVipLevel.fromJson(v));
      });
    }
    levelRemark = json['member_level_illustrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_member'] = profile.toJson();
    data['price_list'] = priceList.map((v) => v.toJson()).toList();
    data['member_level_list'] = levelList.map((v) => v.toJson()).toList();
    data['member_level_illustrate'] = levelRemark;
    return data;
  }
}
