import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/order_model.dart';
import 'package:huanting_shop/models/parcel_box_model.dart';
import 'package:huanting_shop/views/components/caption.dart';

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
              child: Text((title ?? '提示').ts),
            ),
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(content),
            ),
            actions: <Widget>[
              showCancelButton
                  ? TextButton(
                      child: AppText(
                        str: (cancelText ?? '取消').ts,
                        color: AppColors.textNormal,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : AppGaps.empty,
              TextButton(
                child: AppText(
                  str: (confirmText ?? '确认').ts,
                  color: AppColors.textBlack,
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
          title: Text((title ?? "提示").ts),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(content),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'.ts),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'.ts),
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
                            bottom: BorderSide(color: AppColors.line),
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
                          str: (confirmText ?? '确认').ts,
                          color: AppColors.primary),
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
          '${'子订单'.ts}-' '${i + 1}',
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
              child: Text('取消'.ts),
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
      BeeNav.push(BeeNav.orderTracking, {"order_sn": orderModel.orderSn});
    } else {
      BeeNav.push(BeeNav.orderTracking, {"order_sn": result});
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
                  child:
                      Text(translation ? (e['name'] as String).ts : e['name']),
                  onPressed: () {
                    Navigator.of(context).pop(e['id']);
                  },
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消'.ts),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
