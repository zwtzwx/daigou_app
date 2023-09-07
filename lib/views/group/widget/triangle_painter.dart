import 'package:flutter/material.dart';

class TrianglePainer extends CustomPainter {
  TrianglePainer({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  final Color strokeColor;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;
    canvas.drawPath(getPath(size.width, size.height), paint);
  }

  Path getPath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
