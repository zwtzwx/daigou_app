class PriceModel {
  late String discount;
  late num originPrice;

  PriceModel();

  PriceModel.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    originPrice = json['origin_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount'] = discount;
    data['origin_price'] = originPrice;
    return data;
  }
}
