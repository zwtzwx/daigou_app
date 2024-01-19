import 'package:huanting_shop/exceptions/http_exception.dart';

class UnknownException extends HttpException {
  UnknownException([String? message]) : super(message);
}
