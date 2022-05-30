import 'package:dio/dio.dart';
import 'package:jiyun_app_client/common/http_response.dart';
import 'http_transformer.dart';

class DefaultHttpTransformer extends HttpTransformer {
  @override
  HttpResponse parse(Response response) {
    if (response.data["ret"] == 1) {
      return HttpResponse.success(
          response.data["data"], response.data["msg"], response.data['meta']);
    }
    return HttpResponse.failure(
        errorMsg: response.data["msg"], errorCode: response.data["ret"]);
  }

  /// 单例对象
  static final DefaultHttpTransformer _instance =
      DefaultHttpTransformer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DefaultHttpTransformer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DefaultHttpTransformer.getInstance() => _instance;
}
