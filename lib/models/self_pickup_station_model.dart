import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
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
  ShipLinePropModel? pivot;

  AreaModel? area;
  AreaModel? subArea;
  CountryModel? country;
  num? limitLength;
  num? limitManyWeight;
  num? limitOneWeight;
  String? announcement;
  String? openingHours;
  List<ShipLineModel>? expressLines;

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
    if (json['area'] != null) {
      area = AreaModel.fromJson(json['area']);
    }
    if (json['sub_area'] != null) {
      subArea = AreaModel.fromJson(json['sub_area']);
    }
    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country']);
    }
    limitLength = json['limit_length'];
    limitManyWeight = json['limit_many_weight'];
    limitOneWeight = json['limit_one_weight'];
    announcement = json['announcement'];
    openingHours = json['opening_hours'];
    if (json['expressLines'] != null) {
      List<ShipLineModel> list = [];
      json['expressLines'].forEach((item) {
        list.add(ShipLineModel.fromJson(item));
      });
      expressLines = list;
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
