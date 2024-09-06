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
  final List<File>? diningCapturedImages;
  final String propertyId;
  const DiningRoom(
      {super.key, this.diningCapturedImages, required this.propertyId});

  @override
  State<DiningRoom> createState() => _DiningRoomState();
}

class _DiningRoomState extends State<DiningRoom> {
  String? diningGasMeterCondition;
  String? diningGasMeterLocation;
  String? diningElectricMeterCondition;
  String? diningElectricMeterLocation;
  String? diningWaterMeterCondition;
  String? diningWaterMeterLocation;
  String? diningOilMeterCondition;
  String? diningOilMeterLocation;
  List<String> diningGasMeterImages = [];
  List<String> diningElectricMeterImages = [];
  List<String> diningWaterMeterImages = [];
  List<String> diningOilMeterImages = [];
  late List<File> diningCapturedImages;

  @override
  void initState() {
    super.initState();
    diningCapturedImages = widget.diningCapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      diningGasMeterCondition =
          prefs.getString('diningGasMeterCondition_${propertyId}');
      diningGasMeterLocation =
          prefs.getString('diningGasMeterLocation_${propertyId}');
      diningElectricMeterCondition =
          prefs.getString('diningElectricMeterCondition_${propertyId}');
      diningElectricMeterLocation =
          prefs.getString('diningElectricMeterLocation_${propertyId}');
      diningWaterMeterCondition =
          prefs.getString('diningWaterMeterCondition_${propertyId}');
      diningWaterMeterLocation =
          prefs.getString('diningWaterMeterLocation_${propertyId}');
      diningOilMeterCondition =
          prefs.getString('diningOilMeterCondition_${propertyId}');
      diningOilMeterLocation =
          prefs.getString('diningOilMeterLocation_${propertyId}');
      diningGasMeterImages =
          prefs.getStringList('diningGasMeterImages_${propertyId}') ?? [];
      diningElectricMeterImages =
          prefs.getStringList('diningElectricMeterImages_${propertyId}') ?? [];
      diningWaterMeterImages =
          prefs.getStringList('diningWaterMeterImages_${propertyId}') ?? [];
      diningOilMeterImages =
          prefs.getStringList('diningOilMeterImages_${propertyId}') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(
      String propertyId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${key}_$propertyId', value);
  }

  Future<void> _savePreferenceList(
      String propertyId, String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('${key}_$propertyId', value);
  }

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;
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
                builder: (context) => EditReportPage(
                  propertyId: '',
                ),
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
                condition: diningGasMeterCondition,
                location: diningGasMeterLocation,
                images: diningGasMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    diningGasMeterCondition = condition;
                  });
                  _savePreference(propertyId, 'diningGasMeterCondition',
                      condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    diningGasMeterLocation = location;
                  });
                  _savePreference(propertyId, 'diningGasMeterLocation',
                      location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    diningGasMeterImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'diningGasMeterImages',
                      diningGasMeterImages); // Save preference
                },
              ),
              // Electric Meter
              ConditionItem(
                name: "Electric Meter",
                condition: diningElectricMeterCondition,
                location: diningElectricMeterLocation,
                images: diningElectricMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    diningElectricMeterCondition = condition;
                  });
                  _savePreference(propertyId, 'diningElectricMeterCondition',
                      condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    diningElectricMeterLocation = location;
                  });
                  _savePreference(propertyId, 'diningElectricMeterLocation',
                      location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    diningElectricMeterImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'diningElectricMeterImages',
                      diningElectricMeterImages); // Save preference
                },
              ),
              // Water Meter
              ConditionItem(
                name: "Water Meter",
                condition: diningWaterMeterCondition,
                location: diningWaterMeterLocation,
                images: diningWaterMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    diningWaterMeterCondition = condition;
                  });
                  _savePreference(propertyId, 'diningWaterMeterCondition',
                      condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    diningWaterMeterLocation = location;
                  });
                  _savePreference(propertyId, 'diningWaterMeterLocation',
                      location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    diningWaterMeterImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'diningWaterMeterImages',
                      diningWaterMeterImages); // Save preference
                },
              ),
              // Oil Meter
              ConditionItem(
                name: "Oil Meter",
                condition: diningOilMeterCondition,
                location: diningOilMeterLocation,
                images: diningOilMeterImages,
                onConditionSelected: (condition) {
                  setState(() {
                    diningOilMeterCondition = condition;
                  });
                  _savePreference(propertyId, 'diningOilMeterCondition',
                      condition!); // Save preference
                },
                onlocationSelected: (location) {
                  setState(() {
                    diningOilMeterLocation = location;
                  });
                  _savePreference(propertyId, 'diningOilMeterLocation',
                      location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    diningOilMeterImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'diningOilMeterImages',
                      diningOilMeterImages); // Save preference
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
