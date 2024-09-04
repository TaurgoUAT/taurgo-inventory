import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart' as reportPages;

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import '../camera_preview_page.dart';

class HealthAndSafety extends StatefulWidget {
  final List<File>? capturedImages;

  const HealthAndSafety({super.key, this.capturedImages});

  @override
  _HealthAndSafetyState createState() => _HealthAndSafetyState();
}

class _HealthAndSafetyState extends State<HealthAndSafety> {
  
  String? smokeAlarmCondition;
  String? smokeAlarmDescription;
  String? heatSensorCondition;
  String? heatSensorDescription;
  String? carbonMonoxideCondition;
  String? carbonMonoxideDescription;
  String? smokeAlarmImagePath;
  String? heatSensorImagePath;
  String? carbonMonxideImagePath;
  List<String> smokeAlarmImages = [];
  List<String> heatSensorImages = [];
  List<String> carbonMonxideImages = [];
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
      heatSensorCondition = prefs.getString('heatSensorCondition');
      heatSensorDescription = prefs.getString('heatSensorDescription');
      smokeAlarmCondition = prefs.getString('smokeAlarmCondition');
      smokeAlarmDescription = prefs.getString('smokeAlarmDescription');
      carbonMonoxideCondition = prefs.getString('carbonMonoxideCondition');
      carbonMonoxideDescription = prefs.getString('carbonMonoxideDescription');
      smokeAlarmImages = prefs.getStringList('smokeAlarmImages') ?? [];
      heatSensorImages = prefs.getStringList('heatSensorImages') ?? [];
      carbonMonxideImages = prefs.getStringList('carbonMonxideImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  // Function to save a list preference
  Future<void> _savePreferenceList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health and Safety',
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
                name: "Heat Sensor",
                condition: heatSensorCondition,
                description: heatSensorDescription,
                images: heatSensorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    heatSensorCondition = condition;
                  });
                  _savePreference(
                      'heatSensorCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatSensorDescription = description;
                  });
                  _savePreference('heatSensorDescription',
                      description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    heatSensorImages.add(imagePath);
                  });
                  _savePreferenceList('heatSensorImages',
                      heatSensorImages); // Save preference
                },
              ),

              // Mortice
              ConditionItem(
                name: "Smoke Alarm",
                condition: smokeAlarmCondition,
                description: smokeAlarmDescription,
                images: smokeAlarmImages,
                onConditionSelected: (condition) {
                  setState(() {
                    smokeAlarmCondition = condition;
                  });
                  _savePreference(
                      'smokeAlarmCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    smokeAlarmDescription = description;
                  });
                  _savePreference('smokeAlarmDescription',
                      description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    smokeAlarmImages.add(imagePath);
                  });
                  _savePreferenceList('smokeAlarmImages',
                      smokeAlarmImages); // Save preference
                },
              ),

              // Other
              ConditionItem(
                name: "Other",
                condition: carbonMonoxideCondition,
                description: carbonMonoxideDescription,
                images: carbonMonxideImages,
                onConditionSelected: (condition) {
                  setState(() {
                    carbonMonoxideCondition = condition;
                  });
                  _savePreference('carbonMonoxideCondition',
                      condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    carbonMonoxideDescription = description;
                  });
                  _savePreference('carbonMonoxideDescription',
                      description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    carbonMonxideImages.add(imagePath);
                  });
                  _savePreferenceList('carbonMonxideImages',
                      carbonMonxideImages); // Save preference
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
  final String? description;
  final List<String> images;
  final Function(String?) onConditionSelected;
  final Function(String?) onDescriptionSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.description,
    required this.images,
    required this.onConditionSelected,
    required this.onDescriptionSelected,
    required this.onImageAdded,
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
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => reportPages.CameraPreviewPage(
                              camera: cameras.first,
                              onPictureTaken: (imagePath) {
                                onImageAdded(imagePath);
                              },
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
                    initialCondition: description,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onDescriptionSelected(result);
              }
            },
            child: Text(
              description?.isNotEmpty == true ? description! : "Description",
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
          images.isNotEmpty
              ? Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: images.map((imagePath) {
                    return Image.file(
                      File(imagePath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                )
              : Text(
                  "No images selected",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryTextColourTwo,
                    fontStyle: FontStyle.italic,
                  ),
                ),
          Divider(thickness: 1, color: Color(0xFFC2C2C2)),
        ],
      ),
    );
  }
}