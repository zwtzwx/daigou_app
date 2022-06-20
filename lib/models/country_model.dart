import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/pivot_model.dart';

/*
  国家
  省、市、区
 */
class CountryModel {
  int? id;
  String? name;
  String? cnName;
  String? enName;
  int? index;
  String? code;
  String? createdAt;
  String? updatedAt;
  int? companyId;
  String? timezone;
  int? enabled;
  int? regionsCount;
  PivotModel? pivot;
  List<AreaModel>? areas;

  CountryModel();

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cnName = json['cn_name'];
    enName = json['en_name'];
    index = json['index'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    timezone = json['timezone'];
    enabled = json['enabled'];
    regionsCount = json['regions_count'];
    if (json['pivot'] != null) {
      pivot = PivotModel.fromJson(json['pivot']);
    }
    if (json['areas'] != null) {
      areas = List<AreaModel>.empty(growable: true);
      json['areas'].forEach((v) {
        areas!.add(AreaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cn_name'] = cnName;
    data['en_name'] = enName;
    data['index'] = index;
    data['code'] = code;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['timezone'] = timezone;
    data['enabled'] = enabled;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (areas != null) {
      data['areas'] = areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
