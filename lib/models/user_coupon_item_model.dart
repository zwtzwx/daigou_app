/*
  优惠券明细
  券本身信息
 */
class UserCouponItemModel {
  late int id;
  late int scope;
  late String name;
  late int couponTypeId;
  late int amount;
  late int threshold;
  late bool enabled;
  late int totalCount;
  late int usedCount;
  late String expiredAt;
  late String effectedAt;
  late int companyId;
  int? templateId;
  late int isShared;
  late String shareCode;
  late String shareQrCode;
  late int shareTotalCount;
  late int shareCount;
  late int shareEachCount;
  String? shareBeginAt;
  String? shareEndAt;
  late int ignoreLaunchCount;
  late String createdAt;
  late String updatedAt;
  late List<Map> usableLines;
  int? discountType;
  num? weight;
  num? minWeight;

  UserCouponItemModel(
      {required this.id,
      required this.scope,
      required this.name,
      required this.couponTypeId,
      required this.amount,
      required this.threshold,
      required this.enabled,
      required this.totalCount,
      required this.usedCount,
      required this.expiredAt,
      required this.effectedAt,
      required this.companyId,
      required this.templateId,
      required this.isShared,
      required this.shareCode,
      required this.shareQrCode,
      required this.shareTotalCount,
      required this.shareCount,
      required this.shareEachCount,
      this.shareBeginAt,
      this.shareEndAt,
      required this.ignoreLaunchCount,
      required this.createdAt,
      required this.updatedAt,
      required this.usableLines});

  UserCouponItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scope = json['scope'];
    name = json['name'];
    couponTypeId = json['coupon_type_id'];
    amount = json['amount'];
    threshold = json['threshold'];
    enabled = json['enabled'];
    discountType = json['discount_type'];
    totalCount = json['total_count'];
    usedCount = json['used_count'];
    expiredAt = json['expired_at'];
    effectedAt = json['effected_at'];
    companyId = json['company_id'];
    templateId = json['template_id'];
    isShared = json['is_shared'];
    shareCode = json['share_code'];
    shareQrCode = json['share_qr_code'];
    shareTotalCount = json['share_total_count'];
    shareCount = json['share_count'];
    shareEachCount = json['share_each_count'];
    shareBeginAt = json['share_begin_at'];
    shareEndAt = json['share_end_at'];
    ignoreLaunchCount = json['ignore_launch_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weight = json['weight'];
    minWeight = json['min_weight'];
    if (json['usable_lines'] != null) {
      usableLines = <Map>[];
      json['usable_lines'].forEach((v) {
        usableLines.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scope'] = scope;
    data['name'] = name;
    data['coupon_type_id'] = couponTypeId;
    data['amount'] = amount;

    data['threshold'] = threshold;
    data['enabled'] = enabled;
    data['total_count'] = totalCount;
    data['used_count'] = usedCount;
    data['expired_at'] = expiredAt;
    data['effected_at'] = effectedAt;
    data['company_id'] = companyId;
    data['template_id'] = templateId;
    data['is_shared'] = isShared;
    data['share_code'] = shareCode;
    data['share_qr_code'] = shareQrCode;
    data['share_total_count'] = shareTotalCount;
    data['share_count'] = shareCount;
    data['share_each_count'] = shareEachCount;
    data['share_begin_at'] = shareBeginAt;
    data['share_end_at'] = shareEndAt;
    data['ignore_launch_count'] = ignoreLaunchCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['usable_lines'] = usableLines.map((v) => v).toList();
    return data;
  }
}
