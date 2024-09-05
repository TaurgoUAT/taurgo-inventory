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

class EntranceHallway extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const EntranceHallway({super.key, this.capturedImages, required this.propertyId});

  @override
  State<EntranceHallway> createState() => _EntranceHallwayState();
}

class _EntranceHallwayState extends State<EntranceHallway> {
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
  String? doorImagePaths;
  String? doorFrameImagePaths;
  String? ceilingImagePaths;
  String? lightingImagePaths;
  String? wallsImagePaths;
  String? skirtingImagePaths;
  String? windowSillImagePaths;
  String? curtainsImagePaths;
  String? blindsImagePaths;
  String? lightSwitchesImagePaths;
  String? socketsImagePaths;
  String? flooringImagePaths;
  String? additionalItemsImagePaths;

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
      doorCondition = prefs.getString('doorCondition_${propertyId}');
      doorLocation = prefs.getString('doorLocation_${propertyId}');
      doorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      doorFrameLocation = prefs.getString('doorFrameLocation_${propertyId}');
      ceilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      ceilingLocation = prefs.getString('ceilingLocation_${propertyId}');
      lightingCondition = prefs.getString('lightingCondition_${propertyId}');
      lightingLocation = prefs.getString('lightingLocation_${propertyId}');
      wallsCondition = prefs.getString('wallsCondition_${propertyId}');
      wallsLocation = prefs.getString('wallsLocation_${propertyId}');
      skirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      skirtingLocation = prefs.getString('skirtingLocation_${propertyId}');
      windowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      windowSillLocation = prefs.getString('windowSillLocation_${propertyId}');
      curtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      curtainsLocation = prefs.getString('curtainsLocation_${propertyId}');
      blindsCondition = prefs.getString('blindsCondition_${propertyId}');
      blindsLocation = prefs.getString('blindsLocation_${propertyId}');
      lightSwitchesCondition = prefs.getString('lightSwitchesCondition_${propertyId}');
      lightSwitchesLocation = prefs.getString('lightSwitchesLocation_${propertyId}');
      socketsCondition = prefs.getString('socketsCondition_${propertyId}');
      socketsLocation = prefs.getString('socketsLocation_${propertyId}');
      flooringCondition = prefs.getString('flooringCondition_${propertyId}');
      flooringLocation = prefs.getString('flooringLocation_${propertyId}');
      additionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      additionalItemsLocation = prefs.getString('additionalItemsLocation_${propertyId}');

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
                condition: doorCondition,
                location: doorLocation,
                images: doorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference(
                      propertyId,'doorCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    doorLocation = location;
                  });
                  _savePreference(propertyId,'doorLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorImages', doorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: doorFrameCondition,
                location: doorFrameLocation,
                images: doorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrameCondition = condition;
                  });
                  _savePreference(
                      propertyId,'doorFrameCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    doorFrameLocation = location;
                  });
                  _savePreference(
                      propertyId,'doorFrameLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorFrameImages', doorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: ceilingCondition,
                location: ceilingLocation,
                images: ceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'ceilingCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    ceilingLocation = location;
                  });
                  _savePreference(
                      propertyId,'ceilingLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ceilingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'ceilingImages', ceilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: lightingCondition,
                location: lightingLocation,
                images: lightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference(
                      propertyId,'lightingCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    lightingLocation = location;
                  });
                  _savePreference(
                      propertyId,'lightingLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'lightingImages', lightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: wallsCondition,
                location: wallsLocation,
                images: wallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'wallsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    wallsLocation = location;
                  });
                  _savePreference(propertyId,'wallsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    wallsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'wallsImages', wallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: skirtingCondition,
                location: skirtingLocation,
                images: skirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'skirtingCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    skirtingLocation = location;
                  });
                  _savePreference(
                     propertyId, 'skirtingLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    skirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'skirtingImages', skirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: windowSillCondition,
                location: windowSillLocation,
                images: windowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'windowSillCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    windowSillLocation = location;
                  });
                  _savePreference(
                     propertyId, 'windowSillLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'windowSillImages', windowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: curtainsCondition,
                location: curtainsLocation,
                images: curtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'curtainsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    curtainsLocation = location;
                  });
                  _savePreference(
                      propertyId,'curtainsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    curtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'curtainsImages', curtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: blindsCondition,
                location: blindsLocation,
                images: blindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'blindsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    blindsLocation = location;
                  });
                  _savePreference(
                      propertyId,'blindsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    blindsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'blindsImages', blindsImages);
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: lightSwitchesCondition,
                location: lightSwitchesLocation,
                images: lightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    lightSwitchesCondition = condition;
                  });
                  _savePreference(
                     propertyId, 'lightSwitchesCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    lightSwitchesLocation = location;
                  });
                  _savePreference(
                      propertyId,'lightSwitchesLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(
                     propertyId, 'lightSwitchesImages', lightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: socketsCondition,
                location: socketsLocation,
                images: socketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    socketsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'socketsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    socketsLocation = location;
                  });
                  _savePreference(
                     propertyId, 'socketsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    socketsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'socketsImages', socketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: flooringCondition,
                location: flooringLocation,
                images: flooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference(
                    propertyId,  'flooringCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    flooringLocation = location;
                  });
                  _savePreference(
                     propertyId, 'flooringLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    flooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'flooringImages', flooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: additionalItemsCondition,
                location: additionalItemsLocation,
                images: additionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    additionalItemsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'additionalItemsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    additionalItemsLocation = location;
                  });
                  _savePreference(
                     propertyId, 'additionalItemsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'additionalItemsImages', additionalItemsImages);
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
  final List<String> images;
  final Function(String?) onConditionSelected;
  final Function(String?) onLocationSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.location,
    required this.images,
    required this.onConditionSelected,
    required this.onLocationSelected,
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
