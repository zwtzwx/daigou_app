import 'package:flutter/material.dart';
import 'package:jiyun_app_client/config/color_config.dart';

class ZHTextLine extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ZHTextLine(
      {this.str = "",
      this.color = BaseStylesConfig.textBlack,
      this.fontSize = 15,
      this.fontWeight = FontWeight.w400,
      this.lines = 1,
      this.decoration,
      this.alignment = TextAlign.left});

  final String str;
  final int lines;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign alignment;
  final TextDecoration? decoration;

  @override
  ZHTextLineState createState() => ZHTextLineState();
}

class ZHTextLineState extends State<ZHTextLine> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.str,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        decoration: widget.decoration,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: widget.lines,
      textAlign: widget.alignment,
    );
  }
}
