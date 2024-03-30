import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/insurance_model.dart';
import 'package:shop_app_client/models/parcel_model.dart';
import 'package:shop_app_client/models/receiver_address_model.dart';
import 'package:shop_app_client/models/self_pickup_station_model.dart';
import 'package:shop_app_client/models/ship_line_model.dart';
import 'package:shop_app_client/models/ship_line_service_model.dart';
import 'package:shop_app_client/models/tariff_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/value_added_service_model.dart';
import 'package:shop_app_client/services/group_service.dart';
import 'package:shop_app_client/services/order_service.dart';
import 'package:shop_app_client/services/ship_line_service.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';

class BeePackingLogic extends GlobalController {
  final packageList = <ParcelModel>[].obs;
  final TextEditingController remarkController = TextEditingController();
  // 收件地址
  final selectedAddressModel = Rxn<ReceiverAddressModel?>();

  // 选择的自提点
  final selectStations = Rxn<SelfPickupStationModel?>();

// 保险服务
  final insuranceServices = false.obs;
// 关税服务
  final customsService = false.obs;

  final shipLineModel = Rxn<ShipLineModel?>();

  final serviceList = <ValueAddedServiceModel>[].obs;

  final lineServiceId = <num>[].obs;
  final orderServiceId = <num>[].obs;

  // 保险
  final insuranceModel = Rxn<InsuranceModel?>();

  // 关税
  final tariffModel = Rxn<TariffModel?>();

  final firstStr = '0'.obs;
  final firstMust = false.obs;
  final secondStr = '0'.obs;
  final secondMust = false.obs;
  final totalValue = RxNum(0);
  final pageTitle = ''.obs;
  final isGroup = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments['id'] != null) {
      // 拼团订单
      pageTitle.value = '提交拼团包裹';
      isGroup.value = true;
      onGroupOrderInfo();
    } else {
      // 普通订单
      pageTitle.value = '提交转运包裹';
      packageList.value = Get.arguments['modelList'];
      for (var item in packageList) {
        totalValue.value += item.packageValue ?? 0;
      }

      created();
    }
  }

  created() async {
    showLoading();
    var _serviceList = await ShipLineService.getValueAddedServiceList();
    var _insurance = await ShipLineService.getInsurance();
    var _tariff = await ShipLineService.getTariff();
    hideLoading();

    if (_insurance != null) {
      insuranceModel.value = _insurance;
    }
    if (_tariff != null) {
      tariffModel.value = _tariff;
    }
    serviceList.value = _serviceList;
  }

  // 拼团订单信息
  onGroupOrderInfo() async {
    var res = await GroupService.onGroupOrderPreview(Get.arguments['id']);
    if (res != null) {
      double packageValue = 0;
      for (var item in res.packages!) {
        packageValue += (item.packageValue ?? 0);
      }

      totalValue.value = packageValue;
      packageList.value = res.packages!;
      selectedAddressModel.value = res.group!.address;
      shipLineModel.value = res.group!.expressLine;
      shipLineModel.value!.region = res.group!.region;
      if (res.group!.station != null) {
        selectStations.value = res.group!.station;
        // tempDelivery.value = 1;
      } else {
        // tempDelivery.value = 0;
      }

      created();
    }
  }

  // 选择收件地址
  onAddress() async {
    if (isGroup.value) return;
    // if (tempDelivery.value == null) {
    //   showToast('请选择收货形式'.inte);
    //   return;
    // }
    var s = await GlobalPages.push(GlobalPages.addressList, arg: {'select': 1});

    if (s == null) {
      return;
    }
    selectedAddressModel.value = s as ReceiverAddressModel;
    shipLineModel.value = null;
    lineServiceId.clear();
  }

  // 选择渠道
  onLine() async {
    if (isGroup.value) return;
    if (selectedAddressModel.value == null) {
      showToast('请选择收货地址');
      return;
    }
    List<num> packageIdList = [];
    Set<num> propIdList = {};
    for (ParcelModel item in packageList) {
      packageIdList.add(item.id!);
      if (item.prop != null && item.prop!.isNotEmpty) {
        propIdList.addAll(item.prop!.map((e) => e.id));
      }
    }

    Map<String, dynamic> dic = {
      'warehouse_id': packageList.map((item) => item.warehouseId).toSet().toList(),
      'country_id': selectedAddressModel.value!.countryId,
      'area_id': selectedAddressModel.value!.area == null
          ? ''
          : selectedAddressModel.value!.area?.id,
      'sub_area_id': selectedAddressModel.value!.subArea == null
          ? ''
          : selectedAddressModel.value!.subArea?.id,
      'props': propIdList.toList(), // 所有包裹的propId 数组
      'package_ids': packageIdList, // 包裹的id 数组
      'is_delivery': selectedAddressModel.value!.station != null ? 1 : 0,
      'station_id': selectedAddressModel.value!.station?.id ?? '',
    };
    var s =
        await GlobalPages.push(GlobalPages.lineQueryResult, arg: {"data": dic});
    if (s == null) {
      return;
    }

    shipLineModel.value = s as ShipLineModel;
    lineServiceId.value = (shipLineModel.value?.region?.services ?? [])
        .where((e) => e.isForced == 1)
        .map((e) => e.id)
        .toList();
  }

  // // 选择收货形式
  // onDeliveryType(context) async {
  //   if (isGroup.value) return;
  //   List<Map<String, dynamic>> types = [
  //     {"name": "送货上门", "id": 0},
  //     {"name": "自提点提货", "id": 1},
  //   ];
  //   int? type = await BaseDialog.showBottomActionSheet<int>(
  //       context: context, list: types);
  //   if (type == null) return;

  //   tempDelivery.value = type;
  //   selectedAddressModel.value = null;
  // }

// 提交包裹
  onSubmit() async {
    String msg = '';
    if (selectedAddressModel.value == null) {
      msg = '请选择收货地址';
    } else if (shipLineModel.value == null) {
      msg = '请选择快递方式';
    }
    if (msg.isNotEmpty) {
      showToast(msg);
      return;
    }

    if (isGroup.value) {
      onSubmitGroupOrder();
    } else {
      updataOrder();
    }
  }

  // 提交普通包裹
  updataOrder() async {
    List<String> packagesId = [];
    for (var item in packageList) {
      packagesId.add(item.id.toString());
    }

    Map<String, dynamic> upData = {
      'address_type': selectedAddressModel.value!.addressType,
      'address_id': selectedAddressModel.value!.id,
      'packages': packagesId,
      'station_id': selectedAddressModel.value!.addressType == 2
          ? selectedAddressModel.value!.station?.id
          : '',
      'phone': selectedAddressModel.value!.addressType == 2
          ? selectedAddressModel.value!.phone
          : '',
      'receiver_name': selectedAddressModel.value!.addressType == 2
          ? selectedAddressModel.value!.receiverName
          : '',
      'express_line_id': shipLineModel.value!.id,
      'add_service': orderServiceId,
      'is_insurance': firstMust.value
          ? 1
          : insuranceServices.value
              ? 1
              : 0,
      'is_tariff': secondMust.value
          ? 1
          : customsService.value
              ? 1
              : 0,
      'region_id': shipLineModel.value!.region!.id,
      'line_service_ids': lineServiceId,
      'vip_remark': remarkController.text,
    };
    Map data = await OrderService.store(upData);
    if (data['ok']) {
      Get.find<AppStore>().getBaseCountInfo();
      GlobalPages.pop('succeed');
    }
  }

  // 提交拼团订单
  onSubmitGroupOrder() async {
    Map<String, dynamic> params = {
      'add_service': orderServiceId,
      'line_service_ids': lineServiceId,
      'is_insurance': firstMust.value
          ? 1
          : insuranceServices.value
              ? 1
              : 0,
      'is_tariff': secondMust.value
          ? 1
          : customsService.value
              ? 1
              : 0,
      'vip_remark': remarkController.text,
    };
    var data = await GroupService.onCreatedOrder(Get.arguments['id'], params);
    if (data['ok']) {
      GlobalPages.pop('success');
    }
  }

  showRemark(String title, String content) {
    BaseDialog.normalDialog(
      Get.context!,
      title: title,
      titleFontSize: 18,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          content,
        ),
      ),
    );
  }

  String getLineServiceType(ShipLineServiceModel item) {
    String value = '';
    switch (item.type) {
      case 1:
        value = '实际运费'.inte + ' ${(item.value / 100).toStringAsFixed(2)}%';
        break;
      case 2:
        value = item.value.priceConvert();
        break;
      case 3:
        value = item.value.priceConvert() + '/${'箱'.inte}';
        break;
      case 4:
        value = item.value.priceConvert() +
            '/' +
            localModel!.weightSymbol +
            ' (${'计费重'.inte})';
        break;
      case 5:
        value = item.value.priceConvert() +
            '/' +
            localModel!.weightSymbol +
            ' (${'实重'.inte})';
        break;
      case 6:
        value = ((item.value / 10000) * (totalValue.value / 100))
            .priceConvert(needFormat: false);
        break;
    }
    return value;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }
}
