import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

// ignore: non_constant_identifier_names
Widget TitleCell(BuildContext context, String title, Function onMore) {
  return Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Translation.t(context, title, listen: true),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorConfig.textBlack,
          ),
        ),
        GestureDetector(
          onTap: () {
            onMore();
          },
          child: Row(
            children: [
              Caption(
                str: Translation.t(context, '更多', listen: true),
                fontSize: ScreenUtil().setSp(12),
                color: ColorConfig.main,
              ),
              Gaps.hGap5,
              ClipOval(
                child: Container(
                  width: 18,
                  height: 18,
                  color: ColorConfig.main,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
