import 'package:huanting_shop/exceptions/bad_request_exception.dart';
import 'package:huanting_shop/exceptions/bad_response_exception.dart';
import 'package:huanting_shop/exceptions/http_exception.dart';
import 'package:huanting_shop/exceptions/unknown_exception.dart';

class HttpResponse {
  late bool ok;
  dynamic data;
  Map? meta;
  late String? msg;
  HttpException? error;
  bool get ret => ok;

  // HttpResponse._internal({ok = false});

  HttpResponse.success(this.data, this.msg, this.meta) {
    ok = true;
  }

  HttpResponse.failure({String? errorMsg, int? errorCode}) {
    error = BadRequestException(message: errorMsg, code: errorCode);
    ok = false;
    msg = errorMsg;
  }

  HttpResponse.failureFormResponse({dynamic data}) {
    error = BadResponseException(data);
    ok = false;
  }

  HttpResponse.failureFromError([HttpException? error]) {
    error = error ?? UnknownException();
    ok = false;
  }
}
