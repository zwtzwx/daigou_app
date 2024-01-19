import 'package:huanting_shop/exceptions/http_exception.dart';

class NetworkException extends HttpException {
  NetworkException({String? message, int? code}) : super(message, code);
}
