import 'package:jiyun_app_client/exceptions/http_exception.dart';

class BadResponseException extends HttpException {
  dynamic data;

  BadResponseException([this.data]) : super();
}
