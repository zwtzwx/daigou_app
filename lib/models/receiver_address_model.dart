import 'package:shop_app_client/models/area_model.dart';
import 'package:shop_app_client/models/country_model.dart';
import 'package:shop_app_client/models/self_pickup_station_model.dart';

/*
  收件人地址
 */
class ReceiverAddressModel {
  /*
    地址ID
   */
  late int? id;
  /*
    用户ID
   */
  late int userId;
  /*
    收件人
   */
  late String receiverName;
  /*
    手机区号
   */
  late String timezone;
  /*
    手机号
   */
  late String phone;

  /*
    国家ID
   */
  late int countryId;
  /*
    城市
   */
  late String city;
  /*
    街道
   */
  late String street;
  /*
    门牌号
   */
  late String doorNo;
  /*
    邮编
   */
  late String postcode;

  /*
    地址
   */
  String? address;
  /*
    清关编码
   */
  late String clearanceCode;
  /*
    线路额外说明
   */
  late String lineExtraRemark;

  /*
    创建时间
   */
  late String createdAt;
  /*
    更新时间
   */
  late String updatedAt;
  /*
    身份证号码
   */
  late String idCard;
  /*
    微信ID
   */
  late String wechatId;
  /*
    省/州
   */
  late String province;
  /*
    区/县
   */
  late String district;
  /*
    是否中国地址
   */
  late int isCnAddress;

  /*
    区域ID
   */
  late int areaId;
  /*
    三级区域ID
   */
  late int subAreaId;

  /*
    EMAIL
   */
  late String email;
  /*
    是否默认
   */
  late int isDefault;

  /*
    是否无效
   */
  late int isInvalid;

  /*
    国家名称
   */
  late String countryName;

  /*
    国家
   */
  CountryModel? country;
  AreaModel? subArea;
  AreaModel? area;
  int? addressType;
  SelfPickupStationModel? station;

  ReceiverAddressModel();

  ReceiverAddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['area'] != null) {
      area = AreaModel.fromJson(json['area']);
    }
    city = json['city'] ?? '';
    phone = json['phone'] ?? '';
    timezone = json['timezone'] ?? '';
    addressType = json['address_type'];
    userId = json['user_id'];
    receiverName = json['receiver_name'] ?? '';
    countryId = json['country_id'];
    street = json['street'] ?? '';
    doorNo = json['door_no'] ?? '';
    postcode = json['postcode'] ?? '';
    address = json['address'];
    clearanceCode = json['clearance_code'] ?? "";
    lineExtraRemark = json['line_extra_remark'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    idCard = json['id_card'] ?? '';
    wechatId = json['wechat_id'] ?? '';
    province = json['province'] ?? '';
    district = json['district'] ?? '';
    isCnAddress = json['is_cn_address'] ?? 0;
    areaId = json['area_id'] ?? 0;
    subAreaId = json['sub_area_id'] ?? 0;
    email = json['email'] ?? '';
    isDefault = json['is_default'] ?? 0;
    isInvalid = json['is_invalid'] ?? 0;
    countryName = json['country_name'] ?? '';

    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country']);
    }

    if (json['sub_area'] is Map) {
      subArea = AreaModel.fromJson(json['sub_area']);
    }
    if (json['station'] != null) {
      station = SelfPickupStationModel.fromJson(json['station']);
    }
  }

  ReceiverAddressModel.empty();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['receiver_name'] = receiverName;
    data['timezone'] = timezone;
    data['phone'] = phone;
    data['country_id'] = countryId;
    data['city'] = city;
    data['street'] = street;
    data['door_no'] = doorNo;
    data['postcode'] = postcode;
    data['address'] = address;
    data['clearance_code'] = clearanceCode;
    data['line_extra_remark'] = lineExtraRemark;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['id_card'] = idCard;
    data['wechat_id'] = wechatId;
    data['area'] = area!.toJson();
    data['province'] = province;
    data['district'] = district;
    data['is_cn_address'] = isCnAddress;
    data['area_id'] = areaId;
    data['sub_area_id'] = subAreaId;
    data['email'] = email;
    data['is_default'] = isDefault;
    data['is_invalid'] = isInvalid;
    data['country_name'] = countryName;
    data['country'] = country?.toJson();
    data['sub_area'] = subArea?.toJson();
    return data;
  }

  String getShortContent() {
    List<String> content = [];
    if (area != null) {
      content.add(area!.name);
      if (subArea != null) {
        content.add(subArea!.name);
      }
    } else {
      content.add(city);
    }
    content.add(countryName);
    return content.join(' ');
  }

  String getContent({bool showCountry = true}) {
    String contentStr = '';
    if (showCountry) {
      contentStr += countryName;
    }
    if (area != null) {
      if (area != null) {
        contentStr += ' ${area!.name}';
      }
      if (subArea != null) {
        contentStr += ' ${subArea!.name}';
      }
      if (street.isNotEmpty) {
        contentStr += ' $street';
      }
    } else {
      contentStr += ' $doorNo $street $city';
    }
    if (addressType == 2) {
      contentStr += ' $address';
    }
    return contentStr;
  }
}
