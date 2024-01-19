import 'package:flutter/material.dart';
import 'package:huanting_shop/views/components/skeleton/skeleton_animation.dart';

class SkeletonDecoration extends BoxDecoration {
  SkeletonDecoration({
    SkeletonAnimation? animation,
    double borderRadius = 5,
  }) : super(
          color: animation == null ? const Color(0xFFF5F5F5) : null,
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: animation != null
              ? LinearGradient(
                  colors: const [
                    Color(0xfff6f7f9),
                    Color(0xffeaebed),
                    Color(0xfff6f7f9)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    animation.animation.value - 1,
                    animation.animation.value,
                    animation.animation.value + 1,
                  ])
              : null,
        );
}
