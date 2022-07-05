// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:dio/dio.dart';
import 'package:jiyun_app_client/models/country_model.dart';

//通用服务
class CommonService {
  // 获取协议规则
  static const String _TERMS_API = 'packages/transhipment-rule';
  // 所有配置图片列表
  static const String _ALL_BANNERS_API = 'mini-setting';
  // 获取国家，排序
  static const String countryListApi = 'country/sorted';
  // 国家列表
  static const String countriesApi = 'country';
  // 上传图片
  static const String uploadImageApi = 'uploads/image';
  // 保存 device token
  static const String deviceTokenApi = 'user/push-tokens';

  // 获取预报的同意条款
  static Future<Map<String, dynamic>?> getTerms(
      [Map<String, dynamic>? params]) async {
    Map<String, dynamic>? result;

    await HttpClient()
        .get(_TERMS_API, queryParameters: params)
        .then((response) => {result = response.data});
    return result;
  }

  // 获取后台配置的图片列表
  static Future<BannersModel?> getAllBannersInfo(
      [Map<String, dynamic>? params]) async {
    BannersModel? result;
    await HttpClient()
        .get(_ALL_BANNERS_API, queryParameters: params)
        .then((response) => {result = BannersModel.fromJson(response.data)});
    return result;
  }

  /*
    上传图片
   */
  static Future<String> uploadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(path, filename: name + "." + suffix)
    });

    String result = "";

    await HttpClient().post(uploadImageApi, data: formData).then((response) {
      result = response.data;
    });
    return result;
  }

  /*
    获取国家表
    按字母排序
   */
  static Future<List<AlphabeticalCountryModel>> getCountryListByAlphabetical(
      [Map<String, dynamic>? params]) async {
    List<AlphabeticalCountryModel> dataList = <AlphabeticalCountryModel>[];
    await HttpClient()
        .get(countryListApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      //加个判断防止非MAP，闪退
      if (list is Map) {
        for (String key in list.keys) {
          dataList.add(AlphabeticalCountryModel.fromJson(
              {"key": key, "items": list[key]}));
        }
      }
    });

    return dataList;
  }

  /*
    获取国家列表
  */
  static Future<List<CountryModel>> getCountryList(
      [Map<String, dynamic>? params]) async {
    List<CountryModel> dataList = [];
    await HttpClient().get(countriesApi, queryParameters: params).then((res) {
      if (res.ok) {
        for (var item in res.data) {
          dataList.add(CountryModel.fromJson(item));
        }
      }
    });
    return dataList;
  }

  /*
    保存 device token
    用于消息推送
   */
  static Future<void> saveDeviceToken(Map<String, dynamic> params) async {
    await HttpClient().put(deviceTokenApi, data: params);
  }
}
