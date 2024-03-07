import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/common/upload_util.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/services/common_service.dart';
import 'package:huanting_shop/views/shop/image_search_goods_list/binding.dart';
import 'package:huanting_shop/views/shop/image_search_goods_list/view.dart';
import 'package:permission_handler/permission_handler.dart';

class GoodsImageSearchLogic extends GlobalLogic with WidgetsBindingObserver {
  final cameraCtl = Rxn<CameraController?>();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments['device'] != null) {
      cameraControllerInit(camera: arguments['device']);
    }
  }

  cameraControllerInit({
    required CameraDescription camera,
  }) async {
    if (cameraCtl.value != null) {
      await cameraCtl.value!.dispose();
    }
    cameraCtl.value = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    try {
      await cameraCtl.value!.initialize();
      cameraCtl.refresh();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showError('您拒绝了相机访问');
          break;
        case 'CameraAccessRestricted':
        case 'CameraAccessDeniedWithoutPrompt':
          showToast('请开启相机权限');
          openAppSettings();
          break;
      }
    }
  }

  // 拍照
  void onTakePhoto() async {
    try {
      var file = await cameraCtl.value!.takePicture();
      cameraCtl.value!.pausePreview();
      String imageUrl = await CommonService.uploadImage(File(file.path),
          options: Options(extra: {
            'showSuccess': false,
          }));
      Get.to(
          GoodsImageSearchResultPage(
            controllerTag: imageUrl,
          ),
          arguments: {'url': imageUrl},
          binding: GoodsImageSearchResultBinding(tag: imageUrl));
      cameraCtl.value!.resumePreview();
    } catch (e) {
      // if (e is! NetworkException) {
      //   showError('出现未知错误');
      // }
      showError(e.toString());
      cameraCtl.value!.resumePreview();
    }
  }

  // 从相册中选择
  void onPickerImage() async {
    String? path = await ImageUpload.imagePickerByLibray();
    if (path != null) {
      String imageUrl = await CommonService.uploadImage(File(path),
          options: Options(extra: {
            'showSuccess': false,
          }));
      Get.to(
          GoodsImageSearchResultPage(
            controllerTag: imageUrl,
          ),
          arguments: {'url': imageUrl},
          binding: GoodsImageSearchResultBinding(tag: imageUrl));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraCtl.value == null || !cameraCtl.value!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraCtl.value!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraControllerInit(camera: cameraCtl.value!.description);
    }
  }

  @override
  void onClose() {
    if (cameraCtl.value != null && cameraCtl.value!.value.isInitialized) {
      cameraCtl.value!.dispose();
    }
    super.onClose();
  }
}
