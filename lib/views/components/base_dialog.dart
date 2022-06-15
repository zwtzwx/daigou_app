import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

class BaseDialog {
  static Future<bool?> confirmDialog(BuildContext context, String content) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(content),
            ),
            actions: <Widget>[
              TextButton(
                child: const Caption(
                  str: '取消',
                  color: ColorConfig.textNormal,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Caption(
                  str: '确定',
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
