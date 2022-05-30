import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';

// ignore: non_constant_identifier_names
Widget TitleCell(BuildContext context) {
  return Container(
    height: 44,
    padding: const EdgeInsets.only(left: 10),
    child: Row(
      children: <Widget>[
        SizedBox(
          height: 24,
          width: 24,
          child: Image.asset(
            'assets/images/Home/超值路线@3x.png',
          ),
        ),
        Gaps.hGap10,
        const Text('超值路线',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConfig.textBlack)),
      ],
    ),
  );
}
