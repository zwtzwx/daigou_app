import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

/*
  公共弹窗
 */

class BaseDialog {
  // 确认弹窗
  static Future<bool?> confirmDialog(
    BuildContext context,
    String content, {
    String? title,
    bool showCancelButton = true,
  }) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              child: Text(title ?? Translation.t(context, '提示')),
            ),
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(content),
            ),
            actions: <Widget>[
              showCancelButton
                  ? TextButton(
                      child: Caption(
                        str: Translation.t(context, '取消'),
                        color: ColorConfig.textNormal,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Gaps.empty,
              TextButton(
                child: Caption(
                  str: Translation.t(context, '确认'),
                  color: ColorConfig.textBlack,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  // 普通弹窗
  static void normalDialog(
    BuildContext context, {
    String? title,
    double? titleFontSize,
    required Widget child,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: ScreenUtil().screenHeight - 200,
            ),
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
                          bottom: BorderSide(color: ColorConfig.line),
                        )),
                        alignment: Alignment.center,
                        child: Caption(
                          str: title,
                          fontSize: titleFontSize ?? 15,
                        ),
                      )
                    : Gaps.empty,
                child,
                Gaps.line,
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Caption(
                        str: Translation.t(context, '确认'),
                        color: ColorConfig.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 客服弹窗
  static void customerDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.vGap20,
              Caption(
                str: Translation.t(context, '选择客服'),
                fontSize: 18,
              ),
              Gaps.vGap20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkResponse(
                    onTap: () async {
                      String whatsapp = '+821027320501';
                      String whatsappURlAndroid =
                          'whatsapp://send?phone=' + whatsapp + '&text=';
                      String whatappURLIos = "https://wa.me/$whatsapp?text=";
                      if (Platform.isIOS) {
                        if (await canLaunchUrl(Uri.parse(whatappURLIos))) {
                          await launchUrl(Uri.parse(whatappURLIos));
                        }
                      } else {
                        if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
                          await launchUrl(Uri.parse(whatsappURlAndroid));
                        }
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.whatsapp,
                          color: Color(0xFF25D366),
                          size: 45,
                        ),
                        Gaps.vGap5,
                        Caption(
                          str: 'WhatsApp',
                        ),
                      ],
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      fluwx.isWeChatInstalled.then((installed) {
                        if (installed) {
                          fluwx
                              .openWeChatCustomerServiceChat(
                                  url:
                                      'https://work.weixin.qq.com/kfid/kfce5c914af10d474ce',
                                  corpId: 'ww3087c8445ff9e3a6')
                              .then((data) {});
                        } else {
                          Util.showToast(Translation.t(context, '请先安装微信'));
                        }
                      });
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.wechat,
                          color: Color(0xFF51C332),
                          size: 45,
                        ),
                        Gaps.vGap5,
                        Caption(
                          str: 'Wechat',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.vGap20,
            ],
          );
        });
  }

  // 多箱物流
  static void showBoxsTracking(
      BuildContext context, OrderModel orderModel) async {
    List<Widget> list = [];
    for (var i = 0; i < orderModel.boxes.length; i++) {
      ParcelBoxModel boxModel = orderModel.boxes[i];
      var view = CupertinoActionSheetAction(
        child: Text(
          '${Translation.t(context, '子订单')}-' '${i + 1}',
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
              child: Text(Translation.t(context, '取消')),
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
      Routers.push(
          '/TrackingDetailPage', context, {"order_sn": orderModel.orderSn});
    } else {
      Routers.push('/TrackingDetailPage', context, {"order_sn": result});
    }
  }
}
