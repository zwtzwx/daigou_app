import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/express_company_model.dart';

class ExpressCompanyService {
  // 获取支持的快递
  // ignore: constant_identifier_names
  static const String LISTAPI = 'express-company';

  // 获列表
  static Future<List<ExpressCompanyModel>> getList(
      [Map<String, dynamic>? params]) async {
    List<ExpressCompanyModel> result =
        List<ExpressCompanyModel>.empty(growable: true);
    await BeeRequest.instance
        .get(LISTAPI, queryParameters: params)
        .then((response) => {
              response.data?.forEach((good) {
                result.add(ExpressCompanyModel.fromJson(good));
              })
            });
    return result;
  }
}
