import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';

class LineDetailController extends BaseController {
  late final lineModel = Rxn<ShipLineModel>();
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments!['type'] == 1) {
      getDetail();
    } else if (arguments!['type'] == 2) {
      lineModel.value = arguments['line'];
    }
  }

  getDetail() async {
    showLoading();
    var data = await ShipLineService.getDetail(Get.arguments!['id']);
    if (data != null) {
      data.regions = data.regions!.where((e) => e.enabled == 1).toList();
      lineModel.value = data;
    }
    hideLoading();
  }

  // showReginsList(BuildContext context) {
  //   UsualDialog.normalDialog(
  //     context,
  //     title: lineModel.value!.name,
  //     child: getAreaList(),
  //   );
  // }
}
