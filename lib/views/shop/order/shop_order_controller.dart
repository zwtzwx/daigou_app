import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/services/shop_service.dart';

class ShopOrderController extends GlobalController
    with GetTickerProviderStateMixin {
  final PageController pageController = PageController(initialPage: 0);
  late final TabController tabController;
  final tabIndex = 0.obs;
  final problemTabIndex = 0.obs;
  String keyword = '';
  final  hasProblem = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 7, vsync: this);
    print('获取问题订单');
    getProblemCount();
  }

  // 问题订单数量
  void getProblemCount() async{
    Map<String, dynamic> params={'page': 1, 'size': 10};
    for (var i = 0; i < 2; i++) {
      params['tackle[$i]'] = i;
    }
    var data = await ShopService.getProbleOrderList(params);
    if(data['dataList'].length>0) {
        hasProblem.value = true;
    }
  }

}
