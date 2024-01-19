// ignore_for_file: constant_identifier_names

import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/goods_category_model.dart';
import 'package:huanting_shop/models/goods_props.dart';

class GoodsService {
  // 获取可以选择属性列表
  static const String PROPLIST = 'prop';
  // 获取可以选择分类列表
  static const String CATEGORIES = 'package-category';
  // 属性配置：单选、多选
  static const String propConfigApi = 'package/configs';

  // 获取属性列表
  static Future<List<ParcelPropsModel>> getPropList(
      [Map<String, dynamic>? params]) async {
    List<ParcelPropsModel> result =
        List<ParcelPropsModel>.empty(growable: true);
    await BeeRequest.instance
        .get(PROPLIST, queryParameters: params)
        .then((response) => {
              response.data?.forEach((good) {
                result.add(ParcelPropsModel.fromJson(good));
              })
            });
    return result;
  }

  // 获取属性配置
  static Future<bool> getPropConfig() async {
    bool result = false;
    await BeeRequest.instance.get(propConfigApi).then((res) {
      if (res.ok) {
        result = res.data['package_prop'] == 1;
      }
    });
    return result;
  }

  // 获取分类列表
  static Future<List<GoodsCategoryModel>> getCategoryList(
      [Map<String, dynamic>? params]) async {
    List<GoodsCategoryModel> result =
        List<GoodsCategoryModel>.empty(growable: true);

    await BeeRequest.instance
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
