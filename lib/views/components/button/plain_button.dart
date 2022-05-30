import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';

class PlainButton extends StatefulWidget {
  const PlainButton({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.borderRadis = 28,
    this.borderColor = ColorConfig.textGrayC,
    this.textColor = ColorConfig.textBlack,
    this.onPressed,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final double borderRadis;
  final Color borderColor;
  final Color textColor;
  final Function? onPressed;
  @override
  State<PlainButton> createState() => _PlainButtonState();
}

class _PlainButtonState extends State<PlainButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadis),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: widget.borderColor),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Caption(
          str: widget.text,
          fontSize: widget.fontSize,
          color: widget.textColor,
        ),
      ),
    );
  }
}
