/*
  用户包裹订单统计数据
 */
class UserOrderCountModel {
  int? waitStorage;
  int? alreadyStorage;
  int? alreadyPacked;
  int? waitPack;
  int? waitPay;
  int? waitTran;
  int? shipping;
  int? checked;
  int? waitComment;
  int? couponCount;
  int? commissionSum;
  int? balance;

  UserOrderCountModel(
      {this.waitStorage,
      this.alreadyStorage,
      this.alreadyPacked,
      this.waitPack,
      this.waitPay,
      this.waitTran,
      this.shipping,
      this.checked,
      this.waitComment,
      this.couponCount,
      this.commissionSum,
      this.balance});

  UserOrderCountModel.fromJson(Map<String, dynamic> json) {
    waitStorage = json['wait_storage'];
    alreadyStorage = json['already_storage'];
    alreadyPacked = json['already_packed'];
    waitPack = json['wait_pack'];
    waitPay = json['wait_pay'];
    waitTran = json['wait_tran'];
    shipping = json['shipping'];
    checked = json['checked'];
    waitComment = json['wait_comment'];
    couponCount = json['coupon_count'];
    commissionSum = json['commission_sum'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wait_storage'] = waitStorage;
    data['already_storage'] = alreadyStorage;
    data['already_packed'] = alreadyPacked;
    data['wait_pack'] = waitPack;
    data['wait_pay'] = waitPay;
    data['wait_tran'] = waitTran;
    data['shipping'] = shipping;
    data['checked'] = checked;
    data['wait_comment'] = waitComment;
    data['coupon_count'] = couponCount;
    data['commission_sum'] = commissionSum;
    data['balance'] = balance;
    return data;
  }
}
