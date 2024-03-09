import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app_client/common/http_client.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if ((response.requestOptions.extra['loading'] != false &&
            response.requestOptions.method != Methods.get.name) ||
        response.requestOptions.extra['loading'] == true) {
      EasyLoading.dismiss();
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if ((err.requestOptions.extra['loading'] != false &&
            err.requestOptions.method != Methods.get.name) ||
        err.requestOptions.extra['loading'] == true) {
      EasyLoading.dismiss();
    }
    handler.reject(err);
  }
}
