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

class UtilityRoom extends StatefulWidget {
  final List<File>? capturedImages;

  const UtilityRoom({super.key, this.capturedImages});

  @override
  State<UtilityRoom> createState() => _UtilityRoomState();
}

class _UtilityRoomState extends State<UtilityRoom> {
  String? newdoor;
  String? doorCondition;
  String? doorDescription;
  String? doorFrameCondition;
  String? doorFrameDescription;
  String? ceilingCondition;
  String? ceilingDescription;
  String? lightingCondition;
  String? lightingDescription;
  String? wallsCondition;
  String? wallsDescription;
  String? skirtingCondition;
  String? skirtingDescription;
  String? windowSillCondition;
  String? windowSillDescription;
  String? curtainsCondition;
  String? curtainsDescription;
  String? blindsCondition;
  String? blindsDescription;
  String? lightSwitchesCondition;
  String? lightSwitchesDescription;
  String? socketsCondition;
  String? socketsDescription;
  String? flooringCondition;
  String? flooringDescription;
  String? additionalItemsCondition;
  String? additionalItemsDescription;
  String? doorImagePath;
  String? doorFrameImagePath;
  String? ceilingImagePath;
  String? lightingImagePath;
  String? wallsImagePath;
  String? skirtingImagePath;
  String? windowSillImagePath;
  String? curtainsImagePath;
  String? blindsImagePath;
  String? lightSwitchesImagePath;
  String? socketsImagePath;
  String? flooringImagePath;
  String? additionalItemsImagePath;
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
      newdoor = prefs.getString('newdoor');
      doorCondition = prefs.getString('doorCondition');
      doorDescription = prefs.getString('doorDescription');
      doorFrameCondition = prefs.getString('doorFrameCondition');
      doorFrameDescription = prefs.getString('doorFrameDescription');
      ceilingCondition = prefs.getString('ceilingCondition');
      ceilingDescription = prefs.getString('ceilingDescription');
      lightingCondition = prefs.getString('lightingCondition');
      lightingDescription = prefs.getString('lightingDescription');
      wallsCondition = prefs.getString('wallsCondition');
      wallsDescription = prefs.getString('wallsDescription');
      skirtingCondition = prefs.getString('skirtingCondition');
      skirtingDescription = prefs.getString('skirtingDescription');
      windowSillCondition = prefs.getString('windowSillCondition');
      windowSillDescription = prefs.getString('windowSillDescription');
      curtainsCondition = prefs.getString('curtainsCondition');
      curtainsDescription = prefs.getString('curtainsDescription');
      blindsCondition = prefs.getString('blindsCondition');
      blindsDescription = prefs.getString('blindsDescription');
      lightSwitchesCondition = prefs.getString('lightSwitchesCondition');
      lightSwitchesDescription = prefs.getString('lightSwitchesDescription');
      socketsCondition = prefs.getString('socketsCondition');
      socketsDescription = prefs.getString('socketsDescription');
      flooringCondition = prefs.getString('flooringCondition');
      flooringDescription = prefs.getString('flooringDescription');
      additionalItemsCondition = prefs.getString('additionalItemsCondition');
      additionalItemsDescription =
          prefs.getString('additionalItemsDescription');
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
          'Utility Room',
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
                description: newdoor,
                images: doorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference('doorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    newdoor = description;
                  });
                  _savePreference('newdoor', description!);
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
                description: doorFrameDescription,
                images: doorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrameCondition = condition;
                  });
                  _savePreference(
                      'doorFrameCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorFrameDescription = description;
                  });
                  _savePreference(
                      'doorFrameDescription', description!); // Save preference
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
                description: ceilingDescription,
                images: ceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference(
                      'ceilingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    ceilingDescription = description;
                  });
                  _savePreference(
                      'ceilingDescription', description!); // Save preference
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
                description: lightingDescription,
                images: lightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference(
                      'lightingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    lightingDescription = description;
                  });
                  _savePreference(
                      'lightingDescription', description!); // Save preference
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
                description: wallsDescription,
                images: wallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference(
                      'wallsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    wallsDescription = description;
                  });
                  _savePreference(
                      'wallsDescription', description!); // Save preference
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
                description: skirtingDescription,
                images: skirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference(
                      'skirtingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    skirtingDescription = description;
                  });
                  _savePreference(
                      'skirtingDescription', description!); // Save preference
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
                description: windowSillDescription,
                images: windowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference(
                      'windowSillCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    windowSillDescription = description;
                  });
                  _savePreference(
                      'windowSillDescription', description!); // Save preference
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
                description: curtainsDescription,
                images: curtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference(
                      'curtainsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    curtainsDescription = description;
                  });
                  _savePreference(
                      'curtainsDescription', description!); // Save preference
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
                description: blindsDescription,
                images: blindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference(
                      'blindsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    blindsDescription = description;
                  });
                  _savePreference(
                      'blindsDescription', description!); // Save preference
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
                description: lightSwitchesDescription,
                images: lightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    lightSwitchesCondition = condition;
                  });
                  _savePreference(
                      'lightSwitchesCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    lightSwitchesDescription = description;
                  });
                  _savePreference('lightSwitchesDescription',
                      description!); // Save preference
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
                description: socketsDescription,
                images: socketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    socketsCondition = condition;
                  });
                  _savePreference(
                      'socketsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    socketsDescription = description;
                  });
                  _savePreference(
                      'socketsDescription', description!); // Save preference
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
                description: flooringDescription,
                images: flooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference(
                      'flooringCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    flooringDescription = description;
                  });
                  _savePreference(
                      'flooringDescription', description!); // Save preference
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
                description: additionalItemsDescription,
                images: additionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    additionalItemsCondition = condition;
                  });
                  _savePreference(
                      'additionalItemsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    additionalItemsDescription = description;
                  });
                  _savePreference('additionalItemsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'additionalItemsImages', additionalItemsImages);
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