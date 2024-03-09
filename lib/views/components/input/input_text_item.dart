import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';

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
      this.bgColor,
      this.alignment = CrossAxisAlignment.center,
      this.addedWidget,
      this.height = 45})
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
  final Color? bgColor;
  final Widget? addedWidget;

  @override
  _InputTextItemState createState() => _InputTextItemState();
}

class _InputTextItemState extends State<InputTextItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.h,
      padding: (widget.padding is EdgeInsets)
          ? widget.padding
          : const EdgeInsets.all(0),
      margin: (widget.margin is EdgeInsets)
          ? widget.margin
          : EdgeInsets.only(left: 14.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.bgColor ?? AppStyles.white,
        border: Border(
          bottom: widget.flag
              ? const BorderSide(color: AppStyles.line)
              : BorderSide.none,
        ),
      ),
      child: Row(
        crossAxisAlignment: widget.alignment,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: widget.leftFlex,
            child: Row(
              children: [
                widget.isRequired
                    ? const AppText(
                        str: '*',
                        color: AppStyles.textRed,
                      )
                    : AppGaps.empty,
                Flexible(
                  child: AppText(
                    str: (widget.title).inte,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: widget.rightFlex,
            child: Container(
              padding: EdgeInsets.only(
                left: 10.w,
              ),
              child: widget.inputText,
            ),
          ),
          if (widget.addedWidget != null) widget.addedWidget!
        ],
      ),
    );
  }
}
