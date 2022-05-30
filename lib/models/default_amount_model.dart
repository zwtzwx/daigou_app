/*
  默认充值金额
 */
class DefaultAmountModel {
  late int id;
  late int amount;
  late int complimentaryAmount;

  DefaultAmountModel(
      {required this.id,
      required this.amount,
      required this.complimentaryAmount});

  DefaultAmountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    complimentaryAmount = json['complimentary_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['complimentary_amount'] = complimentaryAmount;
    return data;
  }
}
