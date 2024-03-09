import 'package:flutter/material.dart';
import 'package:shop_app_client/views/components/skeleton/skeleton_decoration.dart';

class SkeletonRect extends StatelessWidget {
  const SkeletonRect({
    Key? key,
    required this.width,
    required this.height,
    this.radius,
    this.decoration,
  }) : super(key: key);
  final double width;
  final double height;
  final double? radius;
  final SkeletonDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration,
    );
  }
}
