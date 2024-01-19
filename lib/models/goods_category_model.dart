/*
  货物分类
 */
import 'package:huanting_shop/config/app_config.dart';

class GoodsCategoryModel {
  late int id;
  String? nameCn;
  String? nameEn;
  String? detail;
  String? riskWarningTitle;
  String? riskWarningContent;
  num? riskWarningEnabled;
  late String name;
  String? image;
  int? daigouEnabled;
  // late PivotModel? pivot;
  List<GoodsCategoryModel>? children;
  bool select = false;

  GoodsCategoryModel({
    required this.id,
    required this.name,
    this.image,
  });

  GoodsCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameCn = json['name_cn'].toString();
    nameEn = json['name_en'];
    detail = json['detail'];
    daigouEnabled = json['daigou_enabled'];
    riskWarningTitle = json['risk_warning_title'];
    riskWarningContent = json['risk_warning_content'];
    riskWarningEnabled = json['risk_warning_enabled'];
    // parentId = json['parent_id'];
    name = json['name'].toString();
    if (json['categories'] != null) {
      children = List<GoodsCategoryModel>.empty(growable: true);
      json['categories'].forEach((v) {
        children!.add(GoodsCategoryModel.fromJson(v));
      });
    }
    if (json['img'] is String) {
      if (json['img'].startsWith('/')) {
        image = AppConfig.getImageApi() + json['img'];
      } else {
        image = json['img'];
      }
    }
    // pivot =
    // (json['pivot'] != null ? PivotModel.fromJson(json['pivot']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_cn'] = nameCn;
    data['name_en'] = nameEn;
    data['detail'] = detail;
    data['risk_warning_title'] = riskWarningTitle;
    data['risk_warning_content'] = riskWarningContent;
    data['risk_warning_enabled'] = riskWarningEnabled;
    data['name'] = name;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    // if (pivot != null) {
    //   data['pivot'] = pivot!.toJson();
    // }
    data['select'] = false;
    return data;
  }
}
