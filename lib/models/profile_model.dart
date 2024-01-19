import 'package:huanting_shop/models/area_model.dart';
import 'package:huanting_shop/models/country_model.dart';
import 'package:huanting_shop/models/sub_area_model.dart';

/*
  个人资料
 */
class ProfileModel {
  late num id;
  AreaModel? area;
  late String city;
  late String phone;
  late String street;
  late num areaId;
  CountryModel? country;
  late String doorNo;
  late String idCard;
  late num userId;
  late String district;
  late String postcode;
  late String province;
  SubAreaModel? subArea;
  late String timezone;
  late String wechatId;
  late num companyId;
  int? countryId;
  late String createdAt;
  late String updatedAt;
  late int subAreaId;
  late String countryName;
  late num isCnAddress;
  late String receiverName;

  ProfileModel(
      {required this.id,
      required this.area,
      required this.city,
      required this.phone,
      required this.street,
      required this.areaId,
      required this.country,
      required this.doorNo,
      required this.idCard,
      required this.userId,
      required this.district,
      required this.postcode,
      required this.province,
      required this.subArea,
      required this.timezone,
      required this.wechatId,
      required this.companyId,
      required this.countryId,
      required this.createdAt,
      required this.updatedAt,
      required this.subAreaId,
      required this.countryName,
      required this.isCnAddress,
      required this.receiverName});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    area = json['area'] != null ? AreaModel.fromJson(json['area']) : null;
    city = json['city'] ?? '';
    phone = json['phone'] ?? '';
    street = json['street'] ?? '';
    areaId = json['area_id'] ?? 0;
    country = (json['country'] != null
        ? CountryModel.fromJson(json['country'])
        : null);
    doorNo = json['door_no'] ?? '';
    idCard = json['id_card'] ?? '';
    userId = json['user_id'] ?? 0;
    district = json['district'] ?? '';
    postcode = json['postcode'] ?? '';
    province = json['province'] ?? '';
    subArea = (json['sub_area'] != null
        ? SubAreaModel.fromJson(json['sub_area'])
        : null);
    timezone = json['timezone'] ?? '';
    wechatId = json['wechat_id'] ?? '';
    companyId = json['company_id'] ?? 0;
    countryId = json['country_id'];
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    subAreaId = json['sub_area_id'] ?? 0;
    countryName = json['country_name'] ?? '';
    isCnAddress = json['is_cn_address'] ?? 0;
    receiverName = json['receiver_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    data['city'] = city;
    data['phone'] = phone;
    data['street'] = street;
    data['area_id'] = areaId;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['door_no'] = doorNo;
    data['id_card'] = idCard;
    data['user_id'] = userId;
    data['district'] = district;
    data['postcode'] = postcode;
    data['province'] = province;
    if (subArea != null) {
      data['sub_area'] = subArea!.toJson();
    }
    data['timezone'] = timezone;
    data['wechat_id'] = wechatId;
    data['company_id'] = companyId;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sub_area_id'] = subAreaId;
    data['country_name'] = countryName;
    data['is_cn_address'] = isCnAddress;
    data['receiver_name'] = receiverName;
    return data;
  }
}
