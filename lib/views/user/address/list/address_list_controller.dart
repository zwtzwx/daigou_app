import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/receiver_address_refresh_event.dart';
import 'package:huanting_shop/models/receiver_address_model.dart';
import 'package:huanting_shop/services/address_service.dart';

class BeeShippingLogic extends GlobalLogic {
  List<ReceiverAddressModel> allAddress = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final addressList = <ReceiverAddressModel>[].obs;
  final TextEditingController keywordController = TextEditingController();
  final FocusNode keywordNode = FocusNode();
  final keyword = ''.obs;
  final addressType = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getList();
    ApplicationEvent.getInstance()
        .event
        .on<ReceiverAddressRefreshEvent>()
        .listen((event) {
      getList();
    });
  }

  // 地址列表
  getList() async {
    showLoading();
    var data = await AddressService.getReceiverList({'keyword': keyword});
    hideLoading();
    allAddress = data;
    getAddress();
  }

  getAddress() {
    addressList.value = allAddress
        .where((ele) => ele.addressType == addressType.value)
        .toList();
  }

  // 选择地址
  onSelectAddress(ReceiverAddressModel model) {
    var arguments = Get.arguments;
    if (arguments?['select'] == 1) {
      BeeNav.pop(model);
    }
  }

  @override
  void onClose() {
    keywordController.dispose();
    keywordNode.dispose();
    super.onClose();
  }
}
