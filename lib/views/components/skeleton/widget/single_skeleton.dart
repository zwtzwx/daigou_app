import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton_animation.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton_decoration.dart';
import 'package:jiyun_app_client/views/components/skeleton/widget/skeleton_avatar.dart';
import 'package:jiyun_app_client/views/components/skeleton/widget/skeleton_line.dart';
import 'package:jiyun_app_client/views/components/skeleton/widget/skeleton_rect.dart';

class SingleSkeleton extends StatefulWidget {
  const SingleSkeleton({
    Key? key,
    this.bgColor,
    this.width,
    this.height,
    required this.borderRadius,
    required this.showImg,
    required this.isCircle,
    required this.lineCount,
    required this.showShadow,
    this.margin,
    this.isAnimation = true,
  }) : super(key: key);
  final Color? bgColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool showImg;
  final bool isCircle;
  final int lineCount;
  final bool showShadow;
  final bool isAnimation;
  final EdgeInsets? margin;

  @override
  State<SingleSkeleton> createState() => _SingleSkeletonState();
}

class _SingleSkeletonState extends State<SingleSkeleton>
    with SingleTickerProviderStateMixin {
  SkeletonAnimation? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimation) {
      _animation = SkeletonAnimation(this);
    }
  }

  @override
  void dispose() {
    if (_animation != null) {
      _animation!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAnimation) {
      return AnimatedBuilder(
        animation: _animation!.animation,
        builder: (context, child) => buildContaner(),
      );
    }
    return buildContaner();
  }

  Widget buildContaner() {
    if (widget.showShadow) {
      return Card(
        elevation: 5,
        child: cardContainerCell(),
      );
    }
    return cardContainerCell();
  }

  Widget cardContainerCell() {
    var width = widget.width ?? MediaQuery.of(context).size.width;
    var height = widget.height ?? MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: widget.showImg
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          widget.showImg
              ? imgPlaceholder((width - 30) * 0.2, height - 30)
              : const Offstage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: linesPlaceholder(
              (width - 30) * (widget.showImg ? 0.75 : 0.9),
              height - 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget imgPlaceholder(double width, double height) {
    if (widget.isCircle) {
      return SkeletonAvatar(width: width, height: height);
    }
    return SkeletonRect(
      width: width,
      height: height,
      decoration: SkeletonDecoration(
        animation: _animation,
      ),
    );
  }

  List<Widget> linesPlaceholder(double width, double height) {
    List<Widget> lineList = [];
    var singleLineHeight = min<double>(
        (height - (widget.lineCount - 1) * 8) / widget.lineCount, 8);
    for (var i = 0; i < widget.lineCount; i++) {
      lineList.add(
        SkeletonLine(
          width: width - width * (i * 0.1),
          height: singleLineHeight,
          decoration: SkeletonDecoration(
            borderRadius: 999,
            animation: _animation,
          ),
        ),
      );
    }
    return lineList;
  }
}
