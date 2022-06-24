import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jiyun_app_client/config/app_config.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var accessToken = await UserStorage.getToken();
    if (accessToken.isNotEmpty) {
      options.headers["authorization"] = accessToken;
    }
    options.headers['x-uuid'] = AppConfig.getUUID();
    String language = await LanguageStore.getLanguage();
    options.headers['language'] = language;
    options.headers["accept-language"] = 'zh-CN';
    options.headers["x-requested-with"] = 'XMLHttpRequest';
    options.headers["source"] = Platform.isAndroid ? "android" : "ios";

    return handler.next(options);
    // return super.onRequest(options, handler);
  }
}
