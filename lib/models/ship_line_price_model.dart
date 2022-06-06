/*
  线路价格
 */
class ShipLinePriceModel {
  late num id;
  late int type;
  late num start;
  late num end;
  late num price;
  num? unitWeight;
  num? firstWeight;

  ShipLinePriceModel(
      {required this.id,
      required this.type,
      required this.start,
      required this.end,
      required this.price,
      this.unitWeight,
      this.firstWeight});

  ShipLinePriceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    start = json['start'];
    end = json['end'];
    price = json['price'] ?? 0;
    unitWeight = json['unit_weight'];
    firstWeight = json['first_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['start'] = start;
    data['end'] = end;
    data['price'] = price;
    data['unit_weight'] = unitWeight;
    data['first_weight'] = firstWeight;
    return data;
  }
}
