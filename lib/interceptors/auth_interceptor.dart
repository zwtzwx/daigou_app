import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jiyun_app_client/config/app_config.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var accessToken = await UserStorage.getToken();
    if (accessToken.isNotEmpty) {
      options.headers["authorization"] = accessToken;
    }
    await AppConfig.getUUID().then((res) {
      // options.headers['X-Uuid'] = '9c9d98a8-752a-4ccb-8d8b-6087d6ad62a0';
      options.headers['x-uuid'] = res;
    });
    options.headers["accept-language"] = 'zh-CN';
    options.headers["x-requested-with"] = 'XMLHttpRequest';
    options.headers["source"] = Platform.isAndroid ? "android" : "ios";

    return handler.next(options);
    // return super.onRequest(options, handler);
  }
}
