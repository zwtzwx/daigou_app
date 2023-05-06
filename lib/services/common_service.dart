// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:dio/dio.dart';
import 'package:jiyun_app_client/models/captcha_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/notice_model.dart';

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
  // 刷新 token
  static const String refreshTokenApi = 'user/refresh-token';
  // 获取图形验证码
  static const String captchaApi = 'captcha';
  // 消息列表
  static const String noticeListApi = 'notification-records';
  // 消息已读
  static const String noticeReadApi = 'notification-records/read';
  // 未读消息数量
  static const String unReadNoticeApi = 'notification-records/no-read-count';

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

  // 刷新 token
  static Future<String?> refreshToken() async {
    String? token;
    await HttpClient().post(refreshTokenApi).then((res) {
      if (res.ok) {
        token = '${res.data['token_type']} ${res.data['access_token']}';
      }
    });
    return token;
  }

  // 获取图形验证码
  static Future<CaptchaModel?> getCaptcha() async {
    CaptchaModel? captcha;
    await HttpClient().get(captchaApi).then((res) {
      if (res.ok) {
        captcha = CaptchaModel.formJson(res.data['captcha']);
      }
    });
    return captcha;
  }

  // 消息列表
  static Future<Map> getNoticeList(Map<String, dynamic> params) async {
    Map result = {"dataList": null, 'total': 1, 'pageIndex': params['page']};
    List<NoticeModel> dataList = [];
    await HttpClient()
        .get(noticeListApi, queryParameters: params)
        .then((response) {
      if (response.ret) {
        var list = response.data;
        list.forEach((item) {
          dataList.add(NoticeModel.fromJson(item));
        });
        result = {
          "dataList": dataList,
          'total': response.meta!['last_page'],
          'pageIndex': response.meta!['current_page']
        };
      }
    });
    return result;
  }

  // 消息设为已读
  static Future<bool> onNoticeRead(Map<String, dynamic> params) async {
    bool res = false;
    await HttpClient().put(noticeReadApi, data: params).then((response) {
      res = response.ok;
    });
    return res;
  }

  // 是否有未读消息
  static Future<bool> hasUnReadInfo() async {
    bool res = false;
    await HttpClient().get(unReadNoticeApi).then((response) {
      if (response.ok) {
        res = response.data['no_read_count'] > 0;
      }
    });
    return res;
  }
}
