import 'dart:convert';

import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseStorage {
  static const String _cacheKey = "warehouseListCacheKey";

  static String _encode(List<WareHouseModel> warehouses) => json.encode(
        warehouses.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
      );

  static List<WareHouseModel> _decode(String value) {
    List<dynamic> list = json.decode(value);

    List<WareHouseModel> warehouses =
        List<WareHouseModel>.empty(growable: true);
    for (var element in list) {
      warehouses.add(WareHouseModel.fromJson(element));
    }

    return warehouses;
  }

  static set(List<WareHouseModel> items) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(_cacheKey, _encode(items));
  }

  static Future<List<WareHouseModel>> get() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return _decode(sp.getString(_cacheKey)!);
  }
}
