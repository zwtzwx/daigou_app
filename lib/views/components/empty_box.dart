import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

Widget emptyBox([String? content]) {
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
            ZHTextLine(
              str: (content ?? '暂无内容').ts,
              color: BaseStylesConfig.textGray,
            )
          ],
        ),
      ),
    ],
  );
}
