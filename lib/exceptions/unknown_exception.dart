import 'package:jiyun_app_client/exceptions/http_exception.dart';

class UnknownException extends HttpException {
  UnknownException([String? message]) : super(message);
}
