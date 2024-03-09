import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/list_refresh_event.dart';
import 'package:shop_app_client/models/parcel_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';

class BeeOrderIndexLogic extends GlobalController
    with GetSingleTickerProviderStateMixin {
  late final PageController pageController;
  late final TabController tabController;
  final tabIndex = 0.obs;
  final orderCount = Get.find<AppStore>().amountInfo;
  final checkedIds = <int>[].obs;
  final allParcels = <ParcelModel>[];
  String keyword = '';

  @override
  onInit() {
    super.onInit();
    var arguments = Get.arguments;
    pageController = PageController(initialPage: arguments ?? 0);
    tabController =
        TabController(length: 7, vsync: this, initialIndex: arguments ?? 0);
    tabIndex.value = arguments ?? 0;
  }

  String getCountStr(int index) {
    if (orderCount.value == null) return '    ';
    String count = '';
    switch (index) {
      case 0:
        count = (orderCount.value?.waitStorage ?? 0) != 0
            ? '(${orderCount.value?.waitStorage})'
            : '';
        break;
      case 1:
        count = (orderCount.value?.alreadyStorage ?? 0) != 0
            ? '(${orderCount.value?.alreadyStorage})'
            : '';
        break;
      case 2:
        count = (orderCount.value?.waitPack ?? 0) != 0
            ? '(${orderCount.value?.waitPack})'
            : '';

        break;
      case 3:
        count = (orderCount.value?.waitPay ?? 0) != 0
            ? '(${orderCount.value?.waitPay})'
            : '';
        break;
      case 4:
        count = (orderCount.value?.waitTran ?? 0) != 0
            ? '(${orderCount.value?.waitTran})'
            : '';
        break;
      case 5:
        count = (orderCount.value?.shipping ?? 0) != 0
            ? '(${orderCount.value?.shipping})'
            : '';
        break;
      case 6:
        count = '';
        break;
    }
    return count;
  }

  onAllChecked() {
    if (checkedIds.length == allParcels.length && checkedIds.isNotEmpty) {
      checkedIds.clear();
    } else {
      checkedIds.value = allParcels.map((e) => e.id!).toList();
    }
  }

  onSubmit() async {
    if (checkedIds.isEmpty) {
      return showToast('请选择包裹');
    }
    List<ParcelModel> checkedList =
        allParcels.where((e) => checkedIds.contains(e.id!)).toList();
    var s = await GlobalPages.push(GlobalPages.createOrder, arg: {
      'modelList': checkedList,
    });
    if (s == 'succeed') {
      allParcels.clear();
      checkedIds.clear();
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  onChecked(id) {
    if (checkedIds.contains(id)) {
      checkedIds.remove(id);
    } else {
      checkedIds.add(id);
    }
  }
}
