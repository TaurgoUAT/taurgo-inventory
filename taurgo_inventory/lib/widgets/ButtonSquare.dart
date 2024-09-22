import 'package:flutter/material.dart';


class ButtonSquare extends StatelessWidget {
  final double width;
  final double height;
  final Color bgColor;
  final Color borderColor;
  final Widget childWidget;

  const ButtonSquare({
    super.key,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.borderColor,
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor,width: 2), // Apply border color
        borderRadius: BorderRadius.circular(10),

        // Optional: for rounded
        // corners
      ),
      child: Center(child: childWidget),
    );
  }
}
