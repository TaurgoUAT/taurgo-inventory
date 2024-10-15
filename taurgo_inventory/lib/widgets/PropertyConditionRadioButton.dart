import 'package:flutter/material.dart';

class PropertyConditionRadioButton extends StatelessWidget {
  final String title;
  final String? selectedCondition;
  final Function(String?) onChanged;
  final Color primaryColor;
  final List<String> conditions;

  PropertyConditionRadioButton({
    required this.selectedCondition,
    required this.onChanged,
    required this.primaryColor,
    this.conditions = const [
      'Good',
      'Fair',
      "Poor",
    ],
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Row(
            children: conditions.map((condition) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: condition,
                    groupValue: selectedCondition,
                    onChanged: onChanged,
                    activeColor: primaryColor,
                  ),
                  Text(condition),
                  SizedBox(width: 8), // Space between each radio button
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
