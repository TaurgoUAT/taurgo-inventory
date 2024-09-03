import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/bathroom.dart';

import '../../constants/AppColors.dart';

class EntranceHallway extends StatefulWidget {
  final List<File>? capturedImages;

  const EntranceHallway({super.key, this.capturedImages});

  @override
  State<EntranceHallway> createState() => _EntranceHallwayState();
}

class _EntranceHallwayState extends State<EntranceHallway> {
  String? door;
  String? doorFrame;
  String? doorBell;
  String? ceiling;
  String? lighting;
  String? walls;
  String? skirting;
  String? windowSill;
  String? curtains;
  String? blinds;
  String? lightSwitches;
  String? sockets;
  String? heating;
  String? flooring;
  String? additionalItems;
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    _loadPreferences(); // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      door = prefs.getString('gasMeter');
      doorFrame = prefs.getString('electricMeter');
      doorBell = prefs.getString('waterMeter');
      ceiling = prefs.getString('waterMeter');
      lighting = prefs.getString('oilMeter');
      walls = prefs.getString('other');
      skirting = prefs.getString('other');
      windowSill = prefs.getString('other');
      curtains = prefs.getString('other');
      blinds = prefs.getString('other');
      lightSwitches = prefs.getString('other');
      sockets = prefs.getString('other');
      heating = prefs.getString('other');
      flooring = prefs.getString('other');
      additionalItems = prefs.getString('other');
      ;
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Entrance',
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditReportPage(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Gas Meter
              ConditionItem(
                name: "Door",
                selectedCondition: door,
                onConditionSelected: (condition) {
                  setState(() {
                    door = condition;
                  });
                  _savePreference('door', condition); // Save preference
                },
              ),

              //Electric Meter
              ConditionItem(
                name: "Door Frame",
                selectedCondition: doorFrame,
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrame = condition;
                  });
                  _savePreference('doorFrame', condition); // Save preference
                },
              ),

              //Door Bell
              ConditionItem(
                name: "Door Bell",
                selectedCondition: doorBell,
                onConditionSelected: (condition) {
                  setState(() {
                    doorBell = condition;
                  });
                  _savePreference('doorBell', condition); // Save preference
                },
              ),

              //Water Meter
              ConditionItem(
                name: "Ceiling",
                selectedCondition: ceiling,
                onConditionSelected: (condition) {
                  setState(() {
                    ceiling = condition;
                  });
                  _savePreference('ceiling', condition); // Save preference
                },
              ),

              //Oil Meter
              ConditionItem(
                name: "Lighting",
                selectedCondition: lighting,
                onConditionSelected: (condition) {
                  setState(() {
                    lighting = condition;
                  });
                  _savePreference('lighting', condition); // Save preference
                },
              ),

              //Walls
              ConditionItem(
                name: "Walls",
                selectedCondition: walls,
                onConditionSelected: (condition) {
                  setState(() {
                    walls = condition;
                  });
                  _savePreference('walls', condition); // Save preference
                },
              ),

              //Skirting
              ConditionItem(
                name: "Skirting",
                selectedCondition: skirting,
                onConditionSelected: (condition) {
                  setState(() {
                    skirting = condition;
                  });
                  _savePreference('skirting', condition); // Save preference
                },
              ),

              //Window Sill
              ConditionItem(
                name: "Window Sill",
                selectedCondition: windowSill,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSill = condition;
                  });
                  _savePreference('windowSill', condition); // Save preference
                },
              ),

              //Curtains
              ConditionItem(
                name: "Curtains",
                selectedCondition: curtains,
                onConditionSelected: (condition) {
                  setState(() {
                    curtains = condition;
                  });
                  _savePreference('curtains', condition); // Save preference
                },
              ),

              //Blinds
              ConditionItem(
                name: "Blinds",
                selectedCondition: blinds,
                onConditionSelected: (condition) {
                  setState(() {
                    blinds = condition;
                  });
                  _savePreference('blinds', condition); // Save preference
                },
              ),

              //Light Switches
              ConditionItem(
                name: "Light Switches",
                selectedCondition: lightSwitches,
                onConditionSelected: (condition) {
                  setState(() {
                    lightSwitches = condition;
                  });
                  _savePreference(
                      'lightSwitches', condition); // Save preference
                },
              ),

              //Sockets
              ConditionItem(
                name: "Sockets",
                selectedCondition: sockets,
                onConditionSelected: (condition) {
                  setState(() {
                    sockets = condition;
                  });
                  _savePreference('sockets', condition); // Save preference
                },
              ),

              //Heating
              ConditionItem(
                name: "Heating",
                selectedCondition: heating,
                onConditionSelected: (condition) {
                  setState(() {
                    heating = condition;
                  });
                  _savePreference('heating', condition); // Save preference
                },
              ),

              //Flooring
              ConditionItem(
                name: "Flooring",
                selectedCondition: flooring,
                onConditionSelected: (condition) {
                  setState(() {
                    flooring = condition;
                  });
                  _savePreference('flooring', condition); // Save preference
                },
              ),

              //Additional Items
              ConditionItem(
                name: "Additional Items",
                selectedCondition: additionalItems,
                onConditionSelected: (condition) {
                  setState(() {
                    additionalItems = condition;
                  });
                  _savePreference(
                      'additionalItems', condition); // Save preference
                },
              ),

              //Other Condition Items can be added similarly
            ],
          ),
        ),
      ),
    );
  }
}
