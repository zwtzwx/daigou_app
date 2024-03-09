import 'package:shop_app_client/exceptions/http_exception.dart';

class NetworkException extends HttpException {
  NetworkException({String? message, int? code}) : super(message, code);
}
