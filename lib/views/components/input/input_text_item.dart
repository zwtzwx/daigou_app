import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/text_config.dart';
import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

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
      this.isRequired = false,
      this.alignment = CrossAxisAlignment.center,
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
  final bool isRequired;
  final CrossAxisAlignment alignment;

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
            crossAxisAlignment: widget.alignment,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  flex: widget.leftFlex,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Row(
                      children: [
                        widget.isRequired
                            ? const Caption(
                                str: '*',
                                color: ColorConfig.textRed,
                              )
                            : Gaps.empty,
                        Flexible(
                          child: Text(
                            Translation.t(context, widget.title),
                            style: TextConfig.textDark14,
                          ),
                        ),
                      ],
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
