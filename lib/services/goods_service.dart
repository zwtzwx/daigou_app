// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/goods_category_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';

class GoodsService {
  // 获取可以选择属性列表
  static const String PROPLIST = 'prop';
  // 获取可以选择分类列表
  static const String CATEGORIES = 'package-category';

  // 获取属性列表
  static Future<List<GoodsPropsModel>> getPropList(
      [Map<String, dynamic>? params]) async {
    List<GoodsPropsModel> result = List<GoodsPropsModel>.empty(growable: true);
    await HttpClient()
        .get(PROPLIST, queryParameters: params)
        .then((response) => {
              response.data?.forEach((good) {
                result.add(GoodsPropsModel.fromJson(good));
              })
            });
    return result;
  }

  // 获取分类列表
  static Future<List<GoodsCategoryModel>> getCategoryList(
      [Map<String, dynamic>? params]) async {
    List<GoodsCategoryModel> result =
        List<GoodsCategoryModel>.empty(growable: true);

    await HttpClient()
        .get(CATEGORIES, queryParameters: params)
        .then((response) {
      if (response.data != null) {
        response.data.forEach((good) {
          result.add(GoodsCategoryModel.fromJson(good));
        });
      }
    });
    return result;
  }
}
