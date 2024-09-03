import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import '../camera_preview_page.dart';

class Lounge extends StatefulWidget {
  final List<File>? capturedImages;

  const Lounge({super.key, this.capturedImages});

  @override
  State<Lounge> createState() => _LoungeState();
}

class _LoungeState extends State<Lounge> {
  String? door;
  String? doorFrame;
  String? ceiling;
  String? lighting;
  String? walls;
  String? skirting;
  String? windowSill;
  String? curtains;
  String? blinds;
  String? lightSwitches;
  String? sockets;
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
      door = prefs.getString('door');
      doorFrame = prefs.getString('doorFrame');
      ceiling = prefs.getString('ceiling');
      lighting = prefs.getString('lighting');
      walls = prefs.getString('walls');
      skirting = prefs.getString('skirting');
      windowSill = prefs.getString('windowSill');
      curtains = prefs.getString('curtains');
      blinds = prefs.getString('blinds');
      lightSwitches = prefs.getString('lightSwitches');
      sockets = prefs.getString('sockets');
      flooring = prefs.getString('flooring');
      additionalItems = prefs.getString('additionalItems');
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
          'Bed Room',
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

              // Add more ConditionItem widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}

class ConditionItem extends StatelessWidget {
  final String name;
  final String? selectedCondition;
  final Function(String?) onConditionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.selectedCondition,
    required this.onConditionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: kSecondaryTextColourTwo,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.warning_amber,
                      size: 24,
                      color: kAccentColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAction(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 24,
                      color: kSecondaryTextColourTwo,
                    ),
                    onPressed: () async {
                      // Initialize the camera when the button is pressed
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        final cameraController = CameraController(
                          cameras.first,
                          ResolutionPreset.high,
                        );
                        await cameraController.initialize();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPreviewPage(
                              cameraController: cameraController,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionDetails(
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Location",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryTextColourTwo,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionDetails(
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Serial Number",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryTextColourTwo,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionDetails(
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Reading",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryTextColourTwo,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Divider(thickness: 1, color: Color(0xFFC2C2C2)),
        ],
      ),
    );
  }
}
