import 'package:flutter/material.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_service_model.dart';

class CartModel {
  dynamic shopId;
  String? shopName;
  num? freightFee;
  num? goodsAmount;
  late List<CartSkuModel> skus;

  List<int>? addServiceIds;
  TextEditingController? remarkController;
  FocusNode? remarkNode;
  PlatformGoodsServiceModel? service;

  CartModel.fromJson(
    Map<String, dynamic> json, {
    bool initTextEdit = false,
  }) {
    if (json['shop'] is Map) {
      shopId = json['shop']['id'];
      shopName = json['shop']['name'];
      freightFee = json['shop']['freight_fee'];
      goodsAmount = json['shop']['goods_amount'];
    }
    skus = [];
    if (json['skus'] is List) {
      for (var sku in json['skus']) {
        skus.add(CartSkuModel.fromJson(sku));
      }
    }
    if (initTextEdit) {
      // 订单预览
      addServiceIds = [];
      remarkController = TextEditingController();
      remarkNode = FocusNode();
    }
  }
}

class CartSkuModel {
  late int id;
  late String name;
  late num price;
  late int quantity;
  late num amount;
  int? goodsSkuId;
  dynamic goodsId;
  int? warehouseId;
  String? warehouseName;
  String? platform;
  String? platformUrl;
  String? remark;
  num? freightFee;
  int? cartType;

  CartSkuInfoModel? skuInfo;
  bool checked = false;
  bool changeQty = false;

  CartSkuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    price = json['price'];
    goodsSkuId = json['goods_sku_id'];
    amount = json['amount'];
    goodsId = json['goods_id'];
    quantity = json['quantity'] is String
        ? int.parse(json['quantity'])
        : json['quantity'];
    warehouseId = json['warehouse_id'];
    warehouseName = json['warehouse_name'];
    platform = json['platform'];
    platformUrl = json['platform_url'];
    remark = json['remark'];

    freightFee = json['freight_fee'];
    cartType = json['cart_type'];
    if (json['sku_info'] != null) {
      skuInfo = CartSkuInfoModel.fromJson(json['sku_info']);
    }
  }
}

class CartSkuInfoModel {
  late int id;
  String? picUrl;
  late List<Map<String, dynamic>> attributes;
  late int qty;
  late num price;
  String? shopName;
  int? minOrderQuantity;
  int? batchNumber;

  CartSkuInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    picUrl = json['pic_url'] ?? json['sku_img'];
    qty = json['qty'] is String ? int.parse(json['qty']) : (json['qty'] ?? 1);
    price = json['price'] ?? 0;
    minOrderQuantity = json['min_order_quantity'];
    batchNumber = json['batch_number'];
    shopName = json['shop_name'];
    attributes = [];
    if (json['spec'] is List) {
      for (var ele in json['spec']) {
        attributes.add(ele);
      }
    }
    if (json['specs'] is List) {
      for (var ele in json['specs']) {
        attributes.add(ele);
      }
    }
    if (json['attributes'] is List) {
      for (var ele in json['attributes']) {
        attributes.add(ele);
      }
    }
  }
}
