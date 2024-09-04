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

class Ensuite extends StatefulWidget {
  final List<File>? capturedImages;

  const Ensuite({super.key, this.capturedImages});

  @override
  State<Ensuite> createState() => _EnsuiteState();
}

class _EnsuiteState extends State<Ensuite> {
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

      doorImages = prefs.getStringList('doorImages') ?? [];
      doorFrameImages = prefs.getStringList('doorFrameImages') ?? [];
      ceilingImages = prefs.getStringList('ceilingImages') ?? [];
      lightingImages = prefs.getStringList('lightingImages') ?? [];
      wallsImages = prefs.getStringList('wallsImages') ?? [];
      skirtingImages = prefs.getStringList('skirtingImages') ?? [];
      windowSillImages = prefs.getStringList('windowSillImages') ?? [];
      curtainsImages = prefs.getStringList('curtainsImages') ?? [];
      blindsImages = prefs.getStringList('blindsImages') ?? [];
      lightSwitchesImages = prefs.getStringList('lightSwitchesImages') ?? [];
      socketsImages = prefs.getStringList('socketsImages') ?? [];
      flooringImages = prefs.getStringList('flooringImages') ?? [];
      additionalItemsImages = prefs.getStringList('additionalItemsImages') ?? [];
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
          'Ensuite',
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
                images: doorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference('doorCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    doorLocation = location;
                  });
                  _savePreference('doorLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorImages.add(imagePath);
                  });
                  _savePreferenceList('doorImages', doorImages);
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
                  _savePreference('doorFrameCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    doorFrameLocation = location;
                  });
                  _savePreference('doorFrameLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorFrameImages.add(imagePath);
                  });
                  _savePreferenceList('doorFrameImages', doorFrameImages);
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
                  _savePreference('ceilingCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ceilingLocation = location;
                  });
                  _savePreference('ceilingLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ceilingImages.add(imagePath);
                  });
                  _savePreferenceList('ceilingImages', ceilingImages);
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
                  _savePreference('lightingCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    lightingLocation = location;
                  });
                  _savePreference('lightingLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightingImages.add(imagePath);
                  });
                  _savePreferenceList('lightingImages', lightingImages);
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
                  _savePreference('wallsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    wallsLocation = location;
                  });
                  _savePreference('wallsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    wallsImages.add(imagePath);
                  });
                  _savePreferenceList('wallsImages', wallsImages);
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
                  _savePreference('skirtingCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    skirtingLocation = location;
                  });
                  _savePreference('skirtingLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    skirtingImages.add(imagePath);
                  });
                  _savePreferenceList('skirtingImages', skirtingImages);
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
                  _savePreference('windowSillCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    windowSillLocation = location;
                  });
                  _savePreference('windowSillLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowSillImages.add(imagePath);
                  });
                  _savePreferenceList('windowSillImages', windowSillImages);
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
                  _savePreference('curtainsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    curtainsLocation = location;
                  });
                  _savePreference('curtainsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    curtainsImages.add(imagePath);
                  });
                  _savePreferenceList('curtainsImages', curtainsImages);
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
                  _savePreference('blindsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    blindsLocation = location;
                  });
                  _savePreference('blindsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    blindsImages.add(imagePath);
                  });
                  _savePreferenceList('blindsImages', blindsImages);
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
                  _savePreference('lightSwitchesCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    lightSwitchesLocation = location;
                  });
                  _savePreference('lightSwitchesLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList('lightSwitchesImages', lightSwitchesImages);
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
                  _savePreference('socketsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    socketsLocation = location;
                  });
                  _savePreference('socketsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    socketsImages.add(imagePath);
                  });
                  _savePreferenceList('socketsImages', socketsImages);
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
                  _savePreference('flooringCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    flooringLocation = location;
                  });
                  _savePreference('flooringLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    flooringImages.add(imagePath);
                  });
                  _savePreferenceList('flooringImages', flooringImages);
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
                  _savePreference('additionalItemsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    additionalItemsLocation = location;
                  });
                  _savePreference('additionalItemsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList('additionalItemsImages', additionalItemsImages);
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
                      // Initialize the camera when the button is pressed
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        final cameraController = CameraController(
                          cameras.first,
                          ResolutionPreset.high,
                        );
                        await cameraController.initialize();
                        final image = await cameraController.takePicture();
                        final imagePath = image.path;

                        // Save the image path using the provided callback
                        onImageAdded(imagePath);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
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
          SizedBox(height: 12),
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
          SizedBox(height: 12),
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