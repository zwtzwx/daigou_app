/*
  线路属性
 */
class ShipLinePropModel {
  late num expressLineId;
  late num propId;

  ShipLinePropModel({required this.expressLineId, required this.propId});

  ShipLinePropModel.fromJson(Map<String, dynamic> json) {
    expressLineId = json['express_line_id'] ?? 0;
    propId = json['prop_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['express_line_id'] = expressLineId;
    data['prop_id'] = propId;
    return data;
  }
}
