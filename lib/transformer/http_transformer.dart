import 'package:dio/dio.dart';
import 'package:huanting_shop/common/http_response.dart';

/// Response 解析
abstract class HttpTransformer {
  HttpResponse parse(Response response);
}
