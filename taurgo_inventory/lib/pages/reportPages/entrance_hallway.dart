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

class EntranceHallway extends StatefulWidget {
  final List<File>? capturedImages;

  const EntranceHallway({super.key, this.capturedImages});

  @override
  State<EntranceHallway> createState() => _EnsuiteState();
}

class _EnsuiteState extends State<EntranceHallway> {
  String? doorCondition;
  String? doorLocation;
  String? doorFrameCondition;
  String? doorFrameLocation;
  String? ceilingCondition;
  String? ceilingLocation;
  String? lightingCondition;
  String? lightingLocation;
  String? wallsCondition;
  String? wallsLocation;
  String? skirtingCondition;
  String? skirtingLocation;
  String? windowSillCondition;
  String? windowSillLocation;
  String? curtainsCondition;
  String? curtainsLocation;
  String? blindsCondition;
  String? blindsLocation;
  String? lightSwitchesCondition;
  String? lightSwitchesLocation;
  String? socketsCondition;
  String? socketsLocation;
  String? flooringCondition;
  String? flooringLocation;
  String? additionalItemsCondition;
  String? additionalItemsLocation;
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
      doorCondition = prefs.getString('doorCondition');
      doorLocation = prefs.getString('doorLocation');
      doorFrameCondition = prefs.getString('doorFrameCondition');
      doorFrameLocation = prefs.getString('doorFrameLocation');
      ceilingCondition = prefs.getString('ceilingCondition');
      ceilingLocation = prefs.getString('ceilingLocation');
      lightingCondition = prefs.getString('lightingCondition');
      lightingLocation = prefs.getString('lightingLocation');
      wallsCondition = prefs.getString('wallsCondition');
      wallsLocation = prefs.getString('wallsLocation');
      skirtingCondition = prefs.getString('skirtingCondition');
      skirtingLocation = prefs.getString('skirtingLocation');
      windowSillCondition = prefs.getString('windowSillCondition');
      windowSillLocation = prefs.getString('windowSillLocation');
      curtainsCondition = prefs.getString('curtainsCondition');
      curtainsLocation = prefs.getString('curtainsLocation');
      blindsCondition = prefs.getString('blindsCondition');
      blindsLocation = prefs.getString('blindsLocation');
      lightSwitchesCondition = prefs.getString('lightSwitchesCondition');
      lightSwitchesLocation = prefs.getString('lightSwitchesLocation');
      socketsCondition = prefs.getString('socketsCondition');
      socketsLocation = prefs.getString('socketsLocation');
      flooringCondition = prefs.getString('flooringCondition');
      flooringLocation = prefs.getString('flooringLocation');
      additionalItemsCondition = prefs.getString('additionalItemsCondition');
      additionalItemsLocation = prefs.getString('additionalItemsLocation');
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
          'Entrance Hallway',
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
                condition: doorCondition,
                location: doorLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference('doorCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    doorLocation = location;
                  });
                  _savePreference('doorLocation', location); // Save preference
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: doorFrameCondition,
                location: doorFrameLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrameCondition = condition;
                  });
                  _savePreference('doorFrameCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    doorFrameLocation = location;
                  });
                  _savePreference('doorFrameLocation', location); // Save preference
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: ceilingCondition,
                location: ceilingLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference('ceilingCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    ceilingLocation = location;
                  });
                  _savePreference('ceilingLocation', location); // Save preference
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: lightingCondition,
                location: lightingLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference('lightingCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    lightingLocation = location;
                  });
                  _savePreference('lightingLocation', location); // Save preference
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: wallsCondition,
                location: wallsLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference('wallsCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    wallsLocation = location;
                  });
                  _savePreference('wallsLocation', location); // Save preference
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: skirtingCondition,
                location: skirtingLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference('skirtingCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    skirtingLocation = location;
                  });
                  _savePreference('skirtingLocation', location); // Save preference
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: windowSillCondition,
                location: windowSillLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference('windowSillCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    windowSillLocation = location;
                  });
                  _savePreference('windowSillLocation', location); // Save preference
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: curtainsCondition,
                location: curtainsLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference('curtainsCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    curtainsLocation = location;
                  });
                  _savePreference('curtainsLocation', location); // Save preference
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: blindsCondition,
                location: blindsLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference('blindsCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    blindsLocation = location;
                  });
                  _savePreference('blindsLocation', location); // Save preference
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: lightSwitchesCondition,
                location: lightSwitchesLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    lightSwitchesCondition = condition;
                  });
                  _savePreference('lightSwitchesCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    lightSwitchesLocation = location;
                  });
                  _savePreference('lightSwitchesLocation', location); // Save preference
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: socketsCondition,
                location: socketsLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    socketsCondition = condition;
                  });
                  _savePreference('socketsCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    socketsLocation = location;
                  });
                  _savePreference('socketsLocation', location); // Save preference
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: flooringCondition,
                location: flooringLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference('flooringCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    flooringLocation = location;
                  });
                  _savePreference('flooringLocation', location); // Save preference
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: additionalItemsCondition,
                location: additionalItemsLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    additionalItemsCondition = condition;
                  });
                  _savePreference('additionalItemsCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    additionalItemsLocation = location;
                  });
                  _savePreference('additionalItemsLocation', location); // Save preference
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConditionItem extends StatelessWidget {
  final String name;
  final String? condition;
  final String? location;
  final Function(String?) onConditionSelected;
  final Function(String?) onLocationSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.location,
    required this.onConditionSelected,
    required this.onLocationSelected,
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
          SizedBox(height: 12,),
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
              condition?.isNotEmpty == true ? condition! : "Condition",
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
              location?.isNotEmpty == true ? location! : "Description",
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
