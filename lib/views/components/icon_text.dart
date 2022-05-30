import 'package:flutter/material.dart';

/// icon text
class IconText extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final double? iconSize;
  final Axis? direction;

  /// icon padding
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const IconText(this.text,
      {Key? key,
      this.icon,
      this.iconSize,
      this.direction = Axis.horizontal,
      this.style,
      this.maxLines,
      this.softWrap,
      this.padding,
      this.textAlign,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _style = DefaultTextStyle.of(context).style.merge(style);
    if (icon == null) return Text(text ?? "", style: _style);
    if (text == null) return Padding(padding: padding!, child: icon);
    return RichText(
      text: TextSpan(style: _style, children: [
        WidgetSpan(
            child: IconTheme(
          data: IconThemeData(
              size: iconSize ??
                  (_style.fontSize == null ? 16 : _style.fontSize! + 1),
              color: _style.color == null ? null : _style.color!),
          child: (padding == null
              ? icon!
              : Padding(
                  padding: padding!,
                  child: icon!,
                )),
        )),
        TextSpan(text: direction == Axis.horizontal ? text : "\n$text"),
      ]),
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: textAlign ??
          (direction == Axis.horizontal ? TextAlign.start : TextAlign.center),
    );
  }
}
