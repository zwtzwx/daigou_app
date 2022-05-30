/*
  线路仓库规则
 */
class ShipLineConditionModel {
  late num id;
  late num param;
  late String paramName;
  late String comparison;
  late num value;
  late String createdAt;

  ShipLineConditionModel(
      {required this.id,
      required this.param,
      required this.paramName,
      required this.comparison,
      required this.value,
      required this.createdAt});

  ShipLineConditionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    param = json['param'];
    paramName = json['param_name'];
    comparison = json['comparison'];
    value = json['value'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['param'] = param;
    data['param_name'] = paramName;
    data['comparison'] = comparison;
    data['value'] = value;
    data['created_at'] = createdAt;
    return data;
  }
}
