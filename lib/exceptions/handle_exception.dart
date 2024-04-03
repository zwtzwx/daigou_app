// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'net_error_exception.dart';

class HandleException {
  static const int success = 200;
  static const int success_not_content = 204;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;
  static const int server_error = 500;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int timeout_error = 1004;
  static const int cancel_error = 1005;
  static const int unknown_error = 9999;

  static NetErrorException handleException(dynamic error) {
    EasyLoading.dismiss();
    if (error is DioError) {
      if (error.type == DioExceptionType.unknown ||
          error.type == DioExceptionType.badResponse) {
        dynamic e = error.error;
        if (e is SocketException) {
          return NetErrorException(socket_error, "网络异常，请检查你的网络");
        }
        if (e is HttpException) {
          return NetErrorException(http_error, "服务器异常");
        }
        return NetErrorException(net_error, "网络异常，请检查你的网络");
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return NetErrorException(timeout_error, "连接超时");
      } else if (error.type == DioExceptionType.cancel) {
        return NetErrorException(cancel_error, "取消请求");
      } else {
        return NetErrorException(unknown_error, "未知异常");
      }
    } else {
      return NetErrorException(unknown_error, "未知异常");
    }
  }
}
