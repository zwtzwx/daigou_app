import 'dart:io';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/*
  上传图片
 */
class UploadUtil {
  /*
    图片选择
    不带编辑
   */
  static final ImagePicker _picker = ImagePicker();

  static void imagePicker(
      {required BuildContext context,
      required Widget child,
      required Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String? type) async {
      XFile? image;

      if (type == 'camera') {
        image = await _picker.pickImage(source: ImageSource.camera);
      } else if (type == 'gallery') {
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
          sourcePath: image.path,
          maxWidth: 800,
          maxHeight: 800,
        );
        if (croppedFile != null) {
          EasyLoading.show(status: '上传中');
          String imageUrl =
              await CommonService.uploadImage(File(croppedFile.path));
          EasyLoading.dismiss();
          onSuccessCallback(imageUrl);
        }
      }
    });
  }

  /*
    图片选择
    带裁剪
   */
  static void imagePickerEditor(
      {required BuildContext context,
      required Widget child,
      required Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String? type) async {
      XFile? image;
      if (type == 'camera') {
        image = await _picker.pickImage(source: ImageSource.camera);
      } else if (type == 'gallery') {
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 75, ratioY: 31),
            aspectRatioPresets: Platform.isAndroid
                ? [
                    CropAspectRatioPreset.original,
                  ]
                : [
                    CropAspectRatioPreset.original,
                  ],
            uiSettings: [
              AndroidUiSettings(
                  toolbarTitle: '编辑图片',
                  toolbarColor: Colors.deepOrange,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(
                title: '编辑图片',
              ),
            ]);
        if (croppedFile != null) {
          String imageUrl =
              await CommonService.uploadImage(File(croppedFile.path));
          onSuccessCallback(imageUrl);
        }
      }
    });
  }
}
