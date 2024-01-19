import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/config/app_config.dart';
import 'package:huanting_shop/storage/language_storage.dart';
import 'package:huanting_shop/storage/user_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if ((options.extra['loading'] != false &&
            !options.uri.path.contains('refresh-token') &&
            options.method != Methods.get.name) ||
        options.extra['loading'] == true) {
      EasyLoading.show();
    }
    var accessToken = UserStorage.getToken();
    if (accessToken.isNotEmpty) {
      options.headers["authorization"] = accessToken;
    }
    options.headers['x-uuid'] = AppConfig.getUUID();
    String language = LanguageStore.getLanguage();
    options.headers['language'] = language;
    options.headers["accept-language"] = 'zh-CN';
    options.headers["x-requested-with"] = 'XMLHttpRequest';
    options.headers["source"] = Platform.isAndroid ? "android" : "ios";

    return handler.next(options);
  }
}
