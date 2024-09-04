import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

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
  String? gasMeterImagePath;
  String? electricMeterImagePath;
  String? waterMeterImagePath;
  String? oilMeterImagePath;
  List<String> gasMeterImages = [];
  List<String> electricMeterImages = [];
  List<String> waterMeterImages = [];
  List<String> oilMeterImages = [];
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
      gasMeterImages = prefs.getStringList('gasMeterImages') ?? [];
      electricMeterImages = prefs.getStringList('electricMeterImages') ?? [];
      waterMeterImages = prefs.getStringList('waterMeterImages') ?? [];
      oilMeterImages = prefs.getStringList('oilMeterImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> _savePreferenceList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
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
                images: gasMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    gasMeterCondition = condition;
                  });
                  _savePreference(
                      'gasMeterCondition', condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    gasMeterLocation = location;
                  });
                  _savePreference(
                      'gasMeterLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    gasMeterImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'gasMeterImages', gasMeterImages); // Save preference
                },
              ),
              // Electric Meter
              ConditionItem(
                name: "Electric Meter",
                condition: electricMeterCondition,
                location: electricMeterLocation,
                images: electricMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    electricMeterCondition = condition;
                  });
                  _savePreference(
                      'electricMeterCondition', condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    electricMeterLocation = location;
                  });
                  _savePreference(
                      'electricMeterLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    electricMeterImages.add(imagePath);
                  });
                  _savePreferenceList('electricMeterImages',
                      electricMeterImages); // Save preference
                },
              ),
              // Water Meter
              ConditionItem(
                name: "Water Meter",
                condition: waterMeterCondition,
                location: waterMeterLocation,
                images: waterMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    waterMeterCondition = condition;
                  });
                  _savePreference(
                      'waterMeterCondition', condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    waterMeterLocation = location;
                  });
                  _savePreference(
                      'waterMeterLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    waterMeterImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'waterMeterImages', waterMeterImages); // Save preference
                },
              ),
              // Oil Meter
              ConditionItem(
                name: "Oil Meter",
                condition: oilMeterCondition,
                location: oilMeterLocation,
                images: oilMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    oilMeterCondition = condition;
                  });
                  _savePreference(
                      'oilMeterCondition', condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    oilMeterLocation = location;
                  });
                  _savePreference(
                      'oilMeterLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    oilMeterImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'oilMeterImages', oilMeterImages); // Save preference
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
  final List<String> images;
  final Function(String?) onConditionSelected;
  final Function(String?) onlocationSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.location,
    required this.images,
    required this.onConditionSelected,
    required this.onlocationSelected,
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
                            builder: (context) => CameraPreviewPage(
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
                    initialCondition: location,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onlocationSelected(result);
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