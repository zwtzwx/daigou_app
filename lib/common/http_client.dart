import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/app_dio.dart';
import 'package:jiyun_app_client/common/http_response.dart';
import 'package:jiyun_app_client/transformer/http_parse.dart';
import 'package:jiyun_app_client/transformer/http_transformer.dart';

enum Methods { get, post, put, delete }

extension MethodStr on Methods {
  String get name {
    switch (this) {
      case Methods.get:
        return 'GET';
      case Methods.post:
        return 'POST';
      case Methods.put:
        return 'PUT';
      case Methods.delete:
        return 'DELETE';
    }
  }
}

class HttpClient {
  late final AppDio _dio;

  static late final HttpClient instance = HttpClient();

  factory HttpClient() {
    return HttpClient._internal();
  }

  HttpClient._internal() {
    _dio = AppDio();
  }

  Future<HttpResponse> _request(
    String uri, {
    Methods? method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpTransformer? httpTransformer,
  }) async {
    options ??= Options();
    options.method = (method ?? Methods.get).name;
    try {
      var response = await _dio.request(
        uri,
        options: options,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      var res = handleResponse(response, httpTransformer: httpTransformer);
      if (res.ok &&
          options.method != Methods.get.name &&
          !uri.contains('refresh-token') &&
          options.extra?['showSuccess'] != false) {
        EasyLoading.showSuccess(res.msg ?? '');
      }
      if (!res.ok && options.method != Methods.get.name) {
        EasyLoading.showError(res.msg ?? res.error?.message ?? '');
      }
      return res;
    } on Exception catch (e) {
      handleException(e);
      rethrow;
    }
  }

  Future<HttpResponse> get(String uri,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    return await _request(
      uri,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      httpTransformer: httpTransformer,
    );
  }

  Future<HttpResponse> post(String uri,
      {data,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    return await _request(
      uri,
      method: Methods.post,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      httpTransformer: httpTransformer,
    );
  }

  Future<HttpResponse> delete(String uri,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    return await _request(
      uri,
      method: Methods.delete,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      httpTransformer: httpTransformer,
    );
  }

  Future<HttpResponse> put(String uri,
      {data,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    return await _request(
      uri,
      method: Methods.put,
      data: data,
      options: options,
      cancelToken: cancelToken,
      httpTransformer: httpTransformer,
    );
  }

  Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      Options? options,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
