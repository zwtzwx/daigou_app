import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';

class BeeSupportLogic extends GlobalController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    tabController = TabController(
        length: 4, vsync: this, initialIndex: arguments?['index'] ?? 0);
    pageController = PageController(initialPage: arguments?['index'] ?? 0);
  }
}
