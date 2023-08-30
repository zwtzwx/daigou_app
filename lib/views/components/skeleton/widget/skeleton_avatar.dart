import 'package:flutter/material.dart';

class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFFF5F5F5),
      ),
    );
  }
}
