import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';

class AnnoucementDialog extends StatelessWidget {
  const AnnoucementDialog({Key? key, required this.model}) : super(key: key);
  final AnnouncementModel model;

  // 获取日期
  String getDate(String dateTime) {
    return dateTime.split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: ColorConfig.warningText,
            width: double.infinity,
            alignment: Alignment.center,
            child: Caption(
              str: model.title,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        model.content,
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Caption(
                      str: getDate(model.updatedAt),
                      fontSize: 14,
                      color: ColorConfig.textGrayC9,
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            height: 1,
            color: ColorConfig.textGrayC,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Caption(
              str: '我知道了',
              color: ColorConfig.warningText,
            ),
          )
        ],
      ),
    );
  }
}
