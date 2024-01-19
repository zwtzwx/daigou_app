import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/models/tracking_model.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/services/tracking_service.dart';

class BeeTrackingController extends GlobalLogic {
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
      BeeNav.push(BeeNav.login);
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
