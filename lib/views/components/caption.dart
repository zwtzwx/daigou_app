import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/color_config.dart';

class AppText extends StatelessWidget {
  const AppText(
      {Key? key,
      this.str = "",
      this.color = AppStyles.textBlack,
      this.fontSize = 15,
      this.fontWeight = FontWeight.w400,
      this.lines = 1,
      this.lineHeight,
      this.decoration,
      this.alignment = TextAlign.left})
      : super(key: key);

  final String str;
  final int lines;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign alignment;
  final TextDecoration? decoration;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      style: TextStyle(
        color: color,
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        decoration: decoration,
        height: lineHeight,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: lines,
      textAlign: alignment,
    );
  }
}
