import 'package:shop_app_client/models/region_area_model.dart';
import 'package:shop_app_client/models/ship_line_rule_model.dart';
import 'package:shop_app_client/models/ship_line_service_model.dart';
import 'package:shop_app_client/models/ship_line_price_model.dart';

class RegionModel {
  late num id;
  late String name;
  late String referenceTime;
  late int enabled;
  List<ShipLinePriceModel>? prices;
  List<ShipLineServiceModel>? services;
  List<ShipLineRule>? rules;
  List<RegionAreaModel>? areas;

  RegionModel(
      {required this.id,
      required this.name,
      required this.referenceTime,
      required this.enabled,
      this.prices,
      this.services,
      this.rules,
      this.areas});

  RegionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    referenceTime = json['reference_time'];
    enabled = json['enabled'];
    if (json['prices'] != null) {
      prices = List<ShipLinePriceModel>.empty(growable: true);
      json['prices'].forEach((v) {
        prices!.add(ShipLinePriceModel.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = List<ShipLineServiceModel>.empty(growable: true);
      json['services'].forEach((v) {
        services!.add(ShipLineServiceModel.fromJson(v));
      });
    }
    if (json['rules'] != null) {
      rules = List<ShipLineRule>.empty(growable: true);
      json['rules'].forEach((v) {
        rules!.add(ShipLineRule.fromJson(v));
      });
    }
    if (json['areas'] != null) {
      areas = List<RegionAreaModel>.empty(growable: true);
      json['areas'].forEach((v) {
        areas!.add(RegionAreaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['reference_time'] = referenceTime;
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (rules != null) {
      data['rules'] = rules!.map((v) => v.toJson()).toList();
    }
    if (areas != null) {
      data['areas'] = areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
