import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';

class BeeParcelClaimLogic extends GlobalLogic {
  final headerStr = ''.obs;
  final footerStr = ''.obs;

  // 同步信息包裹列表
  final syncsList = <ParcelModel>[].obs;
  // 快递单号
  final courierNumber = "".obs;

  final syncsListFirstParcel = ParcelModel().obs;

  // 是传过来的Model
  final argusmentParcelModel = ParcelModel().obs;

  final TextEditingController projectNameController = TextEditingController();

  final FocusNode projectName = FocusNode();

  final flag = false.obs;

  @override
  onInit() {
    super.onInit();
    var arguments = Get.arguments;
    argusmentParcelModel.value = arguments!['order'] as ParcelModel;

    String s1 = argusmentParcelModel.value.expressNum!;
    headerStr.value = s1.split('****')[0];
    footerStr.value = s1.split('****')[1];
    getSyncsList();
  }

  getSyncsList() async {
    var data = await ParcelService.getSyncsList();
    syncsList.value = data;
    if (syncsList.isNotEmpty) {
      syncsListFirstParcel.value = syncsList.first;
    }
  }

  onSubmit() async {
    ParcelModel? tmpParcelModel;
    if (flag.value) {
      tmpParcelModel = ParcelModel.fromSimpleJson({
        'express_num': headerStr + projectNameController.text + footerStr.value,
        'id': syncsListFirstParcel.value.id,
      });
    } else {
      tmpParcelModel = ParcelModel.fromSimpleJson({
        'express_num': headerStr + projectNameController.text + footerStr.value,
        'id': 0,
      });
    }
    showLoading();
    var result = await ParcelService.setNoOwnerToMe(
        argusmentParcelModel.value.id!, tmpParcelModel);
    hideLoading();
    if (result['ok']) {
      showSuccess('认领成功').then((value) {
        BeeNav.pop('success');
      });
    } else {
      showError(result['msg']);
    }
  }
}
