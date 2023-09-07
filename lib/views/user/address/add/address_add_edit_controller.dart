import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/receiver_address_refresh_event.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/models/self_pickup_station_model.dart';
import 'package:jiyun_app_client/services/address_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class AddressAddEditController extends BaseController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final textEditingController = TextEditingController();

  // 收件人
  final TextEditingController recipientNameController = TextEditingController();
  final FocusNode recipientName = FocusNode();
  // 联系电话
  final TextEditingController mobileNumberController = TextEditingController();
  final FocusNode mobileNumber = FocusNode();
  // 邮编
  final TextEditingController zipCodeController = TextEditingController();
  final FocusNode zipCode = FocusNode();

  // 详细地址
  final TextEditingController streetNameController = TextEditingController();
  final FocusNode streetName = FocusNode();
  final TextEditingController doorNoController = TextEditingController();
  final FocusNode doorNoNode = FocusNode();
  final TextEditingController cityController = TextEditingController();
  final FocusNode cityNode = FocusNode();

  FocusNode blankNode = FocusNode();

  final model = ReceiverAddressModel.empty().obs;
  final isEdit = false.obs;

  final countryModel = Rxn<CountryModel?>();
  final areaModel = Rxn<AreaModel?>();
  final subAreaModel = Rxn<AreaModel?>();
  final station = Rxn<SelfPickupStationModel?>();
  final timezone = ''.obs;
  final addressType = 1.obs;
  final isDefault = false.obs;

  @override
  onInit() {
    super.onInit();
    if (Get.arguments['addressType'] != null) {
      addressType.value = Get.arguments['addressType'];
    }
    onInitData();
  }

  onInitData() {
    var arguments = Get.arguments;
    //如果是编辑
    if (arguments?['isEdit'] == '1') {
      isEdit.value = true;
      getAddressDetail(arguments['id']);
      // model.value = arguments?['address'] as ReceiverAddressModel;
      // recipientNameController.text = model.value.receiverName;
      // mobileNumberController.text = model.value.phone;
      // zipCodeController.text = model.value.postcode;
      // streetNameController.text = model.value.street;
      // cityController.text = model.value.city;
      // doorNoController.text = model.value.doorNo;
      // timezone.value = model.value.timezone;
      // isDefault.value = model.value.isDefault == 1;
      // if (model.value.area != null) {
      //   areaModel.value = model.value.area;
      //   if (model.value.subArea != null) {
      //     subAreaModel.value = model.value.subArea;
      //   }
      // }
      // if (model.value.station != null) {
      //   station.value = model.value.station;
      //   station.value!.address = model.value.address;
      //   station.value!.area = model.value.area;
      //   station.value!.subArea = model.value.subArea;
      // }
    } else {
      model.value.phone = '';
      model.value.receiverName = '';
      model.value.timezone = '';
      model.value.city = '';
      model.value.countryId = 999;
      model.value.street = '';
      model.value.postcode = '';
      model.value.doorNo = '';
    }
    if (isEdit.value) {
      getCountryData();
    }
  }

  // 地址详情
  getAddressDetail(int id) async {
    showLoading();
    var data = await AddressService.getAddressDetail(id);
    hideLoading();
    if (data != null) {
      model.value = data;
      isDefault.value = data.isDefault == 1;
      recipientNameController.text = data.receiverName;
      mobileNumberController.text = model.value.phone;
      timezone.value = model.value.timezone;
      countryModel.value = data.country;
      if (model.value.area != null) {
        areaModel.value = model.value.area;
        if (model.value.subArea != null) {
          subAreaModel.value = model.value.subArea;
        }
      }
      if (data.station != null) {
        station.value = data.station;
        station.value!.address = data.address;
        station.value!.area = data.area;
        station.value!.subArea = data.subArea;
      }
    }
  }

  /*
    得到国家数据
   */
  getCountryData() async {
    List<CountryModel> countryList = await CommonService.getCountryList();
    if (countryList.isNotEmpty) {
      countryModel.value = countryList.first;
    }
  }

  onDeleteAddress() async {
    showLoading();
    var result = await AddressService.deleteReciever(model.value.id!);
    hideLoading();
    if (result) {
      showSuccess('删除成功').then((value) {
        ApplicationEvent.getInstance()
            .event
            .fire(ReceiverAddressRefreshEvent());
        Routers.pop();
      });
    } else {
      showError('删除失败');
    }
  }

  // 获取区域选择列表
  getSubAreaViews(AreaModel areasitem) {
    List<PickerItem> subList = [];
    for (var item in areasitem.areas!) {
      var subArea = PickerItem(
        text: ZHTextLine(
          fontSize: 24,
          str: item.name,
        ),
      );
      subList.add(subArea);
    }
    return subList;
  }

  // 选择国家
  void onStationSelect() async {
    var s = await Routers.push(
        Routers.stationSelect, {'country_id': countryModel.value?.id ?? ''});
    if (s == null) return;
    station.value = s;
  }

  // 提交
  onSubmit() async {
    if (addressType.value == 2 && station.value == null) {
      return showToast('请选择自提点');
    }
    Map<String, dynamic> data = {
      'receiver_name': model.value.receiverName,
      'timezone': timezone.value,
      'phone': model.value.phone,
      'country_id': countryModel.value?.id,
      'address_type': addressType.value,
      'is_default': isDefault.value ? 1 : 0,
    };
    if (addressType.value == 1) {
      data.addAll({
        'street': model.value.street,
        'door_no': model.value.doorNo,
        'city': model.value.city,
        'postcode': model.value.postcode,
        'area_id': areaModel.value?.id ?? '',
        'sub_area_id': subAreaModel.value?.id ?? '',
      });
    } else {
      data['station_id'] = station.value?.id;
    }
    showLoading();
    Map result = {};
    if (isEdit.value) {
      result = await AddressService.updateReciever(model.value.id!, data);
    } else {
      result = await AddressService.addReciever(data);
    }
    hideLoading();
    if (result['ok']) {
      showSuccess(result['msg']).then((value) {
        ApplicationEvent.getInstance()
            .event
            .fire(ReceiverAddressRefreshEvent());
        Routers.pop();
      });
    } else {
      showError(result['msg']);
    }
  }
}
