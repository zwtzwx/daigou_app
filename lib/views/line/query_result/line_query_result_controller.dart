import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';

class LineQueryResultController extends BaseController {
  final lineData = RxList<ShipLineModel>();
  final postDic = Rxn<Map<String, dynamic>?>();
  final isEmpty = false.obs;
  final emptyMsg = ''.obs;
  final volumnWeight = Rxn<String?>();
  final fromQuery = false.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    postDic.value = arguments?['data'];
    if (arguments?['query'] != null) {
      fromQuery.value = true;
      double length = arguments?['data']['length'].isNotEmpty
          ? double.parse(arguments?['data']['length'])
          : 0;
      double width = arguments?['data']['width'].isNotEmpty
          ? double.parse(arguments?['data']['width'])
          : 0;
      double height = arguments?['data']['height'].isNotEmpty
          ? double.parse(arguments?['data']['height'])
          : 0;
      volumnWeight.value =
          ((length * width * height) / 6000).toStringAsFixed(2);
    }
    getLines();
  }

  getLines() async {
    Map result = await ShipLineService.getList({
      'country_id': postDic.value?['country_id'] ?? '',
      'area_id': postDic.value?['area_id'],
      'sub_area_id': postDic.value?['sub_area_id'],
      'length': postDic.value?['length'] ?? '',
      'width': postDic.value?['width'] ?? '',
      'height': postDic.value?['height'] ?? '',
      'weight': postDic.value?['weight'] ?? '',
      'warehouse_id': postDic.value?['warehouse_id'] ?? '',
      'prop_ids': (postDic.value?['props'] ?? []).map((e) => e.id).toList(),
    });
    lineData.value = result['list'];
    if (!result['ok']) {
      isEmpty.value = true;
      emptyMsg.value = result['msg'];
    }
  }
}
