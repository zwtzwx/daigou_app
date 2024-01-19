import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/models/warehouse_model.dart';
import 'package:huanting_shop/services/warehouse_service.dart';

class BeeCangKuLogic extends GlobalLogic {
  final warehouseList = <WareHouseModel>[].obs;
  final isLoading = false.obs;
  UserModel? userModel = Get.find<AppStore>().userInfo.value;

  @override
  onInit() {
    super.onInit();
    getList();
  }

  // 仓库地址
  getList() async {
    showLoading();
    var dic = await WarehouseService.getList();
    hideLoading();
    warehouseList.value = dic;
    isLoading.value = true;
  }

  // 复制
  onCopy(String data) {
    Clipboard.setData(ClipboardData(text: data))
        .then((value) => showSuccess('复制成功'));
  }
}
