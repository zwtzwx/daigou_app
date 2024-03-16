import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/order_model.dart';
import 'package:shop_app_client/models/parcel_box_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/common/upload_util.dart';
import 'package:get/get.dart';

/*
  公共弹窗
 */

class BaseDialog {
  // 确认弹窗
  static Future<bool?> confirmDialog(BuildContext context, String content,
      {String? title,
      String? confirmText,
      String? cancelText,
      bool showCancelButton = true,
      bool barrierDismissible = false}) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              child: Text((title ?? '提示').inte),
            ),
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(content),
            ),
            actions: <Widget>[
              showCancelButton
                  ? TextButton(
                      child: AppText(
                        str: (cancelText ?? '取消').inte,
                        color: AppStyles.textNormal,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : AppGaps.empty,
              TextButton(
                child: AppText(
                  str: (confirmText ?? '确认').inte,
                  color: AppStyles.textBlack,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  // ios 风格 确认弹窗
  static Future<bool?> cupertinoConfirmDialog(
      BuildContext context, String content,
      {String? title,
      bool showCancelButton = true,
      bool barrierDismissible = false}) {
    return showDialog<bool>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text((title ?? "提示").inte),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(content),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'.inte),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'.inte),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  // 普通弹窗
  static Future<bool?> normalDialog(
    BuildContext context, {
    String? title,
    double? titleFontSize,
    String? confirmText,
    bool barrierDismissible = true,
    required Widget child,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: ScreenUtil().screenHeight - 200,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: const BoxDecoration(
                              border: Border(
                            bottom: BorderSide(color: AppStyles.line),
                          )),
                          alignment: Alignment.center,
                          child: AppText(
                            str: title,
                            fontSize: titleFontSize ?? 15,
                          ),
                        )
                      : AppGaps.empty,
                  child,
                  AppGaps.line,
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: AppText(
                          str: (confirmText ?? '确认').inte,
                          color: AppStyles.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 多箱物流
  static void showBoxsTracking(
      BuildContext context, OrderModel orderModel) async {
    List<Widget> list = [];
    for (var i = 0; i < orderModel.boxes.length; i++) {
      ParcelBoxModel boxModel = orderModel.boxes[i];
      var view = CupertinoActionSheetAction(
        child: Text(
          '${'子订单'.inte}-' '${i + 1}',
        ),
        onPressed: () {
          Navigator.of(context)
              .pop(boxModel.logisticsSn.isEmpty ? '' : boxModel.logisticsSn);
        },
      );
      list.add(view);
    }
    String? result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: list,
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'.inte),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
          );
        });
    if (result == 'cancel') {
      return;
    }
    if (result != null && result.isEmpty) {
      GlobalPages.push(GlobalPages.orderTracking,
          arg: {"order_sn": orderModel.orderSn});
    } else {
      GlobalPages.push(GlobalPages.orderTracking, arg: {"order_sn": result});
    }
  }

  // 底部 actionSheet
  static Future<T?> showBottomActionSheet<T>({
    required BuildContext context,
    required List<Map<String, dynamic>> list,
    bool translation = true,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: list
              .map(
                (e) => CupertinoActionSheetAction(
                  child: Text(
                      translation ? (e['name'] as String).inte : e['name']),
                  onPressed: () {
                    Navigator.of(context).pop(e['id']);
                  },
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消'.inte),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }


//   根据type 返回不同弹窗  1 优惠券  2 修改头像昵称
// 确认弹窗
  static Future<bool?> typeDialog(BuildContext context, num type,
      Function onPressed,
      Map<String, dynamic>params,
      {String? title,
        String? confirmText,
        String? cancelText,
        bool showCancelButton = true,
        bool barrierDismissible = false}) {
        RxString avatar = params['avatar'].toString().obs;
    return showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          TextEditingController nickNameController = TextEditingController();
          late FocusNode nickNameNode = FocusNode();

          TextEditingController exchangeController = TextEditingController();
          late FocusNode exchangeNode = FocusNode();

          nickNameController.text = params['name'];
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0), // 设置圆角半径为10.0
            ),
            title: type==2?Container(
              alignment: Alignment.center,
              child: AppText(str:('修改个人信息').inte,
                color: Color(0xff333333)),
            ):Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(str:('兑换').inte,
                    color: Color(0xff333333)),
                IconTheme(
                  data: IconThemeData(size: 20.0),
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    splashColor: Colors.transparent, // 去除水波纹效果
                    highlightColor: Colors.transparent, // 去除点击高亮效果
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            content: Container(
              height: type==1?50.h:120.h,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: type==2?Obx(()=>Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        ImagePickers.imagePicker(
                          context: Get.context!,
                          onSuccessCallback: (imageUrl) {
                            avatar.value = imageUrl;
                          },
                        );
                      },
                      child:

                      SizedBox(
                        width: 60.w,
                        height: 60.w,
                        child: ClipOval(
                          child: ImgItem(
                            avatar.value ?? 'Center/edit-avatar',
                          ),
                        ),
                      )
                  ),
                  20.verticalSpace,
                  BaseInput(
                    style: TextStyle(fontSize: 20),
                    hintText: '请输入新的昵称'.inte,
                    board: true,
                    minLines: 1,
                    maxLines: 1,
                    maxLength: 300,
                    suffix: IconTheme(
                      data: IconThemeData(size: 20.0),
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        splashColor: Colors.transparent, // 去除水波纹效果
                        highlightColor: Colors.transparent, // 去除点击高亮效果
                        onPressed: () {
                          // 清空文本框内容的操作
                          nickNameController.text = '';
                        },
                      ),
                    ),
                    controller: nickNameController,
                    focusNode: nickNameNode,
                    autoShowRemove: false,
                    contentPadding: EdgeInsets.all(10.w),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    autoRemoveController: false,
                    onChanged: (res) {

                    },
                  )
                ],
              )):Column(
                children: [
                  BaseInput(
                    style: TextStyle(fontSize: 20),
                    hintText: '请输入兑换码'.inte,
                    board: true,
                    minLines: 1,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    maxLines: 1,
                    // suffix: IconTheme(
                    //   data: IconThemeData(size: 15.0),
                    //   child: IconButton(
                    //     icon: Icon(Icons.clear),
                    //     splashColor: Colors.transparent, // 去除水波纹效果
                    //     highlightColor: Colors.transparent, // 去除点击高亮效果
                    //     onPressed: () {
                    //       // 清空文本框内容的操作
                    //       exchangeController.text = '';
                    //     },
                    //   ),
                    // ),
                    maxLength: 300,
                    controller: exchangeController,
                    focusNode: exchangeNode,
                    autoShowRemove: false,
                    contentPadding: EdgeInsets.all(10.w),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    autoRemoveController: false,
                    onChanged: (res) {

                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 35.h,
                        child: BeeButton(
                          onPressed: () {
                            if(type==2) {
                              onPressed({
                                'avatar': avatar.value,
                                'name': nickNameController.text
                              });
                            }

                            else {
                              onPressed({
                                'exchange': exchangeController.text,
                              });
                            }
                            Navigator.of(context).pop();
                          },
                          text: type==1?'兑换':'确认修改',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              type==2?Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 35.h,
                        child: BeeButton(
                          backgroundColor: const Color(0xFFFFE1E2),
                          textColor: AppStyles.primary,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: '取消',
                        ),
                      ),
                    ),
                  ],
                ),
              ):AppGaps.empty
            ],
          );
        });
  }
}
