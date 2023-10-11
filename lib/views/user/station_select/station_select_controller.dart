import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/services/station_service.dart';

class StationSelectController extends GlobalLogic {
  final stationList = RxList();

  @override
  void onInit() {
    super.onInit();
    getStationList();
  }

  // 自提点列表
  void getStationList() async {
    showLoading();
    var arguments = Get.arguments;
    var data = await StationService.getList({
      'size': 999,
      'warehouse_id': arguments?['warehouse'] ?? '',
      'country_id': arguments?['country_id'] ?? ''
    });
    hideLoading();
    if (data['dataList'] != null) {
      stationList.value = data['dataList'];
    }
  }
}
