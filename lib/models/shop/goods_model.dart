import 'package:jiyun_app_client/models/shop/goods_sku_model.dart';
import 'package:jiyun_app_client/models/shop/goods_spec_model.dart';

class GoodsModel {
  late dynamic id;
  late String name;
  int? categoryId;
  late List<String> images;
  int? status;
  String? goodsLowestPrice;
  late String remark;
  List<GoodsSkuModel>? skus;
  List<GoodsSpecModel>? options;
  int? saleCount;

  GoodsModel(
      {required this.id,
      required this.name,
      this.categoryId,
      required this.images,
      this.status,
      required this.remark,
      this.goodsLowestPrice});

  GoodsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    images = (json['images'] ?? []).cast<String>();
    status = json['status'];
    goodsLowestPrice = json['goods_lowest_price'];
    remark = json['remark'] ?? '';
    saleCount = json['sale_count'];
    if (json['skus'] != null) {
      skus = List<GoodsSkuModel>.empty(growable: true);
      for (var ele in json['skus']) {
        skus!.add(GoodsSkuModel.fromJson(ele));
      }
    }
    if (json['options'] != null) {
      options = List<GoodsSpecModel>.empty(growable: true);
      for (var ele in json['options']) {
        options!.add(GoodsSpecModel.fromJson(ele));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['images'] = images;
    data['status'] = status;
    data['goods_lowest_price'] = goodsLowestPrice;
    return data;
  }
}
