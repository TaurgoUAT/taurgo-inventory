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

class Bedroom extends StatefulWidget {
  final List<File>? capturedImages;

  const Bedroom({super.key, this.capturedImages});

  @override
  State<Bedroom> createState() => _BedroomState();
}

class _BedroomState extends State<Bedroom> {
  String? doorLocation;
  String? doorCondition;
  String? doorFrameLocation;
  String? doorFrameCondition;
  String? ceilingLocation;
  String? ceilingCondition;
  String? lightingLocation;
  String? lightingCondition;
  String? wallsLocation;
  String? wallsCondition;
  String? skirtingLocation;
  String? skirtingCondition;
  String? windowSillLocation;
  String? windowSillCondition;
  String? curtainsLocation;
  String? curtainsCondition;
  String? blindsLocation;
  String? blindsCondition;
  String? lightSwitchesLocation;
  String? lightSwitchesCondition;
  String? socketsLocation;
  String? socketsCondition;
  String? flooringLocation;
  String? flooringCondition;
  String? additionalItemsLocation;
  String? additionalItemsCondition;
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
      doorLocation = prefs.getString('doorLocation');
      doorCondition = prefs.getString('doorCondition');
      doorFrameLocation = prefs.getString('doorFrameLocation');
      doorFrameCondition = prefs.getString('doorFrameCondition');
      ceilingLocation = prefs.getString('ceilingLocation');
      ceilingCondition = prefs.getString('ceilingCondition');
      lightingLocation = prefs.getString('lightingLocation');
      lightingCondition = prefs.getString('lightingCondition');
      wallsLocation = prefs.getString('wallsLocation');
      wallsCondition = prefs.getString('wallsCondition');
      skirtingLocation = prefs.getString('skirtingLocation');
      skirtingCondition = prefs.getString('skirtingCondition');
      windowSillLocation = prefs.getString('windowSillLocation');
      windowSillCondition = prefs.getString('windowSillCondition');
      curtainsLocation = prefs.getString('curtainsLocation');
      curtainsCondition = prefs.getString('curtainsCondition');
      blindsLocation = prefs.getString('blindsLocation');
      blindsCondition = prefs.getString('blindsCondition');
      lightSwitchesLocation = prefs.getString('lightSwitchesLocation');
      lightSwitchesCondition = prefs.getString('lightSwitchesCondition');
      socketsLocation = prefs.getString('socketsLocation');
      socketsCondition = prefs.getString('socketsCondition');
      flooringLocation = prefs.getString('flooringLocation');
      flooringCondition = prefs.getString('flooringCondition');
      additionalItemsLocation = prefs.getString('additionalItemsLocation');
      additionalItemsCondition = prefs.getString('additionalItemsCondition');
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
              // Door
              ConditionItem(
                name: "Door",
                location: doorLocation,
                condition: doorCondition,
                onLocationSelected: (location) {
                  setState(() {
                    doorLocation = location;
                  });
                  _savePreference('doorLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference('doorCondition', condition); // Save preference
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                location: doorFrameLocation,
                condition: doorFrameCondition,
                onLocationSelected: (location) {
                  setState(() {
                    doorFrameLocation = location;
                  });
                  _savePreference('doorFrameLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrameCondition = condition;
                  });
                  _savePreference('doorFrameCondition', condition); // Save preference
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                location: ceilingLocation,
                condition: ceilingCondition,
                onLocationSelected: (location) {
                  setState(() {
                    ceilingLocation = location;
                  });
                  _savePreference('ceilingLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference('ceilingCondition', condition); // Save preference
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                location: lightingLocation,
                condition: lightingCondition,
                onLocationSelected: (location) {
                  setState(() {
                    lightingLocation = location;
                  });
                  _savePreference('lightingLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference('lightingCondition', condition); // Save preference
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                location: wallsLocation,
                condition: wallsCondition,
                onLocationSelected: (location) {
                  setState(() {
                    wallsLocation = location;
                  });
                  _savePreference('wallsLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference('wallsCondition', condition); // Save preference
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                location: skirtingLocation,
                condition: skirtingCondition,
                onLocationSelected: (location) {
                  setState(() {
                    skirtingLocation = location;
                  });
                  _savePreference('skirtingLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference('skirtingCondition', condition); // Save preference
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                location: windowSillLocation,
                condition: windowSillCondition,
                onLocationSelected: (location) {
                  setState(() {
                    windowSillLocation = location;
                  });
                  _savePreference('windowSillLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference('windowSillCondition', condition); // Save preference
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                location: curtainsLocation,
                condition: curtainsCondition,
                onLocationSelected: (location) {
                  setState(() {
                    curtainsLocation = location;
                  });
                  _savePreference('curtainsLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference('curtainsCondition', condition); // Save preference
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                location: blindsLocation,
                condition: blindsCondition,
                onLocationSelected: (location) {
                  setState(() {
                    blindsLocation = location;
                  });
                  _savePreference('blindsLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference('blindsCondition', condition); // Save preference
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                location: lightSwitchesLocation,
                condition: lightSwitchesCondition,
                onLocationSelected: (location) {
                  setState(() {
                    lightSwitchesLocation = location;
                  });
                  _savePreference('lightSwitchesLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    lightSwitchesCondition = condition;
                  });
                  _savePreference('lightSwitchesCondition', condition); // Save preference
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                location: socketsLocation,
                condition: socketsCondition,
                onLocationSelected: (location) {
                  setState(() {
                    socketsLocation = location;
                  });
                  _savePreference('socketsLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    socketsCondition = condition;
                  });
                  _savePreference('socketsCondition', condition); // Save preference
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                location: flooringLocation,
                condition: flooringCondition,
                onLocationSelected: (location) {
                  setState(() {
                    flooringLocation = location;
                  });
                  _savePreference('flooringLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference('flooringCondition', condition); // Save preference
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                location: additionalItemsLocation,
                condition: additionalItemsCondition,
                onLocationSelected: (location) {
                  setState(() {
                    additionalItemsLocation = location;
                  });
                  _savePreference('additionalItemsLocation', location); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    additionalItemsCondition = condition;
                  });
                  _savePreference('additionalItemsCondition', condition); // Save preference
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
  final String? location;
  final String? condition;
  final Function(String?) onLocationSelected;
  final Function(String?) onConditionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
    this.condition,
    required this.onLocationSelected,
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
                    initialCondition: location,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onLocationSelected(result);
              }
            },
            child: Text(
              location ?? "Location",
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
                    initialCondition: condition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              condition ?? "Condition",
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