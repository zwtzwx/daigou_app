import 'package:flutter/material.dart';

class SkeletonAnimation {
  late AnimationController _controller;
  late Animation<double> animation;

  SkeletonAnimation(TickerProvider provider) {
    _controller = AnimationController(
        vsync: provider, duration: const Duration(seconds: 1));
    animation = Tween<double>(begin: -1, end: 2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.repeat();
  }

  void dispose() {
    _controller.dispose();
  }
}
