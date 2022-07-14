import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.elevation = 0,
    this.borderRadis = 5,
    this.fontWeight = FontWeight.w400,
    this.backgroundColor = ColorConfig.primary,
    this.textColor = ColorConfig.white,
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
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
        elevation: MaterialStateProperty.all(widget.elevation),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadis),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: widget.backgroundColor),
        ),
      ),
      child: Caption(
        str: Translation.t(context, widget.text),
        color: widget.textColor,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        alignment: TextAlign.center,
        lines: 2,
      ),
    );
  }
}
