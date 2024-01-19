import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/announcement_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/home/home_controller.dart';

class AnnoucementDialog extends StatelessWidget {
  AnnoucementDialog({
    Key? key,
    required this.model,
  }) : super(key: key);
  final AnnouncementModel model;
  final IndexLogic controller = Get.find<IndexLogic>();

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
            constraints: BoxConstraints(
              maxHeight: ScreenUtil().screenHeight / 2,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AppText(
                      str: model.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      model.content,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: BeeButton(
                      text: '查看更多'.ts,
                      fontSize: 14,
                      borderRadis: 20.0,
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                  AppGaps.vGap20,
                ],
              ),
            ),
          ),
          AppGaps.vGap15,
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
