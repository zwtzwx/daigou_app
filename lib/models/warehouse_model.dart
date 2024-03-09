import 'package:shop_app_client/models/country_model.dart';

/*
  仓库信息
 */
class WareHouseModel {
  int? id;
  String? warehouseName;
  String? receiverName;
  String? timezone;
  String? phone;
  String? postcode;
  String? address;
  String? code;
  String? tips;
  String? lat;
  String? lng;
  int? autoLocation;
  String? createdAt;
  String? updatedAt;
  int? companyId;
  String? shortAddress;
  int? customSort;
  int? enabled;
  int? mode;
  String? province;
  String? city;
  String? district;
  int? freeStoreDays;
  int? storeFee;
  List<CountryModel>? countries;

  WareHouseModel(
      {this.id,
      this.warehouseName,
      this.receiverName,
      this.timezone,
      this.phone,
      this.postcode,
      this.address,
      this.code,
      this.tips,
      this.lat,
      this.lng,
      this.autoLocation,
      this.createdAt,
      this.updatedAt,
      this.companyId,
      this.shortAddress,
      this.customSort,
      this.enabled,
      this.mode,
      this.province,
      this.city,
      this.district,
      this.freeStoreDays,
      this.storeFee,
      this.countries});

  WareHouseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseName = json['warehouse_name'];
    receiverName = json['receiver_name'];
    timezone = json['timezone'];
    phone = json['phone'];
    postcode = json['postcode'];
    address = json['address'];
    code = json['code'];
    tips = json['tips'];
    enabled = json['enabled'];
    lat = json['lat'];
    lng = json['lng'];
    autoLocation = json['auto_location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    shortAddress = json['short_address'];
    customSort = json['custom_sort'];
    mode = json['mode'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    freeStoreDays = json['free_store_days'];
    storeFee = json['store_fee'];
    if (json['countries'] != null) {
      countries = List<CountryModel>.empty(growable: true);
      json['countries'].forEach((v) {
        countries!.add(CountryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warehouse_name'] = warehouseName;
    data['receiver_name'] = receiverName;
    data['timezone'] = timezone;
    data['phone'] = phone;
    data['postcode'] = postcode;
    data['address'] = address;
    data['code'] = code;
    data['tips'] = tips;
    data['lat'] = lat;
    data['lng'] = lng;
    data['auto_location'] = autoLocation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['short_address'] = shortAddress;
    data['custom_sort'] = customSort;
    data['enabled'] = enabled;
    data['mode'] = mode;
    data['province'] = province;
    data['city'] = city;
    data['district'] = district;
    data['free_store_days'] = freeStoreDays;
    data['store_fee'] = storeFee;
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
