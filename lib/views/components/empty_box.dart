import 'package:flutter/material.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

Widget emptyBox(BuildContext context, [String? content]) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Column(
          children: [
            const LoadImage(
              'Home/empty',
              width: 140,
              fit: BoxFit.fitWidth,
            ),
            Caption(
              str: Translation.t(context, content ?? '暂无内容'),
              color: ColorConfig.textGray,
            )
          ],
        ),
      ),
    ],
  );
}
