/*
  属性下面的支持线路
  用不太到
 */
class GoodsPropPivotModel {
  late int expressLineId;
  late int propId;

  GoodsPropPivotModel({required this.expressLineId, required this.propId});

  GoodsPropPivotModel.fromJson(Map<String, dynamic> json) {
    expressLineId = json['express_line_id'];
    propId = json['prop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['express_line_id'] = expressLineId;
    data['prop_id'] = propId;
    return data;
  }
}
