import 'package:flutter/material.dart';
import 'dart:math';

import 'package:taurgo_inventory/constants/AppColors.dart';

class DottedCirclePainter extends CustomPainter {
  final double progress;
  DottedCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = kPrimaryColor // Set the color to your primary color
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;
    int dotCount = 30; // Number of dots

    for (int i = 0; i < dotCount; i++) {
      double angle = 2 * pi * (i / dotCount) + 2 * pi * progress;
      double x = radius + radius * cos(angle);
      double y = radius + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), 3.0, paint); // Set the size of the dots
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}