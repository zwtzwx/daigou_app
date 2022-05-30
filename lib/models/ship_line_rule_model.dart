import 'package:jiyun_app_client/models/ship_line_condition_model.dart';

/*
  线路规则
 */
class ShipLineRule {
  late num id;
  late String name;
  late List<ShipLineConditionModel>? conditions;
  late num type;
  late num chargeMode;
  late num value;
  late num minCharge;
  late num maxCharge;
  late String notice;
  late num isAnd;

  ShipLineRule(
      {required this.id,
      required this.name,
      required this.conditions,
      required this.type,
      required this.chargeMode,
      required this.value,
      required this.minCharge,
      required this.maxCharge,
      required this.notice,
      required this.isAnd});

  ShipLineRule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['conditions'] != null) {
      conditions = List<ShipLineConditionModel>.empty(growable: true);
      json['conditions'].forEach((v) {
        conditions!.add(ShipLineConditionModel.fromJson(v));
      });
    }
    type = json['type'];
    chargeMode = json['charge_mode'];
    value = json['value'];
    minCharge = json['min_charge'];
    maxCharge = json['max_charge'];
    notice = json['notice'];
    isAnd = json['is_and'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (conditions != null) {
      data['conditions'] = conditions!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['charge_mode'] = chargeMode;
    data['value'] = value;
    data['min_charge'] = minCharge;
    data['max_charge'] = maxCharge;
    data['notice'] = notice;
    data['is_and'] = isAnd;
    return data;
  }
}
