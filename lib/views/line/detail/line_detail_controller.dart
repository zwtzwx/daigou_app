import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/ship_line_model.dart';
import 'package:shop_app_client/models/ship_line_service_model.dart';
import 'package:shop_app_client/services/ship_line_service.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/caption.dart';

class LineDetailController extends GlobalController
    with GetSingleTickerProviderStateMixin {
  late final lineModel = Rxn<ShipLineModel>();
  final PageController pageController = PageController();
  final loading = false.obs;
  late TabController tabController;
  final tabIndex = 0.obs;
  bool fromCalc = false; // 运费估算线路详情

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    var arguments = Get.arguments;
    if (arguments!['type'] == 1) {
      getDetail();
    } else if (arguments!['type'] == 2) {
      fromCalc = true;
      lineModel.value = arguments['line'];
    }
  }

  getDetail() async {
    loading.value = true;
    var data = await ShipLineService.getDetail(Get.arguments!['id']);
    if (data != null) {
      data.regions = data.regions!.where((e) => e.enabled == 1).toList();
      lineModel.value = data;
    }
    loading.value = false;
  }

  showTipsView(ShipLineServiceModel item) {
    BaseDialog.normalDialog(
      Get.context!,
      title: item.name,
      titleFontSize: 18,
      child: Container(
        // height: 60,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: AppText(
          str: item.remark,
          lines: 10,
        ),
      ),
    );
  }

  // showReginsList(BuildContext context) {
  //   UsualDialog.normalDialog(
  //     context,
  //     title: lineModel.value!.name,
  //     child: getAreaList(),
  //   );
  // }
}
