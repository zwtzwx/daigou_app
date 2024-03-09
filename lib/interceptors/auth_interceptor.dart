import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/common/http_client.dart';
import 'package:shop_app_client/config/app_config.dart';
import 'package:shop_app_client/storage/language_storage.dart';
import 'package:shop_app_client/storage/user_storage.dart';

class BaseInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if ((options.extra['loading'] != false &&
            !options.uri.path.contains('refresh-token') &&
            options.method != Methods.get.name) ||
        options.extra['loading'] == true) {
      EasyLoading.show();
    }
    var accessToken = CommonStorage.getToken();
    if (accessToken.isNotEmpty) {
      options.headers["authorization"] = accessToken;
    }
    options.headers['x-uuid'] = BaseUrls.getUUID();
    String language = LocaleStorage.getLanguage();
    options.headers['language'] = language;
    options.headers["accept-language"] = 'zh-CN';
    options.headers["x-requested-with"] = 'XMLHttpRequest';
    options.headers["source"] = Platform.isAndroid ? "android" : "ios";

    return handler.next(options);
  }
}
