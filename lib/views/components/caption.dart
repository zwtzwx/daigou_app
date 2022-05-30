import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';

class Caption extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Caption(
      {this.str = "",
      this.color = ColorConfig.textBlack,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w400,
      this.lines = 1,
      this.alignment = TextAlign.right});

  final String str;
  final int lines;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign alignment;

  @override
  CaptionState createState() => CaptionState();
}

class CaptionState extends State<Caption> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.str,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: widget.lines,
    );
  }
}
