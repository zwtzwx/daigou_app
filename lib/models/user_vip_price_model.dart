/*
  会员中心 > 价格
 */
class UserVipPriceModel {
  late int id;
  late int basePriceId;
  late String name;
  //
  late num basePrice;
  //
  late num price;
  // 成长值
  late int growthValue;
  //标签，例如运费享几折
  late String illustrate;
  late int type;

  UserVipPriceModel({
    required this.id,
    required this.basePriceId,
    required this.name,
    required this.basePrice,
    required this.price,
    required this.growthValue,
    required this.illustrate,
    required this.type,
  });

  UserVipPriceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basePriceId = json['base_price_id'] ?? json['id'];
    name = json['name'];
    basePrice = json['base_price'] ?? json['price'];
    price = json['price'];
    growthValue = json['growth_value'];
    illustrate = json['illustrate'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['base_price_id'] = basePriceId;
    data['name'] = name;
    data['base_price'] = basePrice;
    data['price'] = price;
    data['growth_value'] = growthValue;
    data['illustrate'] = illustrate;
    data['type'] = type;
    return data;
  }
}
