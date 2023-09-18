/*
  第三方平台商品（淘宝、京东等）
 */
import 'package:jiyun_app_client/models/shop/goods_props_model.dart';
import 'package:jiyun_app_client/models/shop/goods_sku_model.dart';

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
  List<String>? images;
  List<GoodsPropsModel>? propsList;
  List<GoodsSkuModel>? skus;
  String? shopId;

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
    platform = json['platform'];
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

  List<String> get stockSkus => (skus ?? [])
      .where((ele) => ele.quantity != 0)
      .map((e) => e.properties ?? '')
      .toList();
}
