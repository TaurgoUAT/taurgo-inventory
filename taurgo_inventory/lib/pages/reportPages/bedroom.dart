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

class Bedroom extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Bedroom({super.key, this.capturedImages, required this.propertyId});

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
  String? doorImage;
  String? doorFrameImage;
  String? ceilingImage;
  String? lightingImage;
  String? wallsImage;
  String? skirtingImage;
  String? windowSillImage;
  String? curtainsImage;
  String? blindsImage;
  String? lightSwitchesImage;
  String? socketsImage;
  String? flooringImage;
  String? additionalItemsImage;
  List<String> doorImages = [];
  List<String> doorFrameImages = [];
  List<String> ceilingImages = [];
  List<String> lightingImages = [];
  List<String> wallsImages = [];
  List<String> skirtingImages = [];
  List<String> windowSillImages = [];
  List<String> curtainsImages = [];
  List<String> blindsImages = [];
  List<String> lightSwitchesImages = [];
  List<String> socketsImages = [];
  List<String> flooringImages = [];
  List<String> additionalItemsImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doorLocation = prefs.getString('doorLocation_${propertyId}');
      doorCondition = prefs.getString('doorCondition_${propertyId}');
      doorFrameLocation = prefs.getString('doorFrameLocation_${propertyId}');
      doorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      ceilingLocation = prefs.getString('ceilingLocation_${propertyId}');
      ceilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      lightingLocation = prefs.getString('lightingLocation_${propertyId}');
      lightingCondition = prefs.getString('lightingCondition_${propertyId}');
      wallsLocation = prefs.getString('wallsLocation_${propertyId}');
      wallsCondition = prefs.getString('wallsCondition_${propertyId}');
      skirtingLocation = prefs.getString('skirtingLocation_${propertyId}');
      skirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      windowSillLocation = prefs.getString('windowSillLocation_${propertyId}');
      windowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      curtainsLocation = prefs.getString('curtainsLocation_${propertyId}');
      curtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      blindsLocation = prefs.getString('blindsLocation_${propertyId}');
      blindsCondition = prefs.getString('blindsCondition_${propertyId}');
      lightSwitchesLocation = prefs.getString('lightSwitchesLocation_${propertyId}');
      lightSwitchesCondition = prefs.getString('lightSwitchesCondition_${propertyId}');
      socketsLocation = prefs.getString('socketsLocation_${propertyId}');
      socketsCondition = prefs.getString('socketsCondition_${propertyId}');
      flooringLocation = prefs.getString('flooringLocation_${propertyId}');
      flooringCondition = prefs.getString('flooringCondition_${propertyId}');
      additionalItemsLocation = prefs.getString('additionalItemsLocation_${propertyId}');
      additionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      doorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      doorFrameImages = prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      ceilingImages = prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      lightingImages = prefs.getStringList('lightingImages_${propertyId}') ?? [];
      wallsImages = prefs.getStringList('wallsImages_${propertyId}') ?? [];
      skirtingImages = prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      windowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      curtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      blindsImages = prefs.getStringList('blindsImages_${propertyId}') ?? [];
      lightSwitchesImages = prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      socketsImages = prefs.getStringList('socketsImages_${propertyId}') ?? [];
      flooringImages = prefs.getStringList('flooringImages_${propertyId}') ?? [];
      additionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String propertyId, String key, String value)
  async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${key}_$propertyId', value);
  }

  Future<void> _savePreferenceList(String propertyId, String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('${key}_$propertyId', value);
  }

  @override
  Widget build(BuildContext context) {
     String propertyId = widget.propertyId;
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
              // Door
              ConditionItem(
                name: "Door",
                location: doorLocation,
                condition: doorCondition,
                images: doorImages,
                onlocationSelected: (location) {
                  setState(() {
                    doorLocation = location;
                  });
                  _savePreference(propertyId,'doorLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference(
                      propertyId,'doorCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'doorImages', doorImages); // Save preference
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                location: doorFrameLocation,
                condition: doorFrameCondition,
                images: doorFrameImages,
                onlocationSelected: (location) {
                  setState(() {
                    doorFrameLocation = location;
                  });
                  _savePreference(
                      propertyId,'doorFrameLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrameCondition = condition;
                  });
                  _savePreference(
                      propertyId,'doorFrameCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'doorFrameImages', doorFrameImages); // Save preference
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                location: ceilingLocation,
                condition: ceilingCondition,
                images: ceilingImages,
                onlocationSelected: (location) {
                  setState(() {
                    ceilingLocation = location;
                  });
                  _savePreference(
                      propertyId,'ceilingLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference(
                      propertyId,'ceilingCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'ceilingImages', ceilingImages); // Save preference
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                location: lightingLocation,
                condition: lightingCondition,
                images: lightingImages,
                onlocationSelected: (location) {
                  setState(() {
                    lightingLocation = location;
                  });
                  _savePreference(
                     propertyId, 'lightingLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference(
                      propertyId,'lightingCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'lightingImages', lightingImages); // Save preference
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                location: wallsLocation,
                condition: wallsCondition,
                images: wallsImages,
                onlocationSelected: (location) {
                  setState(() {
                    wallsLocation = location;
                  });
                  _savePreference(
                      propertyId,'wallsLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'wallsCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    wallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                     propertyId, 'wallsImages', wallsImages); // Save preference
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                location: skirtingLocation,
                condition: skirtingCondition,
                images: skirtingImages,
                onlocationSelected: (location) {
                  setState(() {
                    skirtingLocation = location;
                  });
                  _savePreference(
                      propertyId,'skirtingLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference(
                      propertyId,'skirtingCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    skirtingImages.add(imagePath);
                  });
                  _savePreferenceList(
                     propertyId, 'skirtingImages', skirtingImages); // Save preference
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                location: windowSillLocation,
                condition: windowSillCondition,
                images: windowSillImages,
                onlocationSelected: (location) {
                  setState(() {
                    windowSillLocation = location;
                  });
                  _savePreference(
                      propertyId,'windowSillLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference(
                      propertyId,'windowSillCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowSillImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'windowSillImages', windowSillImages); // Save preference
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                location: curtainsLocation,
                condition: curtainsCondition,
                images: curtainsImages,
                onlocationSelected: (location) {
                  setState(() {
                    curtainsLocation = location;
                  });
                  _savePreference(
                      propertyId,'curtainsLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'curtainsCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    curtainsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'curtainsImages', curtainsImages); // Save preference
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                location: blindsLocation,
                condition: blindsCondition,
                images: blindsImages,
                onlocationSelected: (location) {
                  setState(() {
                    blindsLocation = location;
                  });
                  _savePreference(
                     propertyId, 'blindsLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'blindsCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    blindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'blindsImages', blindsImages); // Save preference
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                location: lightSwitchesLocation,
                condition: lightSwitchesCondition,
                images: lightSwitchesImages,
                onlocationSelected: (location) {
                  setState(() {
                    lightSwitchesLocation = location;
                  });
                  _savePreference(
                      propertyId,'lightSwitchesLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    lightSwitchesCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'lightSwitchesCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'lightSwitchesImages',
                      lightSwitchesImages); // Save preference
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                location: socketsLocation,
                condition: socketsCondition,
                images: socketsImages,
                onlocationSelected: (location) {
                  setState(() {
                    socketsLocation = location;
                  });
                  _savePreference(
                    propertyId,  'socketsLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    socketsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'socketsCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    socketsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'socketsImages', socketsImages); // Save preference
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                location: flooringLocation,
                condition: flooringCondition,
                images: flooringImages,
                onlocationSelected: (location) {
                  setState(() {
                    flooringLocation = location;
                  });
                  _savePreference(
                     propertyId, 'flooringLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference(
                      propertyId,'flooringCondition', condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    flooringImages.add(imagePath);
                  });
                  _savePreferenceList(
                     propertyId, 'flooringImages', flooringImages); // Save preference
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                location: additionalItemsLocation,
                condition: additionalItemsCondition,
                images: additionalItemsImages,
                onlocationSelected: (location) {
                  setState(() {
                    additionalItemsLocation = location;
                  });
                  _savePreference(
                     propertyId, 'additionalItemsLocation', location!); // Save preference
                },
                onConditionSelected: (condition) {
                  setState(() {
                    additionalItemsCondition = condition;
                  });
                  _savePreference(propertyId,'additionalItemsCondition',
                      condition!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'additionalItemsImages',
                      additionalItemsImages); // Save preference
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
  final List<String> images;
  final Function(String?) onlocationSelected;
  final Function(String?) onConditionSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
    this.condition,
    required this.images,
    required this.onlocationSelected,
    required this.onConditionSelected,
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