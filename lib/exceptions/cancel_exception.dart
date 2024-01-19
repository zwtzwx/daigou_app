import 'package:huanting_shop/exceptions/http_exception.dart';

class CancelException extends HttpException {
  CancelException([String? message]) : super(message);
}
