import 'package:huanting_shop/exceptions/http_exception.dart';

class BadResponseException extends HttpException {
  dynamic data;

  BadResponseException([this.data]) : super();
}
