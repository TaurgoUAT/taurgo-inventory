import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HexagonLoadingWidget extends StatelessWidget {
  final Color color;
  final double size;

  // Constructor to accept custom color and size if needed
  const HexagonLoadingWidget({
    Key? key,
    this.color = Colors.blue, // Default color
    this.size = 100.0,        // Default size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: color,
        size: size,
      ),
    );
  }
}
