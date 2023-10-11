import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/agent_data_count_model.dart';
import 'package:jiyun_app_client/services/agent_service.dart';

class AgentMemberController extends GlobalLogic
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final PageController pageController = PageController();

  final countModel = Rxn<AgentDataCountModel?>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    getSubCount();
  }

  getSubCount() async {
    var data = await AgentService.getDataCount();
    countModel.value = data;
  }

  void onPageChange(int index) {
    tabController.animateTo(index);
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
