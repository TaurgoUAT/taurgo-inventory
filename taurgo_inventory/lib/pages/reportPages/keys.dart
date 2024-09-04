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

class Keys extends StatefulWidget {
  final List<File>? capturedImages;

  const Keys({super.key, this.capturedImages});

  @override
  State<Keys> createState() => _KeysState();
}

class _KeysState extends State<Keys> {
  String? yaleLocation;
  String? yaleReading;
  String? morticeLocation;
  String? morticeReading;
  String? windowLockLocation;
  String? windowLockReading;
  String? gasMeterLocation;
  String? gasMeterReading;
  String? carPassLocation;
  String? carPassReading;
  String? remoteLocation;
  String? remoteReading;
  String? otherLocation;
  String? otherReading;
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
      yaleLocation = prefs.getString('yaleLocation');
      yaleReading = prefs.getString('yaleReading');
      morticeLocation = prefs.getString('morticeLocation');
      morticeReading = prefs.getString('morticeReading');
      windowLockLocation = prefs.getString('windowLockLocation');
      windowLockReading = prefs.getString('windowLockReading');
      gasMeterLocation = prefs.getString('gasMeterLocation');
      gasMeterReading = prefs.getString('gasMeterReading');
      carPassLocation = prefs.getString('carPassLocation');
      carPassReading = prefs.getString('carPassReading');
      remoteLocation = prefs.getString('remoteLocation');
      remoteReading = prefs.getString('remoteReading');
      otherLocation = prefs.getString('otherLocation');
      otherReading = prefs.getString('otherReading');
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
          'Keys',
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
              // Yale
              ConditionItem(
                name: "Yale",
                location: yaleLocation,
                reading: yaleReading,
                onLocationSelected: (location) {
                  setState(() {
                    yaleLocation = location;
                  });
                  _savePreference('yaleLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    yaleReading = reading;
                  });
                  _savePreference('yaleReading', reading); // Save preference
                },
              ),

              // Mortice
              ConditionItem(
                name: "Mortice",
                location: morticeLocation,
                reading: morticeReading,
                onLocationSelected: (location) {
                  setState(() {
                    morticeLocation = location;
                  });
                  _savePreference(
                      'morticeLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    morticeReading = reading;
                  });
                  _savePreference('morticeReading', reading); // Save preference
                },
              ),

              // Window Lock
              ConditionItem(
                name: "Window Lock",
                location: windowLockLocation,
                reading: windowLockReading,
                onLocationSelected: (location) {
                  setState(() {
                    windowLockLocation = location;
                  });
                  _savePreference(
                      'windowLockLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    windowLockReading = reading;
                  });
                  _savePreference(
                      'windowLockReading', reading); // Save preference
                },
              ),

              // Gas Meter
              ConditionItem(
                name: "Gas Meter",
                location: gasMeterLocation,
                reading: gasMeterReading,
                onLocationSelected: (location) {
                  setState(() {
                    gasMeterLocation = location;
                  });
                  _savePreference(
                      'gasMeterLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    gasMeterReading = reading;
                  });
                  _savePreference(
                      'gasMeterReading', reading); // Save preference
                },
              ),

              // Car Pass
              ConditionItem(
                name: "Car Pass",
                location: carPassLocation,
                reading: carPassReading,
                onLocationSelected: (location) {
                  setState(() {
                    carPassLocation = location;
                  });
                  _savePreference(
                      'carPassLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    carPassReading = reading;
                  });
                  _savePreference('carPassReading', reading); // Save preference
                },
              ),

              // Remote
              ConditionItem(
                name: "Remote",
                location: remoteLocation,
                reading: remoteReading,
                onLocationSelected: (location) {
                  setState(() {
                    remoteLocation = location;
                  });
                  _savePreference(
                      'remoteLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    remoteReading = reading;
                  });
                  _savePreference('remoteReading', reading); // Save preference
                },
              ),

              // Other
              ConditionItem(
                name: "Other",
                location: otherLocation,
                reading: otherReading,
                onLocationSelected: (location) {
                  setState(() {
                    otherLocation = location;
                  });
                  _savePreference('otherLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    otherReading = reading;
                  });
                  _savePreference('otherReading', reading); // Save preference
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
  final String? reading;
  final Function(String?) onLocationSelected;
  final Function(String?) onReadingSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
    this.reading,
    required this.onLocationSelected,
    required this.onReadingSelected,
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
              location?.isNotEmpty == true ? location! : "Location",
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
                    initialCondition: reading,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onReadingSelected(result);
              }
            },
            child: Text(
              reading?.isNotEmpty == true ? reading! : "Reading",
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
