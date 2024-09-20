import 'package:flutter/material.dart';


class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blueAccent;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.5); // Start at mid height
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.7, size.width, size.height * 0.5); // Curve path
    path.lineTo(size.width, 0); // Line to top right corner
    path.lineTo(0, 0); // Line to top left corner
    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}