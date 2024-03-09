import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/agent_data_count_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/agent_service.dart';

class AgentCenterController extends GlobalController {
  final ScrollController scrollerController = ScrollController();
  final countModel = Rxn<AgentDataCountModel?>();
  final userInfo = Get.find<AppStore>().userInfo;
  final loading = false.obs;
  final withdrawalAmount = 0.obs;
  final withdrawedAmount = 0.obs;
  final headerBgShow = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSubCount();
    getWithdrawedAmount();
    scrollerController.addListener(() {
      headerBgShow.value = scrollerController.position.pixels > 10.h;
    });
  }

  getSubCount() async {
    var data = await AgentService.getDataCount();
    countModel.value = data;
  }

  getWithdrawedAmount() async {
    var data = await AgentService.getAgentCommissionInfo();
    if (data != null) {
      withdrawalAmount.value = data['withdrawal'];
      withdrawedAmount.value = data['withdrawed'];
    }
  }
}
