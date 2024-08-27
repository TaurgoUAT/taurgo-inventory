import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';

import '../../constants/AppColors.dart';
import '../landing_screen.dart';

class ScheduleOfCondition extends StatefulWidget {
  const ScheduleOfCondition({super.key});

  @override
  State<ScheduleOfCondition> createState() => _ScheduleOfConditionState();
}

class _ScheduleOfConditionState extends State<ScheduleOfCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report', // Replace with the actual location
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 14, // Adjust the font size
            fontFamily: "Inter",
          ),
        ),
        centerTitle: true,
        backgroundColor: bWhite,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditReportPage()), // Replace HomePage with your home page widget
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24, // Adjust the icon size
          ),
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                '', // Replace with the actual location
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 14, // Adjust the font size
                  fontFamily: "Inter",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

