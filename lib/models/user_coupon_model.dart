/*
  优惠券
  券的生命周期，包括券的使用信息
 */
import 'package:shop_app_client/models/user_coupon_item_model.dart';

class UserCouponModel {
  late int id;
  late int userId;
  late int couponId;
  late String couponCode;
  String? usedAt;
  String? orderNumber;
  late num orderAmount;
  String? paidAt;
  String? createdAt;
  String? updatedAt;
  late bool enabled;
  late String status;
  late bool canUse;
  UserCouponItemModel? coupon;
  bool isOpen = false;
  String? remark;

  UserCouponModel(
      {required this.id,
      required this.userId,
      required this.couponId,
      required this.couponCode,
      this.usedAt,
      this.orderNumber,
      this.orderAmount = 0,
      this.paidAt,
      this.createdAt,
      this.updatedAt,
      this.enabled = false,
      required this.status,
      this.canUse = false,
      this.coupon});

  UserCouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    couponId = json['coupon_id'];
    couponCode = json['coupon_code'];
    usedAt = json['used_at'];
    orderNumber = json['order_number'];
    orderAmount = json['order_amount'];
    paidAt = json['paid_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    enabled = json['enabled'];
    status = json['status'];
    canUse = json['can_use'];
    remark = json['remark'];
    if (json['coupon'] != null) {
      coupon = UserCouponItemModel.fromJson(json['coupon']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['coupon_id'] = couponId;
    data['coupon_code'] = couponCode;
    data['used_at'] = usedAt;
    data['order_number'] = orderNumber;
    data['order_amount'] = orderAmount;
    data['paid_at'] = paidAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['enabled'] = enabled;
    data['status'] = status;
    data['can_use'] = canUse;
    data['coupon'] = coupon?.toJson();
    return data;
  }
}
