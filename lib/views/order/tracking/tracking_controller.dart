import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/tracking_model.dart';
import 'package:huanting_shop/services/tracking_service.dart';

class BeeOrderTrackLogic extends GlobalLogic {
  final isLoading = false.obs;
  final dataList = <TrackingModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var orderSn = Get.arguments['order_sn'];
    getTrackingList(orderSn);
  }

  getTrackingList(String orderSn) async {
    var _dataList = await TrackingService.getList({'track_no': orderSn});
    isLoading.value = true;
    dataList.value = _dataList;
  }
}
