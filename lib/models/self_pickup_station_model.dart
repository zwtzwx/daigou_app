import 'package:jiyun_app_client/models/ship_line_prop_model.dart';

/*
  自提点信息
 */
class SelfPickupStationModel {
  late num id;
  late String name;
  num? countryId;
  String? address;
  String? contactor;
  String? contactInfo;
  late ShipLinePropModel? pivot;

  SelfPickupStationModel(
      {required this.id,
      required this.name,
      required this.countryId,
      required this.address,
      required this.contactor,
      required this.contactInfo,
      required this.pivot});

  SelfPickupStationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'] ?? 0;
    if (json['country'] != null) {
      countryId = json['country']['id'];
    }
    address = json['address'];
    contactor = json['contactor'];
    contactInfo = json['contact_info'];
    if (json['pivot'] != null) {
      pivot = ShipLinePropModel.fromJson(json['pivot']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    data['address'] = address;
    data['contactor'] = contactor;
    data['contact_info'] = contactInfo;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}
