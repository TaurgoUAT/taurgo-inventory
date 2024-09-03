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

class DiningRoom extends StatefulWidget {
  final List<File>? capturedImages;

  const DiningRoom({super.key, this.capturedImages});

  @override
  State<DiningRoom> createState() => _DiningRoomState();
}

class _DiningRoomState extends State<DiningRoom> {
  String? gasMeterCondition;
  String? gasMeterLocation;
  String? electricMeterCondition;
  String? electricMeterLocation;
  String? waterMeterCondition;
  String? waterMeterLocation;
  String? oilMeterCondition;
  String? oilMeterLocation;
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
      gasMeterCondition = prefs.getString('gasMeterCondition');
      gasMeterLocation = prefs.getString('gasMeterLocation');
      electricMeterCondition = prefs.getString('electricMeterCondition');
      electricMeterLocation = prefs.getString('electricMeterLocation');
      waterMeterCondition = prefs.getString('waterMeterCondition');
      waterMeterLocation = prefs.getString('waterMeterLocation');
      oilMeterCondition = prefs.getString('oilMeterCondition');
      oilMeterLocation = prefs.getString('oilMeterLocation');
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
          'Dining Room',
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
              // Gas Meter
              ConditionItem(
                name: "Gas Meter",
                condition: gasMeterCondition,
                location: gasMeterLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    gasMeterCondition = condition;
                  });
                  _savePreference('gasMeterCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    gasMeterLocation = location;
                  });
                  _savePreference('gasMeterLocation', location); // Save preference
                },
              ),
              // Electric Meter
              ConditionItem(
                name: "Electric Meter",
                condition: electricMeterCondition,
                location: electricMeterLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    electricMeterCondition = condition;
                  });
                  _savePreference('electricMeterCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    electricMeterLocation = location;
                  });
                  _savePreference('electricMeterLocation', location); // Save preference
                },
              ),
              // Water Meter
              ConditionItem(
                name: "Water Meter",
                condition: waterMeterCondition,
                location: waterMeterLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    waterMeterCondition = condition;
                  });
                  _savePreference('waterMeterCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    waterMeterLocation = location;
                  });
                  _savePreference('waterMeterLocation', location); // Save preference
                },
              ),
              // Oil Meter
              ConditionItem(
                name: "Oil Meter",
                condition: oilMeterCondition,
                location: oilMeterLocation,
                onConditionSelected: (condition) {
                  setState(() {
                    oilMeterCondition = condition;
                  });
                  _savePreference('oilMeterCondition', condition); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    oilMeterLocation = location;
                  });
                  _savePreference('oilMeterLocation', location); // Save preference
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
          SizedBox(height: 12,),
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