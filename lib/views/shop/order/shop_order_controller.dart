import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';

class ShopOrderController extends GlobalLogic with GetTickerProviderStateMixin {
  final PageController pageController = PageController(initialPage: 0);
  late final TabController tabController;
  late final TabController problemTabController;
  final tabIndex = 0.obs;
  final problemTabIndex = 0.obs;
  final orderType = 1.obs; // 1--->购物订单 2--->异常订单

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 7, vsync: this);
    problemTabController = TabController(length: 3, vsync: this);
  }
}
