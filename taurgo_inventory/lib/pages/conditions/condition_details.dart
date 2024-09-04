import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import '../../constants/AppColors.dart';

class ConditionDetails extends StatefulWidget {
  final String? initialCondition;
  final String type;
  const ConditionDetails(
      {super.key, required this.initialCondition, required this.type});

  @override
  State<ConditionDetails> createState() => _ConditionDetailsState();
}

class _ConditionDetailsState extends State<ConditionDetails> {
  String selectedCondition = "Default Condition";
  late TextEditingController _detailsController;

  final List<String> overViewCondition = [
    'Good',
    'In Working Order',
    'Good Seasonal order',
    "In Good Clean Order",
    'All in Good, Working Order',
    'Good Clean Decorative Order',
    'Tested for Power Only. Audible Alarm Noted',
    'Tested for Power Only. Audible Alarm Noted, Managing Agent Advised',
    'Integrated Note Tested',
  ];

  final List<String> carpetsCondition = [
    'Good',
    'In Working Order',
    'Good Seasonal order',
    "In Good Clean Order",
    'All in Good, Working Order',
    'Good Clean Decorative Order',
    'Tested for Power Only. Audible Alarm Noted',
    'Tested for Power Only. Audible Alarm Noted, Managing Agent Advised',
    'Integrated Note Tested',
  ];

  final List<String> mattressCondition = [
    'Good',
    'In kjdsfhkjd Order',
    'Good Seasonal order',
    "In Good Clean Order",
    'All in Good, Working Order',
    'Good Clean Decorative Order',
    'Tested for Power Only. Audible Alarm Noted',
    'Tested for Power Only. Audible Alarm Noted, Managing Agent Advised',
    'Integrated Note Tested',
  ];

  List<String> getConditions() {
    switch (widget.type) {
      case 'Carpet':
        return carpetsCondition;
      case 'Mattress':
        return mattressCondition;
      default:
        return overViewCondition;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCondition = widget.initialCondition ?? getConditions().first;
    _detailsController = TextEditingController(text: selectedCondition);
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 14,
            fontFamily: "Inter",
          ),
        ),
        centerTitle: true,
        backgroundColor: bWhite,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, _detailsController.text);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, _detailsController.text);
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Save',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 14,
                  fontFamily: "Inter",
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Condition',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kPrimaryTextColourTwo,
              ),
            ),
            SizedBox(height: 6.0),
            // DropdownButton<String>(
            //   value: selectedCondition,
            //   items: getConditions().map((String condition) {
            //     return DropdownMenuItem<String>(
            //       value: condition,
            //       child: Text(condition),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedCondition = newValue!;
            //       _detailsController.text = newValue;
            //     });
            //   },
            //   isExpanded: true,
            //   underline: Container(
            //     height: 1,
            //     color: kPrimaryColor,
            //   ),
            //   dropdownColor: Colors.white,
            // ),
            SizedBox(height: 12.0),
            // Text(
            //   'Additional Details:',
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.bold,
            //     color: kPrimaryTextColourTwo,
            //   ),
            // ),
            SizedBox(height: 6),
            TextFormField(
              controller: _detailsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter any additional details here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: kPrimaryColor), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: kPrimaryColor), // Border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: kPrimaryColor), // Border color when enabled
                ),
              ),
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Save the selected condition and details
                  Navigator.pop(context, _detailsController.text);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
