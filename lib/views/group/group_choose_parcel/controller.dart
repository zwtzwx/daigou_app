import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/parcel_model.dart';
import 'package:shop_app_client/services/group_service.dart';
import 'package:shop_app_client/services/parcel_service.dart';

class BeeGroupParcelSelectController extends GlobalController {
  int pageIndex = 0;
  final selectedParcelList = <int>[].obs;
  List<ParcelModel> allParcelList = [];
  final selectAll = false.obs;
  final selectedWeight = RxNum(0);
  int? warehouseId;

  @override
  onInit() {
    super.onInit();
    warehouseId = Get.arguments['warehouseId'];
  }

  loadList({type}) async {
    pageIndex = 0;
    allParcelList.clear();
    selectAll.value = false;
    selectedWeight.value = 0;
    selectedParcelList.clear();
    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await ParcelService.getList({
      'status': 2, // 已入库包裹
      'warehouse_id': warehouseId,
      'page': (++pageIndex),
    });
    allParcelList.addAll(data['dataList']);
    return data;
  }

  // 选择单个包裹
  void onChecked(int id) {
    var weight = allParcelList.firstWhere((e) => e.id == id).packageWeight;

    if (selectedParcelList.contains(id)) {
      selectedParcelList.remove(id);
      selectedWeight.value -= (weight ?? 0);
    } else {
      selectedParcelList.add(id);
      selectedWeight.value += (weight ?? 0);
    }
    int confirmedLength =
        allParcelList.where((e) => e.notConfirmed! == 0).toList().length;
    selectAll.value = selectedParcelList.length == confirmedLength;
  }

  // 全选
  void onAllChecked() {
    num weight = 0;
    if (selectAll.value) {
      selectedParcelList.clear();
    } else {
      List<int> ids = [];
      for (var e in allParcelList) {
        if (e.notConfirmed! == 0) {
          ids.add(e.id!);
          weight += (e.packageWeight ?? 0);
        }
      }
      selectedParcelList.value = ids;
    }
    selectedWeight.value = weight;
    selectAll.value = !selectAll.value;
  }

  // 加入拼团
  void onAddGroup() async {
    if (selectedParcelList.isEmpty) {
      showToast('请选择包裹');
      return;
    }
    var res = await GroupService.onGroupAddParcel(
        Get.arguments['id'], {'package_ids': selectedParcelList});
    if (res['ok']) {
      GlobalPages.pop(true);
    }
  }
}
