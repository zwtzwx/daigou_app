import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/components/skeleton/widget/goods_skeleton.dart';
import 'package:shop_app_client/views/components/skeleton/widget/single_skeleton.dart';

enum SkeletonType { singleSkeleton, listSkeleton, goodsSkeleton }

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    required this.type,
    this.bgColor,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.showImg = false,
    this.isCircle = false,
    this.lineCount = 3,
    this.showShadow = false,
    this.itemCount,
    this.isAnimation = true,
    this.margin,
    this.scrollDirection,
  }) : super(key: key);
  final SkeletonType type;
  final Color? bgColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool showImg;
  final bool isCircle;
  final int lineCount;
  final bool showShadow;
  final int? itemCount;
  final bool isAnimation;
  final EdgeInsets? margin;
  final Axis? scrollDirection;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: getSkeleton(),
    );
  }

  Widget getSkeleton() {
    Widget skeleton;
    var singleSkeleton = type == SkeletonType.goodsSkeleton
        ? GoodsSkeleton(
            bgColor: bgColor,
            borderRadius: borderRadius,
            isAnimation: isAnimation,
            direction: scrollDirection ?? Axis.vertical,
          )
        : SingleSkeleton(
            bgColor: bgColor,
            width: width,
            height: height,
            borderRadius: borderRadius,
            showImg: showImg,
            isCircle: isCircle,
            lineCount: lineCount,
            showShadow: showShadow,
            isAnimation: isAnimation,
            margin: margin,
          );
    switch (type) {
      case SkeletonType.singleSkeleton:
      case SkeletonType.goodsSkeleton:
        skeleton = singleSkeleton;
        break;
      case SkeletonType.listSkeleton:
        skeleton = ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return singleSkeleton;
          },
          separatorBuilder: (context, index) {
            return 10.verticalSpaceFromWidth;
          },
          itemCount: itemCount ?? 2,
        );
        break;
      default:
        skeleton = const Offstage();
        break;
    }
    return skeleton;
  }
}
