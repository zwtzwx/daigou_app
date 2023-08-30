import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.elevation = 0,
    this.borderRadis = 5,
    this.fontWeight = FontWeight.w400,
    this.backgroundColor = BaseStylesConfig.primary,
    this.textColor = BaseStylesConfig.textDark,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double elevation;
  final double borderRadis;
  final Color backgroundColor;
  final Color textColor;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 70.w,
      ),
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          elevation: MaterialStateProperty.all(elevation),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadis),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: backgroundColor),
          ),
        ),
        child: ZHTextLine(
          str: text.ts,
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          alignment: TextAlign.center,
          lines: 2,
        ),
      ),
    );
  }
}
