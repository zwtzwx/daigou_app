import 'package:jiyun_app_client/exceptions/http_exception.dart';

/// 服务端响应错误
class BadServiceException extends HttpException {
  BadServiceException({String? message, int? code}) : super(message, code);
}
