import 'dart:io';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/*
  上传图片
 */
class ImageUpload {
  /*
    图片选择
    不带编辑
   */
  static final ImagePicker _picker = ImagePicker();

  static void imagePicker(
      {required BuildContext context,
      Widget? child,
      required Function onSuccessCallback}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) =>
          child ??
          CupertinoActionSheet(
            title: Text('请选择上传方式'.ts),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('相册'.ts),
                onPressed: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              CupertinoActionSheetAction(
                child: Text('照相机'.ts),
                onPressed: () {
                  Navigator.pop(context, 'camera');
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'.ts),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ),
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
          EasyLoading.show(status: '上传中'.ts);
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
                  toolbarTitle: '编辑图片'.ts,
                  toolbarColor: Colors.deepOrange,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(
                title: '编辑图片'.ts,
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
