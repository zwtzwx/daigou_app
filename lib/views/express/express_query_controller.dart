import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/tracking_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/tracking_service.dart';

class BeeTrackingController extends GlobalController {
  final TextEditingController expressNumController = TextEditingController();
  final FocusNode expressNumNode = FocusNode();
  // 物流信息列表
  RxBool isSearch = false.obs;
  RxList<TrackingModel> trackingList = <TrackingModel>[].obs;

  // 物流查询
  onQuery() async {
    String token = Get.find<AppStore>().token.value;
    if (expressNumController.text.isEmpty) {
      showToast('请输入快递单号');
      return;
    } else if (token.isEmpty) {
      GlobalPages.push(GlobalPages.login);
      return;
    }
    showLoading();
    var data = await TrackingService.getList({
      'track_no': expressNumController.text,
    });
    hideLoading();
    trackingList.value = data;
    isSearch.value = true;
  }

  @override
  void onClose() {
    expressNumNode.dispose();
    super.onClose();
  }
}
