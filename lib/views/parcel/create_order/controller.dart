import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/models/insurance_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/ship_line_model.dart';
import 'package:jiyun_app_client/models/tariff_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/services/group_service.dart';
import 'package:jiyun_app_client/services/order_service.dart';
import 'package:jiyun_app_client/services/ship_line_service.dart';

class CreateOrderController extends BaseController {
  final packageList = <ParcelModel>[].obs;
  final TextEditingController evaluateController = TextEditingController();
  FocusNode blankNode = FocusNode();
  final isLoading = false.obs;
  // 收件地址
  final selectedAddressModel = Rxn<ReceiverAddressModel?>();
  // 收货形式
  // final tempDelivery = Rxn<int?>();
  // 选择的自提点
  final selectStations = Rxn<SelfPickupStationModel?>();

// 保险服务
  final insuranceServices = false.obs;
// 关税服务
  final customsService = false.obs;

  // 自提点数据
  final selfPickupStationModel = Rxn<SelfPickupStationModel?>();

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
    isLoading.value = true;
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
    //   showToast('请选择收货形式'.ts);
    //   return;
    // }
    var s = await Routers.push(Routers.addressList, {'select': 1});

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
    num totalWeight = 0;
    List<num> packageIdList = [];
    List<num> propIdList = [];
    for (ParcelModel item in packageList) {
      packageIdList.add(item.id!);
      if (item.prop != null) {
        propIdList.add(item.prop!.first.id);
      }
      if (item.packageWeight == null) {
        totalWeight += 0;
      } else {
        totalWeight += item.packageWeight ?? 0;
      }
    }
    // int areaid = selectedAddressModel!.area =
    // int subareaid =
    Map<String, dynamic> dic = {
      'country_id': selectedAddressModel.value!.countryId,
      'area_id': selectedAddressModel.value!.area == null
          ? ''
          : selectedAddressModel.value!.area?.id,
      'sub_area_id': selectedAddressModel.value!.subArea == null
          ? ''
          : selectedAddressModel.value!.subArea?.id,
      'weight': totalWeight, // 所选包裹总重量
      'prop_ids': propIdList, // 所有包裹的propId 数组
      // 'warehouse_id': packageList.first.warehouseId, // 包裹所在的仓库
      'package_ids': packageIdList, // 包裹的id 数组
      'is_delivery': selectedAddressModel.value!.station != null ? 1 : 0,
      'station_id': selectedAddressModel.value!.station?.id ?? '',
    };
    var s = await Routers.push(Routers.lineQueryResult, {"data": dic});
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
      'vip_remark': evaluateController.text,
    };
    Map data = await OrderService.store(upData);
    if (data['ok']) {
      ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent());
      Routers.pop('succeed');
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
      'vip_remark': evaluateController.text,
    };
    var data = await GroupService.onCreatedOrder(Get.arguments['id'], params);
    if (data['ok']) {
      Routers.pop('success');
    }
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
