import 'package:shop_app_client/config/app_config.dart';
import 'package:shop_app_client/interceptors/auth_interceptor.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app_client/interceptors/response_interceptor.dart';
import '../config/http_config.dart';

class BaseDio with DioMixin implements Dio {
  BaseDio({BaseOptions? options, WebConfiguration? dioConfig}) {
    options ??= BaseOptions(
      // baseUrl: dioConfig?.baseUrl,
      contentType: 'application/json',
      connectTimeout: dioConfig?.connectTimeout,
      sendTimeout: dioConfig?.sendTimeout,
      receiveTimeout: dioConfig?.receiveTimeout,
    )..headers = dioConfig?.headers;
    options.baseUrl = BaseUrls.getBaseApi(); //基础API
    this.options = options;

    // DioCacheManager
    final cacheOptions = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
    );
    interceptors.add(DioCacheInterceptor(options: cacheOptions));
    //权限验证中间件，加入TOKEN
    interceptors.add(BaseInterceptor());

    // Cookie管理
    if (dioConfig?.cookiesPath?.isNotEmpty ?? false) {
      interceptors.add(CookieManager(
          PersistCookieJar(storage: FileStorage(dioConfig!.cookiesPath))));
    }

    // 如果调试环境打印日志
    if (kDebugMode) {
      interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: true));
    }

    interceptors.add(ResponseInterceptor());

    if (dioConfig?.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(dioConfig!.interceptors!);
    }

    //httpClientAdapter = DefaultHttpClientAdapter();
    httpClientAdapter = Http2Adapter(ConnectionManager(
      idleTimeout: 10000,
      onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    ));

    if (dioConfig?.proxy?.isNotEmpty ?? false) {
      setProxy(dioConfig!.proxy!);
    }
  }

  setProxy(String proxy) {
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // config the http client
      client.findProxy = (uri) {
        // proxy all request to localhost:8888
        return "PROXY $proxy";
      };
      return null;
      // you can also create a ApiConfig to dio
      // return ApiConfig();
    };
  }
}
