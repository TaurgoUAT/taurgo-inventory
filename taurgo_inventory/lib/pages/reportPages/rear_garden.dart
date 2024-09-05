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

class RearGarden extends StatefulWidget {
  final List<File>? capturedImages;

  const RearGarden({super.key, this.capturedImages});

  @override
  State<RearGarden> createState() => _RearGardenState();
}

class _RearGardenState extends State<RearGarden> {
  String? gardenDescription;
  String? outsideLighting;
  String? summerHouse;
  String? shed;
  String? additionalInformation;
  List<String> gardenDescriptionImages = [];
  List<String> outsideLightingImages = [];
  List<String> summerHouseImages = [];
  List<String> shedImages = [];
  List<String> additionalInformationImages = [];
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
      gardenDescription = prefs.getString('gardenDescription');
      outsideLighting = prefs.getString('outsideLighting');
      summerHouse = prefs.getString('summerHouse');
      shed = prefs.getString('shed');
      additionalInformation = prefs.getString('additionalInformation');

      gardenDescriptionImages = prefs.getStringList('gardenDescriptionImages') ?? [];
      outsideLightingImages = prefs.getStringList('outsideLightingImages') ?? [];
      summerHouseImages = prefs.getStringList('summerHouseImages') ?? [];
      shedImages = prefs.getStringList('shedImages') ?? [];
      additionalInformationImages = prefs.getStringList('additionalInformationImages') ?? [];
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
          'Rear Garden',
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
                builder: (context) => EditReportPage(propertyId: '',),
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
              // Garden Description
              ConditionItem(
                name: "Garden Description",
                condition: gardenDescription,
                description: gardenDescription,
                images: gardenDescriptionImages,
                onConditionSelected: (condition) {
                  setState(() {
                    gardenDescription = condition;
                  });
                  _savePreference('gardenDescription', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    gardenDescription = description;
                  });
                  _savePreference('gardenDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    gardenDescriptionImages.add(imagePath);
                  });
                  _savePreferenceList('gardenDescriptionImages', gardenDescriptionImages); // Save preference
                },
              ),

              // Outside Lighting
              ConditionItem(
                name: "Outside Lighting",
                condition: outsideLighting,
                description: outsideLighting,
                images: outsideLightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    outsideLighting = condition;
                  });
                  _savePreference('outsideLighting', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    outsideLighting = description;
                  });
                  _savePreference('outsideLighting', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    outsideLightingImages.add(imagePath);
                  });
                  _savePreferenceList('outsideLightingImages', outsideLightingImages); // Save preference
                },
              ),

              // Summer House
              ConditionItem(
                name: "Summer House",
                condition: summerHouse,
                description: summerHouse,
                images: summerHouseImages,
                onConditionSelected: (condition) {
                  setState(() {
                    summerHouse = condition;
                  });
                  _savePreference('summerHouse', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    summerHouse = description;
                  });
                  _savePreference('summerHouse', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    summerHouseImages.add(imagePath);
                  });
                  _savePreferenceList('summerHouseImages', summerHouseImages); // Save preference
                },
              ),

              // Shed
              ConditionItem(
                name: "Shed",
                condition: shed,
                description: shed,
                images: shedImages,
                onConditionSelected: (condition) {
                  setState(() {
                    shed = condition;
                  });
                  _savePreference('shed', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    shed = description;
                  });
                  _savePreference('shed', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    shedImages.add(imagePath);
                  });
                  _savePreferenceList('shedImages', shedImages); // Save preference
                },
              ),

              // Additional Information
              ConditionItem(
                name: "Additional Information",
                condition: additionalInformation,
                description: additionalInformation,
                images: additionalInformationImages,
                onConditionSelected: (condition) {
                  setState(() {
                    additionalInformation = condition;
                  });
                  _savePreference('additionalInformation', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    additionalInformation = description;
                  });
                  _savePreference('additionalInformation', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalInformationImages.add(imagePath);
                  });
                  _savePreferenceList('additionalInformationImages', additionalInformationImages); // Save preference
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