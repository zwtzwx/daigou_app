import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

/*
  公共弹窗
 */

class BaseDialog {
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
                  str: Translation.t(context, '确定'),
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
}
