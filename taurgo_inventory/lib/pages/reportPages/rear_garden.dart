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
  final List<File>? rearGardencapturedImages;
  final String propertyId;
  const RearGarden(
      {super.key, this.rearGardencapturedImages, required this.propertyId});

  @override
  State<RearGarden> createState() => _RearGardenState();
}

class _RearGardenState extends State<RearGarden> {
  String? reargardenDescription;
  String? rearGardenOutsideLighting;
  String? rearGardensummerHouse;
  String? rearGardenshed;
  String? rearGardenadditionalInformation;
  List<String> reargardenDescriptionImages = [];
  List<String> rearGardenOutsideLightingImages = [];
  List<String> rearGardensummerHouseImages = [];
  List<String> rearGardenshedImages = [];
  List<String> rearGardenadditionalInformationImages = [];
  late List<File> rearGardencapturedImages;

  @override
  void initState() {
    super.initState();
    rearGardencapturedImages = widget.rearGardencapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reargardenDescription =
          prefs.getString('reargardenDescription_${propertyId}');
      rearGardenOutsideLighting =
          prefs.getString('rearGardenOutsideLighting_${propertyId}');
      rearGardensummerHouse =
          prefs.getString('rearGardensummerHouse_${propertyId}');
      rearGardenshed = prefs.getString('rearGardenshed_${propertyId}');
      rearGardenadditionalInformation =
          prefs.getString('rearGardenadditionalInformation_${propertyId}');

      reargardenDescriptionImages =
          prefs.getStringList('reargardenDescriptionImages_${propertyId}') ??
              [];
      rearGardenOutsideLightingImages = prefs
              .getStringList('rearGardenOutsideLightingImages_${propertyId}') ??
          [];
      rearGardensummerHouseImages =
          prefs.getStringList('rearGardensummerHouseImages_${propertyId}') ??
              [];
      rearGardenshedImages =
          prefs.getStringList('rearGardenshedImages_${propertyId}') ?? [];
      rearGardenadditionalInformationImages = prefs.getStringList(
              'rearGardenadditionalInformationImages_${propertyId}') ??
          [];
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
              // Garden Description
              ConditionItem(
                name: "Garden Description",
                condition: reargardenDescription,
                description: reargardenDescription,
                images: reargardenDescriptionImages,
                onConditionSelected: (condition) {
                  setState(() {
                    reargardenDescription = condition;
                  });
                  _savePreference(propertyId, 'reargardenDescription',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    reargardenDescription = description;
                  });
                  _savePreference(propertyId, 'reargardenDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    reargardenDescriptionImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'reargardenDescriptionImages',
                      reargardenDescriptionImages); // Save preference
                },
              ),

              // Outside Lighting
              ConditionItem(
                name: "Outside Lighting",
                condition: rearGardenOutsideLighting,
                description: rearGardenOutsideLighting,
                images: rearGardenOutsideLightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    rearGardenOutsideLighting = condition;
                  });
                  _savePreference(propertyId, 'rearGardenOutsideLighting',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    rearGardenOutsideLighting = description;
                  });
                  _savePreference(propertyId, 'rearGardenOutsideLighting',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    rearGardenOutsideLightingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,
                      'rearGardenOutsideLightingImages',
                      rearGardenOutsideLightingImages); // Save preference
                },
              ),

              // Summer House
              ConditionItem(
                name: "Summer House",
                condition: rearGardensummerHouse,
                description: rearGardensummerHouse,
                images: rearGardensummerHouseImages,
                onConditionSelected: (condition) {
                  setState(() {
                    rearGardensummerHouse = condition;
                  });
                  _savePreference(propertyId, 'rearGardensummerHouse',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    rearGardensummerHouse = description;
                  });
                  _savePreference(propertyId, 'rearGardensummerHouse',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    rearGardensummerHouseImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'rearGardensummerHouseImages',
                      rearGardensummerHouseImages); // Save preference
                },
              ),

              // rearGardenShed
              ConditionItem(
                name: "rearGardenShed",
                condition: rearGardenshed,
                description: rearGardenshed,
                images: rearGardenshedImages,
                onConditionSelected: (condition) {
                  setState(() {
                    rearGardenshed = condition;
                  });
                  _savePreference(propertyId, 'rearGardenshed',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    rearGardenshed = description;
                  });
                  _savePreference(propertyId, 'rearGardenshed',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    rearGardenshedImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'rearGardenshedImages',
                      rearGardenshedImages); // Save preference
                },
              ),

              // Additional Information
              ConditionItem(
                name: "Additional Information",
                condition: rearGardenadditionalInformation,
                description: rearGardenadditionalInformation,
                images: rearGardenadditionalInformationImages,
                onConditionSelected: (condition) {
                  setState(() {
                    rearGardenadditionalInformation = condition;
                  });
                  _savePreference(propertyId, 'rearGardenadditionalInformation',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    rearGardenadditionalInformation = description;
                  });
                  _savePreference(propertyId, 'rearGardenadditionalInformation',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    rearGardenadditionalInformationImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,
                      'rearGardenadditionalInformationImages',
                      rearGardenadditionalInformationImages); // Save preference
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
