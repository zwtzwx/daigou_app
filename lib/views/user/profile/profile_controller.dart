import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huanting_shop/common/upload_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/models/user_model.dart';
import 'package:huanting_shop/services/user_service.dart';
import 'package:huanting_shop/storage/user_storage.dart';

class BeeUserInfoLogic extends GlobalLogic {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final textEditingController = TextEditingController();
  final userImg = ''.obs;

  final isloading = false.obs;
  final userModel = Rxn<UserModel?>();

  // 用户名
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameNode = FocusNode();

  // 注销按钮
  final deleteShow = false.obs;
  final userInfoModel = Get.find<AppStore>();

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
      'avatar': userImg.isEmpty ? userModel.value!.avatar : userImg.value,
    };
    showLoading();
    var result = await UserService.updateByModel(upData);
    hideLoading();
    if (result['ok']) {
      userInfoModel.setUserInfo(result['data']);
      UserStorage.setUserInfo(result['data']);
      showSuccess(result['msg']);
      BeeNav.pop();
    } else {
      showToast(result['msg']);
    }
  }

  onCopyUserId() async {
    await Clipboard.setData(
        ClipboardData(text: userModel.value?.id.toString() ?? ''));
    showSuccess('复制成功');
  }

  onUploadAvatar() {
    ImageUpload.imagePicker(
      onSuccessCallback: (imageUrl) async {
        userImg.value = imageUrl;
      },
      context: Get.context!,
      child: CupertinoActionSheet(
        title: Text('请选择上传方式'.ts),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('相册'.ts),
            onPressed: () {
              Navigator.pop(Get.context!, 'gallery');
            },
          ),
          CupertinoActionSheetAction(
            child: Text('照相机'.ts),
            onPressed: () {
              Navigator.pop(Get.context!, 'camera');
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('取消'.ts),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(Get.context!, 'Cancel');
          },
        ),
      ),
    );
  }

  // 注销
  onLogout() async {
    showLoading();
    var res = await UserService.userDeletion();
    hideLoading();
    if (res['ok']) {
      showSuccess('注销成功');
      userInfoModel.clear();
      BeeNav.redirect(BeeNav.home);
    } else {
      showError(res['msg']);
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    nameNode.dispose();
  }
}
