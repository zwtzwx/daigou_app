/*
  发票服务
 */
import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/invoice_model.dart';

class InvoiceService {
  // 列表
  static const String listApi = 'invoice';
  // 列表
  static const String oneApi = 'invoice/:id';

  /*
    得到默认的发票地址
   */
  static Future<InvoiceModel?> getDefault() async {
    InvoiceModel? result;
    await BeeRequest.instance
        .get(listApi, queryParameters: null)
        .then((response) => {result = InvoiceModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});
    return result;
  }

  /*
    得到指定的发票地址
   */
  static Future<InvoiceModel?> getDetail(int id) async {
    InvoiceModel? result;
    await BeeRequest.instance
        .get(oneApi.replaceAll(":id", id.toString()), queryParameters: null)
        .then((response) => {InvoiceModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});
    return result;
  }

  /*
    针对订单保存发票信息
   */
  static Future<bool> update(int id, Map<String, dynamic>? params) async {
    bool result = false;

    await BeeRequest.instance
        .post(oneApi.replaceAll(':id', id.toString()), data: params)
        // ignore: unrelated_type_equality_checks
        .then((response) => {result = response.ret});

    return result;
  }
}
