import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huanting_shop/views/components/skeleton/skeleton_animation.dart';
import 'package:huanting_shop/views/components/skeleton/skeleton_decoration.dart';
import 'package:huanting_shop/views/components/skeleton/widget/skeleton_line.dart';
import 'package:huanting_shop/views/components/skeleton/widget/skeleton_rect.dart';

class GoodsSkeleton extends StatefulWidget {
  const GoodsSkeleton({
    Key? key,
    this.bgColor,
    this.width,
    this.height,
    required this.borderRadius,
    this.isAnimation = true,
    required this.direction,
  }) : super(key: key);
  final Color? bgColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isAnimation;
  final Axis direction;

  @override
  State<GoodsSkeleton> createState() => _GoodsSkeletonState();
}

class _GoodsSkeletonState extends State<GoodsSkeleton>
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
        builder: (context, child) => buildGoodsList(),
      );
    }
    return buildGoodsList();
  }

  Widget buildGoodsList() {
    if (widget.direction == Axis.vertical) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 7 / 11,
        ),
        itemBuilder: (context, index) => goodsItemCell((1.sw - 34.w) / 2),
      );
    } else {
      var width = (1.sw - 34.w) / 2.5;
      return Container(
        height: width * (11 / 7),
        margin: EdgeInsets.only(left: 12.w),
        child: ListView.builder(
          itemCount: 3,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => goodsItemCell(width),
        ),
      );
    }
  }

  Widget goodsItemCell(double width) {
    List<Widget> lines = [];
    for (var i = 0; i < 3; i++) {
      lines.add(
        SkeletonLine(
          width: width - width * ((i + 1) / 10),
          height: 8.h,
          margin:
              EdgeInsets.only(top: 7.h, left: 10.w, bottom: i == 2 ? 7.h : 0),
          decoration: SkeletonDecoration(
            animation: _animation,
          ),
        ),
      );
    }
    return Container(
      clipBehavior: Clip.none,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      width: widget.direction == Axis.horizontal ? width : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SkeletonRect(
              width: double.infinity,
              height: double.infinity,
              decoration: SkeletonDecoration(
                animation: _animation,
                borderRadius: 0,
              ),
            ),
          ),
          ...lines,
        ],
      ),
    );
  }
}
