/*
  货物属性
 */
class GoodsPropsModel {
  late int id;
  String? cnName;
  String? enName;
  String? name;
  String? propName;
  // GoodsPropPivotModel? pivot;

  GoodsPropsModel();

  GoodsPropsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cnName = json['cn_name'];
    enName = json['en_name'];
    name = json['name'];
    propName = json['prop_name'];
    // if (json['pivot'] != null) {
    //   pivot = GoodsPropPivotModel.fromJson(json['pivot']);
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cn_name'] = cnName;
    data['en_name'] = enName;
    data['name'] = name;
    data['prop_name'] = propName;
    // if (pivot != null) {
    //   data['pivot'] = pivot!.toJson();
    // }
    return data;
  }
}
