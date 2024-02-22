import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:flutter/material.dart';

class HollowButton extends StatefulWidget {
  const HollowButton({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.borderRadis = 999,
    this.padding,
    this.visualDensity,
    this.borderWidth = 1,
    this.textFontWeight = FontWeight.w500,
    this.borderColor = AppColors.primary,
    this.textColor = AppColors.primary,
    this.onPressed,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final double borderRadis;
  final double borderWidth;
  final Color borderColor;
  final Color textColor;
  final FontWeight textFontWeight;
  final Function? onPressed;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  @override
  State<HollowButton> createState() => _PlainButtonState();
}

class _PlainButtonState extends State<HollowButton> {
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
        visualDensity: widget.visualDensity ?? VisualDensity.standard,
        padding: MaterialStateProperty.all(
            widget.padding ?? EdgeInsets.symmetric(horizontal: 15.w)),
        side: MaterialStateProperty.all(
          BorderSide(color: widget.borderColor, width: widget.borderWidth),
        ),
      ),
      child: AppText(
        str: widget.text.ts,
        fontSize: widget.fontSize,
        color: widget.textColor,
        fontWeight: widget.textFontWeight,
      ),
    );
  }
}
