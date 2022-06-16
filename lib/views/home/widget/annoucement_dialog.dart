import 'package:dotted_border/dotted_border.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/announcement_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
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
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Caption(
                    str: model.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    model.content,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: MainButton(
                    text: '查看更多',
                    fontSize: 14,
                    borderRadis: 20.0,
                    backgroundColor: ColorConfig.green,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Gaps.vGap20,
              ],
            ),
          ),
          Gaps.vGap15,
          GestureDetector(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
