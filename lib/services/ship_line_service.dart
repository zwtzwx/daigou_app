// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:huanting_shop/common/http_client.dart';
import 'package:huanting_shop/models/insurance_model.dart';
import 'package:huanting_shop/models/ship_line_model.dart';
import 'package:huanting_shop/models/tariff_model.dart';
import 'package:huanting_shop/models/value_added_service_model.dart';

/*
  渠道
 */

class ShipLineService {
  // 列表
  static const String LISTAPI = 'express/price-query';
  // 详情
  static const String DETAILAPI = 'express/price-query/:id';
  // 保险配置
  static const String hasInsuranceApi = 'order/has_insurance';
  // 关税配置
  static const String tariffConfigApi = 'order/tariff-config';

  // 动态获取订单的增值服务
  static const String addValueServiceApi = 'addvalue';

  // 获列表
  static Future<Map> getList(
      {Map<String, dynamic>? params, Options? option}) async {
    List<ShipLineModel> list = [];
    Map result = {'ok': false, 'msg': '', 'list': list};
    await BeeRequest.instance
        .post(LISTAPI, data: params, options: option)
        .then((response) {
      response.data?.forEach((item) {
        list.add(ShipLineModel.fromJson(item));
      });
      result = {
        'ok': response.ok,
        'list': list,
        'msg': response.msg ?? response.error!.message,
      };
    }).onError((error, stackTrace) => null);
    return result;
  }

  // 渠道详情
  static Future<ShipLineModel?> getDetail(int id) async {
    ShipLineModel? result;
    await BeeRequest.instance
        .get(DETAILAPI.replaceAll(':id', id.toString()))
        .then((res) => {result = ShipLineModel.fromJson(res.data)});
    return result;
  }

  /*
    保险
   */
  static Future<InsuranceModel?> getInsurance() async {
    InsuranceModel? result;
    await BeeRequest.instance
        .get(hasInsuranceApi)
        .then((response) => {result = InsuranceModel.fromJson(response.data)});

    return result;
  }

  /*
    得到关税
   */
  static Future<TariffModel?> getTariff() async {
    TariffModel? result;

    await BeeRequest.instance
        .get(tariffConfigApi)
        .then((res) => {result = TariffModel.fromJson(res.data)});

    return result;
  }

  /*
    获取增值服务
   */
  static Future<List<ValueAddedServiceModel>> getValueAddedServiceList(
      [Map<String, dynamic>? params]) async {
    List<ValueAddedServiceModel> result = [];
    await BeeRequest.instance
        .get(addValueServiceApi, queryParameters: params)
        .then((response) => {
              response.data.forEach((item) {
                result.add(ValueAddedServiceModel.fromJson(item));
              })
            });

    return result;
  }
}
