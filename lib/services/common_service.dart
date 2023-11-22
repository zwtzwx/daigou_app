// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/app_version_model.dart';
import 'package:jiyun_app_client/models/banners_model.dart';
import 'package:dio/dio.dart';
import 'package:jiyun_app_client/models/captcha_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/currency_rate_model.dart';
import 'package:jiyun_app_client/models/notice_model.dart';
import 'package:jiyun_app_client/models/shop/platform_goods_model.dart';
import 'package:jiyun_app_client/services/shop_service.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';

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
  // 汇率
  static const String exchangeRateApi = 'exchange/rates';

  static const String goodsUrlApi = 'purchase/password/item';

  // chorme 登录
  static const String chromeLoginApi = 'user/scan-chrome-code';
  // 最新版本 apk信息
  static const String latestApkApi = 'apk';

  static const String goodsQueryByImgApi = 'alibaba/product/image/query';

  // 获取预报的同意条款
  static Future<Map<String, dynamic>?> getTerms(
      [Map<String, dynamic>? params]) async {
    Map<String, dynamic>? result;

    await BeeRequest.instance
        .get(_TERMS_API, queryParameters: params)
        .then((response) => {result = response.data});
    return result;
  }

  // 获取后台配置的图片列表
  static Future<BannersModel?> getAllBannersInfo(
      [Map<String, dynamic>? params]) async {
    BannersModel? result;
    await BeeRequest.instance
        .get(_ALL_BANNERS_API, queryParameters: params)
        .then((response) => {result = BannersModel.fromJson(response.data)});
    return result;
  }

  /*
    上传图片
   */
  static Future<String> uploadImage(
    File image, {
    Options? options,
  }) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(path, filename: name + "." + suffix)
    });

    String result = "";

    await BeeRequest.instance
        .post(
      uploadImageApi,
      data: formData,
      options: options,
    )
        .then((response) {
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
    await BeeRequest.instance
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
    await BeeRequest.instance
        .get(countriesApi, queryParameters: params)
        .then((res) {
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
    await BeeRequest.instance.put(deviceTokenApi, data: params);
  }

  // 刷新 token
  static Future<String?> refreshToken() async {
    String? token;
    await BeeRequest.instance.post(refreshTokenApi).then((res) {
      if (res.ok) {
        token = '${res.data['token_type']} ${res.data['access_token']}';
      }
    });
    return token;
  }

  // 获取图形验证码
  static Future<CaptchaModel?> getCaptcha() async {
    CaptchaModel? captcha;
    await BeeRequest.instance.get(captchaApi).then((res) {
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
    await BeeRequest.instance
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
    await BeeRequest.instance
        .put(noticeReadApi,
            data: params, options: Options(extra: {'showSuccess': false}))
        .then((response) {
      res = response.ok;
    });
    return res;
  }

  // 是否有未读消息
  static Future<bool> hasUnReadInfo() async {
    bool res = false;
    await BeeRequest.instance.get(unReadNoticeApi).then((response) {
      if (response.ok) {
        res = response.data['no_read_count'] > 0;
      }
    });
    return res;
  }

  /*
    汇率列表
   */
  static Future<List<CurrencyRateModel>> getRateList() async {
    List<CurrencyRateModel> datas = [];
    await BeeRequest().get(exchangeRateApi).then((res) {
      if (res.ok) {
        res.data.forEach((item) => datas.add(CurrencyRateModel.from(item)));
      }
    });
    return datas;
  }

  // 获取商品链接
  static Future<String?> getGoodsUrl(Map<String, dynamic> params) async {
    String? url;
    await BeeRequest()
        .get(goodsUrlApi,
            queryParameters: params, options: Options(extra: {'loading': true}))
        .then((res) {
      if (res.ok) {
        url = res.data['item']['url'] + '&id=' + res.data['item']['num_iid'];
      }
    });
    return url;
  }

  // chorme 插件登录
  static Future<bool> onChromeLogin(Map<String, dynamic> params) async {
    bool result = false;
    await BeeRequest()
        .post(chromeLoginApi, data: params)
        .then((res) => result = res.ok);
    return result;
  }

  // 获取最新版本 apk 信息
  static Future<AppVersionModel?> getLatestApkInfo() async {
    AppVersionModel? result;
    await BeeRequest().get(latestApkApi).then((res) {
      if (res.ok && res.data != null) {
        result = AppVersionModel.fromJson(res.data);
      }
    });
    return result;
  }

  // 扫图识别商品
  static Future<Map> goodsQueryByImg(Map<String, dynamic> params) async {
    Map result = {
      "dataList": null,
      'total': (params['page'] ?? 1) + 1,
      'pageIndex': params['page'] ?? 1
    };
    await BeeRequest()
        .post(goodsQueryByImgApi,
            data: params,
            options: Options(extra: {
              'loading': false,
              'showSuccess': false,
            }))
        .then((res) {
      if (res.data['items'] != null) {
        List<PlatformGoodsModel> list = [];
        for (var item in res.data['items']['item']) {
          item['platform'] =
              res.data['api_type'] ?? res.data['items']['api_type'];
          list.add(PlatformGoodsModel.fromJson(item));
        }
        result['dataList'] = list;
        if (list.isEmpty) {
          result['total'] = result['pageIndex'];
        }
      }
    });
    if (result['dataList'] != null &&
        result['dataList'].isNotEmpty &&
        LanguageStore.getLanguage() != 'zh_CN') {
      await Future.wait((result['dataList'] as List<PlatformGoodsModel>)
          .where((e) => e.title.contianCN)
          .map((PlatformGoodsModel e) {
        return ShopService.getTranslate(e.title)
            .then((data) => e.title = data ?? e.title);
      }));
    }
    return result;
  }
}
