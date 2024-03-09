import 'package:flutter/material.dart';
import 'package:shop_app_client/views/components/skeleton/skeleton_decoration.dart';

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    Key? key,
    required this.width,
    required this.height,
    this.decoration,
    this.margin,
  }) : super(key: key);
  final double width;
  final double height;
  final EdgeInsets? margin;
  final SkeletonDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: decoration,
    );
  }
}
