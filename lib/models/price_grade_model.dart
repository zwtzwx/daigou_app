/*
  价格等级
 */
class PriceGradeModel {
  late num id;
  late num start;
  late num end;
  late num salePrice;
  late num expressLineId;

  PriceGradeModel(
      {required this.id,
      required this.start,
      required this.end,
      required this.salePrice,
      required this.expressLineId});

  PriceGradeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'];
    end = json['end'];
    salePrice = json['sale_price'];
    expressLineId = json['express_line_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start'] = start;
    data['end'] = end;
    data['sale_price'] = salePrice;
    data['express_line_id'] = expressLineId;
    return data;
  }
}
