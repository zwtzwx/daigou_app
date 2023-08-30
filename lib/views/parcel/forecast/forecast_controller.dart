import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/order_count_refresh_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/express_company_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/value_added_service_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/services/express_company_service.dart';
import 'package:jiyun_app_client/services/goods_service.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/services/station_service.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class ForecastController extends BaseController {
  ScrollController scrollController = ScrollController();
  FocusNode blankNode = FocusNode();
  CountryModel? selectedCountryModel;
  WareHouseModel? selectedWarehouseModel;

  //预报的包裹列表
  List<ParcelModel> formData = [ParcelModel()];

  // 协议确认
  final agreementBool = true.obs;
  // 协议条款
  final terms = <String, dynamic>{}.obs;

  //快递公司
  final expressCompanyList = <ExpressCompanyModel>[].obs;
  //商品属性
  List<ParcelPropsModel> goodsPropsList =
      List<ParcelPropsModel>.empty(growable: true);

  //预报服务
  // final valueAddedServiceList = <ValueAddedServiceModel>[].obs;
  //仓库列表
  List<WareHouseModel> wareHouseList = [];
  // 默认自提点
  SelfPickupStationModel? stationModel;

  UserModel? userModel = Get.find<UserInfoModel>().userInfo.value;

  @override
  void onInit() {
    super.onInit();
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      showToast('登录凭证已失效');
      Routers.push(Routers.login);
    });
    created();
    getStation();
    loadInitData();
  }

  created() async {
    var countryList = await CommonService.getCountryList();
    // var _valueAddedServiceList = await ParcelService.getValueAddedServiceList();
    if (countryList.isNotEmpty) {
      selectedCountryModel = countryList[0];
      getWarehouseList();
      getProps();
    }
  }

  //加载页面所需要的数据
  loadInitData() async {
    showLoading();
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _terms = await CommonService.getTerms();
    hideLoading();
    expressCompanyList.value = _expressCompanyList;
    if (_terms != null) {
      terms.value = _terms;
    }
  }

  // 获取自提点
  getStation() async {
    var data = await StationService.getList();
    if (data['dataList'] != null) {
      stationModel = data['dataList'][0];
    }
  }

  // 物品属性
  getProps() async {
    var _goodsPropsList = await GoodsService.getPropList(
        {'country_id': selectedCountryModel?.id});
    goodsPropsList = _goodsPropsList;
  }

  // 根据国家获取仓库列表
  getWarehouseList() async {
    var data = await WarehouseService.getList(
        {'country_id': selectedCountryModel?.id});
    wareHouseList = data;
    selectedWarehouseModel = wareHouseList.first;
  }

  // 提交预报
  void onSubmit() async {
    if (!agreementBool.value) {
      showToast('请同意包裹转运协议');
      return;
    }
    for (ParcelModel item in formData) {
      if (item.expressNum == null) {
        showToast('请填写快递单号');
        return;
      }
    }

    List<Map> packageList = [];
    int defaultProp = goodsPropsList.first.id;
    for (ParcelModel item in formData) {
      Map<String, dynamic> dic = {
        'express_num': item.expressNum,
        'package_name': 'ежедневные нужды',
        'package_value': 480,
        'prop_id': [defaultProp],
        'express_id': expressCompanyList[0].id,
        'category_ids': [],
        'qty': 1,
        'remark': '',
      };
      packageList.add(dic);
    }
    List<int> selectService = [];
    // for (ValueAddedServiceModel item in valueAddedServiceList) {
    //   if (item.isOpen) {
    //     selectService.add(item.id);
    //   }
    // }
    showLoading();
    //开始提交预报
    ParcelService.store({
      'packages': packageList,
      'country_id': selectedCountryModel!.id,
      'warehouse_id': selectedWarehouseModel!.id,
      'op_service_ids': selectService,
      'ship_mode': 3,
      'mode': 2,
      'station_id': stationModel?.id ?? '',
      'express_line_id': stationModel?.expressLines?.first.id,
      'name': userModel?.name ?? '',
      'phone': userModel?.phone ?? '',
    }, (data) async {
      hideLoading();
      if (data.ok) {
        ApplicationEvent.getInstance().event.fire(OrderCountRefreshEvent());
        await showSuccess(data.msg);
        Routers.pop();
      } else {
        showError(data.msg);
      }
    }, (message) {
      showError(message);
    });
  }

  // 获取快递公司
  getPickerExpressCompany(List<ExpressCompanyModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: ZHTextLine(
          fontSize: 24,
          str: item.name,
        ),
      );
      data.add(containe);
    }
    return data;
  }
}
