import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.elevation = 0,
    this.borderRadis = 28,
    this.backgroundColor = ColorConfig.warningText,
    this.textColor = ColorConfig.textBlack,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final double fontSize;
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
      ),
      child: Caption(
        str: widget.text,
        color: widget.textColor,
        fontSize: widget.fontSize,
      ),
    );
  }
}
