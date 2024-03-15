import 'package:flutter/material.dart';

/// 绘制虚线
/// direction  Axis.horizontal，Axis.vertical 横线竖线
/// height 高度
/// width  长度
/// color  颜色
class DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final Axis direction;

  const DottedLine({
    this.height = 1,
    this.color = Colors.black,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWidth : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
        );
      },
    );
  }
}