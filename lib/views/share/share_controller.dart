import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:shop_app_client/extension/translation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui' as ui;


class ShareLogic extends GlobalController {
  AppStore userInfoModel = Get.find<AppStore>();
  GlobalKey globalKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
  }

  Future<Uint8List> capturePng() async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      throw Exception('操作失败'.inte);
    }
  }

  void saveImage() async {
    Uint8List pngBytes = await capturePng();
    final result = await ImageGallerySaver.saveImage(pngBytes);
    if(result['isSuccess'])EasyLoading.showToast('已保存到本地相册'.inte);
  }
}



