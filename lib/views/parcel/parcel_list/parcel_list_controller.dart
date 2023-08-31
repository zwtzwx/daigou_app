import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';

class ParcelListController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final isLoading = false.obs;
  List<WareHouseModel> warehouseList = [];
  TabController? tabController;
  final PageController pageController = PageController();
  final pageIndex = 0.obs;
  int currentWarehouse = 0;
  final type = 1.obs;
  final checkedIds = <int>[].obs;
  final allIds = [];

  @override
  void onReady() {
    super.onReady();
    type.value = Get.arguments;
    getWarehouse();
  }

  /*
    拉取仓库
   */
  void getWarehouse() async {
    //拉取仓库
    showLoading();
    var _warehouseList = await WarehouseService.getList();
    hideLoading();
    warehouseList = _warehouseList;
    tabController = TabController(length: _warehouseList.length, vsync: this);
    isLoading.value = true;
  }

  onPageChange(int index) {
    currentWarehouse = warehouseList[index].id!;
    checkedIds.clear();
    allIds.clear();
    tabController?.animateTo(index);
  }

  loadList({type}) async {
    pageIndex.value = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await ParcelService.getList({
      'status': type, // 未入库包裹
      'warehouse_id': currentWarehouse,
      'page': (++pageIndex.value),
    });
    if (data['dataList'] is List) {
      allIds.addAll(data['dataList'].map((e) => e.id).toList());
    }
    return data;
  }

  // 删除包裹
  onDeleteParcel(int id, int index) async {
    showLoading();
    var res = await ParcelService.delete(id);
    hideLoading();
    if (res) {
      showToast('删除包裹成功');
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'delete', index: index));
      ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent());
    } else {
      showToast('删除包裹失败');
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
