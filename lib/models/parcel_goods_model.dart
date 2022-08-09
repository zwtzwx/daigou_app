/*
  包裹商品详细
 */

class ParcelGoodsModel {
  String? name;
  int? qty;
  double? price;
  int? totalPrice;
  int? unitPrice;

  ParcelGoodsModel({this.name, this.qty, this.price, this.totalPrice});

  ParcelGoodsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    qty = json['qty'];
    totalPrice = json['total_price'];
    unitPrice = json['unit_price'];
    price = json['unit_price'] / 100;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['qty'] = qty;
    data['price'] = price;
    data['total_price'] = totalPrice;
    return data;
  }
}
