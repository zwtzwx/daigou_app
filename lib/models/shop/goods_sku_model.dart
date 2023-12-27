class GoodsSkuModel {
  int? id;
  String? skuId;
  num? price;
  int? quantity;
  String? properties;
  String? specName;
  String? specId;
  late List<String> images;
  String? propertiesName;

  GoodsSkuModel();

  GoodsSkuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['sku_id'] is num) {
      skuId = json['sku_id'].toString();
    } else {
      skuId = json['sku_id'];
    }
    if (json['quantity'] is String) {
      quantity = int.parse(json['quantity']);
    } else {
      quantity = json['quantity'];
    }
    if (json['price'] is String) {
      price = num.parse(json['price']);
    } else {
      price = json['price'];
    }
    specName = json['spec_name'];
    properties = json['properties'];
    specId = json['spec_id'];
    if (json['images'] != null) {
      images = (json['images'] as List).cast<String>();
    } else {
      images = [];
    }
    if (json['properties_name'] is String &&
        json['properties_name'].isNotEmpty) {
      propertiesName = json['properties_name'];
      for (var str in properties!.split(';')) {
        var propStr = str + ':';
        propertiesName = propertiesName!.replaceAll(RegExp(propStr), '');
      }
    } else {
      propertiesName = properties;
    }
  }
}
