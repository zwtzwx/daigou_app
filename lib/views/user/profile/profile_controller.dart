import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';

class ProfileController extends BaseController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final textEditingController = TextEditingController();
  final userImg = ''.obs;

  final isloading = false.obs;
  final userModel = Rxn<UserModel?>();

  // 用户名
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameNode = FocusNode();

  // 城市
  final TextEditingController cityNameController = TextEditingController();
  final FocusNode cityName = FocusNode();

  FocusNode blankNode = FocusNode();
  // 注销按钮
  final deleteShow = false.obs;
  final userInfoModel = Get.find<UserInfoModel>();

  @override
  onInit() {
    super.onInit();
    getInfo();
    getStatus();
  }

  getInfo() async {
    showLoading();
    userModel.value = await UserService.getProfile();
    hideLoading();
    cityNameController.text = userModel.value!.liveCity;
    nameController.text = userModel.value!.name;
    isloading.value = true;
  }

  getStatus() async {
    var result = await UserService.getThirdLoginStatus();
    if (!result && Platform.isIOS) {
      deleteShow.value = true;
    }
  }

  // 更改个人信息
  onSubmit() async {
    Map<String, dynamic> upData = {
      'name': nameController.text,
      'avatar': userImg.isEmpty ? userModel.value!.avatar : userImg,
      'gender': userModel.value!.gender, // 性别
      'live_city': cityNameController.text, // 当前城市
    };
    showLoading();
    var result = await UserService.updateByModel(upData);
    hideLoading();
    if (result['ok']) {
      userInfoModel.setUserInfo(result['data']);
      UserStorage.setUserInfo(result['data']);
      showSuccess(result['msg']);
      Routers.pop();
    } else {
      showToast(result['msg']);
    }
  }

  // 注销
  onLogout() async {
    showLoading();
    var res = await UserService.userDeletion();
    hideLoading();
    if (res['ok']) {
      showSuccess('注销成功');
      userInfoModel.clear();
      Routers.redirect(Routers.home);
    } else {
      showError(res['msg']);
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameNode.dispose();
    cityName.dispose();
    blankNode.dispose();
  }
}
