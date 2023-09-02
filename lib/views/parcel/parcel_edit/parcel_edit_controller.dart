import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/list_refresh_event.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/express_company_service.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';

class ParcelEditController extends BaseController {
  final TextEditingController packgeNameController = TextEditingController();
  final FocusNode packageNameNode = FocusNode();
  final TextEditingController packgeValueController = TextEditingController();
  final FocusNode packageValueNode = FocusNode();
  final TextEditingController packgeQtyController = TextEditingController();
  final FocusNode packageQtyNode = FocusNode();

  final TextEditingController remarkController = TextEditingController();
  final FocusNode remarkNode = FocusNode();
  final isSelectedCountry = false.obs;

  final isLoadingLocal = false.obs;

  final packageModel = ParcelModel().obs;

  // 可能改变的数据
  final expressCompany = Rxn<ExpressCompanyModel?>();
  final countryModel = Rxn<CountryModel?>();

  final expressCompanyList = <ExpressCompanyModel>[].obs;
  final propList = <ParcelPropsModel>[].obs;
  final serviceList = <ValueAddedServiceModel>[].obs;
  final wareHouseList = <WareHouseModel>[].obs;
  final selectedProps = <ParcelPropsModel>[].obs;

  final propSingle = false.obs;

  @override
  void onReady() {
    super.onReady();
    var id = Get.arguments['id'];
    getDetail(id);
    getData();
  }

  void getDetail(int id) async {
    showLoading();
    var data = await ParcelService.getDetail(id);
    hideLoading();
    if (data != null) {
      packageModel.value = data;
      if (packageModel.value.country != null) {
        isSelectedCountry.value = true;
        getWarehouse();
      }
      getPropsList();
      if (data.prop != null) {
        selectedProps.value = data.prop!;
      }
      packgeNameController.text = (packageModel.value.packageName ?? '');
      packgeQtyController.text = (packageModel.value.qty ?? '').toString();
      packgeValueController.text =
          (packageModel.value.packageValue ?? 0).rate(showPriceSymbol: false);
      remarkController.text = (packageModel.value.remark ?? '');
      isLoadingLocal.value = true;
    }
  }

  /*
    加载
   */
  getData() async {
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _single = await GoodsService.getPropConfig();
    expressCompanyList.value = _expressCompanyList;
    propSingle.value = _single;
  }

  // 根据国家获取仓库列表
  getWarehouse() async {
    var id = countryModel.value != null
        ? countryModel.value!.id
        : packageModel.value.country!.id;
    var data = await WarehouseService.getList({'country_id': id});
    wareHouseList.value = data;
  }

  // 根据国家获取属性列表
  getPropsList() async {
    var _propList = await GoodsService.getPropList({
      'country_id': countryModel.value?.id ?? packageModel.value.country?.id
    });
    propList.value = _propList;
  }

  // 修改包裹信息
  onSubmit() async {
    String msg = '';
    if (packgeNameController.text.isEmpty) {
      msg = '请输入物品名称';
    } else if (packgeValueController.text.isEmpty) {
      msg = '请输入物品总价';
    } else if (double.parse(packgeValueController.text) <= 0) {
      msg = '请输入正确的物品总价';
    } else if (selectedProps.isEmpty) {
      msg = '请选择物品属性';
    } else if (countryModel.value == null &&
        packageModel.value.country == null) {
      msg = '请选择发往国家';
    }
    if (msg.isNotEmpty) {
      showToast(msg);
      return;
    }
    num value = double.parse(packgeValueController.text) *
        100 /
        (currencyModel.value?.rate ?? 1);
    Map<String, dynamic> map = {
      'express_num': packageModel.value.expressNum,
      'express_id': expressCompany.value?.id ?? packageModel.value.expressId,
      'category_ids': [],
      'package_value': value,
      'package_name': packgeNameController.text,
      'qty': packgeQtyController.text,
      'prop_id': selectedProps.map((e) => e.id).toList(),
      'country_id': countryModel.value != null
          ? countryModel.value!.id
          : (packageModel.value.country != null
              ? packageModel.value.country!.id
              : ''),
      'warehouse_id': packageModel.value.warehouse?.id,
      'remark': remarkController.text,
    };

    showLoading();
    bool data = await ParcelService.update(packageModel.value.id!, map);
    hideLoading();
    if (data) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'reset'));
      showSuccess('修改成功').then((value) {
        Routers.pop();
      });
    } else {
      showError('修改失败');
    }
  }

  // 选择国家
  goCountry() async {
    var s = await Routers.push(Routers.country, {
      'warehouseId': packageModel.value.warehouse?.id,
    });
    if (s == null) {
      return;
    }
    countryModel.value = s as CountryModel;
    isSelectedCountry.value = true;
    packageModel.value.prop = null;
    if (packageModel.value.status == 1 ||
        (packageModel.value.status == 2 &&
            packageModel.value.warehouse == null)) {
      packageModel.value.warehouse = null;
      getWarehouse();
    }
    getPropsList();
  }
}
