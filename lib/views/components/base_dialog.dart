import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

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
}
