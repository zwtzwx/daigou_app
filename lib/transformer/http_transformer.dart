import 'package:dio/dio.dart';
import 'package:shop_app_client/common/http_response.dart';

/// Response 解析
abstract class HttpTransformer {
  HttpResponse parse(Response response);
}
