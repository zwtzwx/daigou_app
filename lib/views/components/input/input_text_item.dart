import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:flutter/material.dart';

class InputTextItem extends StatefulWidget {
  const InputTextItem(
      {Key? key,
      required this.title,
      required this.inputText,
      this.padding,
      this.flag = true,
      this.margin,
      this.leftFlex = 1,
      this.rightFlex = 3,
      this.height = 55.0})
      : super(key: key);

  final String title;
  final bool flag;
  final int leftFlex;
  final int rightFlex;
  final Widget inputText;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double height;

  @override
  _InputTextItemState createState() => _InputTextItemState();
}

class _InputTextItemState extends State<InputTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        padding: (widget.padding is EdgeInsets)
            ? widget.padding
            : const EdgeInsets.all(0),
        margin: (widget.margin is EdgeInsets)
            ? widget.margin
            : const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorConfig.white,
            border: Border(
              bottom: Divider.createBorderSide(context,
                  color: ColorConfig.line, width: widget.flag ? 1 : 0),
            )),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  flex: widget.leftFlex,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: Text(
                      widget.title,
                      style: TextConfig.textDark14,
                      textAlign: TextAlign.justify,
                    ),
                  )),
              Expanded(
                  flex: widget.rightFlex,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: widget.inputText,
                  ))
            ]));
  }
}
