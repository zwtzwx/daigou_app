/*
  第三方平台商品（淘宝、京东等）
 */
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/shop/goods_props_model.dart';
import 'package:shop_app_client/models/shop/goods_sku_model.dart';
import 'package:shop_app_client/services/shop_service.dart';

class PlatformGoodsModel {
  late String title;
  String? picUrl;
  num? price;
  String? sales;
  late dynamic id;
  String? platform;
  String? detailUrl;
  String? desc;
  String? nick;
  int? minOrderQuantity;
  int? batchNumber;
  List<String>? images;
  List<GoodsPropsModel>? propsList;
  List<GoodsSkuModel>? skus;
  String? shopId;
  String? mainVideo;
  String? detailVideo;



  PlatformGoodsModel.videoFromJson(Map<String, dynamic> json) {
    title = json['title'];
    picUrl = json['pic_url'];
    if ((picUrl ?? '').startsWith('//')) {
      picUrl = 'https:$picUrl';
    }
    if (json['price'] is String) {
      json['price'] = json['price'].replaceAll(RegExp(r','), '');
      price = num.parse(json['price']);
    } else {
      price = json['price'];
    }
    if (json['sales'] is num) {
      sales = json['sales'].toString();
    } else {
      sales = json['sales'];
    }
    mainVideo = json['mainVideo'];
    detailVideo = json['detailVideo'];
    id = json['num_iid'];
    // 将视频加入images
    images = [];
    if(detailVideo!='') {
      images!.add(detailVideo!);
    }
    if(mainVideo!='') {
      images!.add(mainVideo!);
    }
    platform = json['platform'];
    minOrderQuantity = json['min_order_quantity'] ?? 1;
    batchNumber = json['batch_number'] ?? 1;
    detailUrl = json['detail_url'];
    if (json['shop_id'] is num) {
      shopId = json['shop_id'].toString();
    } else {
      shopId = json['shop_id'];
    }
    desc = json['desc'];
    nick = json['nick'];
    if (json['item_imgs'] != null) {
      // images = [];
      for (var ele in json['item_imgs']) {
        if ((ele as String).startsWith('//')) {
          images!.add('https:$ele');
        } else {
          images!.add(ele);
        }
      }
    }
    if (json['skus'] != null && json['skus']['sku'] is List) {
      skus = [];
      for (var ele in json['skus']['sku']) {
        if (json['props_img'] is Map) {
          var keys = (json['props_img'] as Map).keys.toList();
          var index = keys.indexWhere((key) => ele['properties'].contains(key));
          if (index != -1 && json['props_img'][keys[index]] != null) {
            var img = json['props_img'][keys[index]];
            if ((img as String).startsWith('//')) {
              img = 'https:$img';
            }
            ele['images'] = [img];
          }
        }
        skus!.add(GoodsSkuModel.fromJson(ele));
      }
    }
    if (json['props_list'] != null) {
      propsList = [];
      for (var ele in json['props_list']) {
        propsList!.add(GoodsPropsModel.fromJson(ele, stockSkus));
      }
    }
  }

  PlatformGoodsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    picUrl = json['pic_url'];
    if ((picUrl ?? '').startsWith('//')) {
      picUrl = 'https:$picUrl';
    }
    if (json['price'] is String) {
      json['price'] = json['price'].replaceAll(RegExp(r','), '');
      price = num.parse(json['price']);
    } else {
      price = json['price'];
    }
    if (json['sales'] is num) {
      sales = json['sales'].toString();
    } else {
      sales = json['sales'];
    }
    id = json['num_iid'];
    // 将视频加入images
    images = [];
    platform = json['platform'];
    minOrderQuantity = json['min_order_quantity'] ?? 1;
    batchNumber = json['batch_number'] ?? 1;
    detailUrl = json['detail_url'];
    if (json['shop_id'] is num) {
      shopId = json['shop_id'].toString();
    } else {
      shopId = json['shop_id'];
    }
    desc = json['desc'];
    nick = json['nick'];
    if (json['item_imgs'] != null) {
      images = [];
      for (var ele in json['item_imgs']) {
        if ((ele as String).startsWith('//')) {
          images!.add('https:$ele');
        } else {
          images!.add(ele);
        }
      }
    }
    if (json['skus'] != null && json['skus']['sku'] is List) {
      skus = [];
      for (var ele in json['skus']['sku']) {
        if (json['props_img'] is Map) {
          var keys = (json['props_img'] as Map).keys.toList();
          var index = keys.indexWhere((key) => ele['properties'].contains(key));
          if (index != -1 && json['props_img'][keys[index]] != null) {
            var img = json['props_img'][keys[index]];
            if ((img as String).startsWith('//')) {
              img = 'https:$img';
            }
            ele['images'] = [img];
          }
        }
        skus!.add(GoodsSkuModel.fromJson(ele));
      }
    }
    if (json['props_list'] != null) {
      propsList = [];
      for (var ele in json['props_list']) {
        propsList!.add(GoodsPropsModel.fromJson(ele, stockSkus));
      }
    }
  }

  // 属性翻译
  Future<void> propTs() async {
    if ((propsList ?? []).isEmpty) return;
    List<Future<void>> waitList = [];
    for (var prop in propsList!) {
      if (prop.name!.contianCN) {
        waitList.add(ShopService.getTranslate(prop.name!).then((data) {
          if (data != null) {
            skuTs('${prop.name}:', data);
            prop.name = data;
          }
        }));
      }

      for (GoodsPropsModel child in (prop.children ?? [])) {
        if (child.name!.contianCN) {
          waitList.add(ShopService.getTranslate(child.name!).then((data) {
            if (data != null) {
              skuTs(child.name!, data);
              child.name = data;
            }
          }));
        }
      }
    }
    await Future.wait(waitList);
  }

  void skuTs(String regStr, String value) {
    if (skus is List) {
      for (var sku in skus!) {
        sku.propertiesName =
            (sku.propertiesName ?? '').replaceAll(RegExp(regStr), value);
      }
    }
  }

  List<String> get stockSkus => (skus ?? [])
      .where((ele) => ele.quantity != 0)
      .map((e) => e.properties ?? '')
      .toList();
}
