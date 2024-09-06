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
  final List<File>? utilitycapturedImages;
  final String propertyId;
  const UtilityRoom(
      {super.key, this.utilitycapturedImages, required this.propertyId});

  @override
  State<UtilityRoom> createState() => _UtilityRoomState();
}

class _UtilityRoomState extends State<UtilityRoom> {
  String? utilityNewdoor;
  String? utilityDoorCondition;
  String? utilityDoorDescription;
  String? utilityDoorFrameCondition;
  String? utilityDoorFrameDescription;
  String? utilityCeilingCondition;
  String? utilityCeilingDescription;
  String? utilityLightingCondition;
  String? utilitylightingDescription;
  String? utilitywallsCondition;
  String? utilitywallsDescription;
  String? utilityskirtingCondition;
  String? utilityskirtingDescription;
  String? utilitywindowSillCondition;
  String? utilitywindowSillDescription;
  String? utilitycurtainsCondition;
  String? utilitycurtainsDescription;
  String? utilityblindsCondition;
  String? utilityblindsDescription;
  String? utilitylightSwitchesCondition;
  String? utilitylightSwitchesDescription;
  String? utilitysocketsCondition;
  String? utilitysocketsDescription;
  String? utilityflooringCondition;
  String? utilityflooringDescription;
  String? utilityadditionalItemsCondition;
  String? utilityadditionalItemsDescription;
  List<String> utilitydoorImages = [];
  List<String> utilitydoorFrameImages = [];
  List<String> utilityceilingImages = [];
  List<String> utilitylightingImages = [];
  List<String> utilitywallsImages = [];
  List<String> utilityskirtingImages = [];
  List<String> utilitywindowSillImages = [];
  List<String> utilitycurtainsImages = [];
  List<String> utilityblindsImages = [];
  List<String> utilitylightSwitchesImages = [];
  List<String> utilitysocketsImages = [];
  List<String> utilityflooringImages = [];
  List<String> utilityadditionalItemsImages = [];
  late List<File> utilitycapturedImages;

  @override
  void initState() {
    super.initState();
    utilitycapturedImages = widget.utilitycapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      utilityNewdoor = prefs.getString('utilityNewdoor_${propertyId}');
      utilityDoorCondition =
          prefs.getString('utilityDoorCondition_${propertyId}');
      utilityDoorDescription =
          prefs.getString('utilityDoorDescription_${propertyId}');
      utilityDoorFrameCondition =
          prefs.getString('utilityDoorFrameCondition_${propertyId}');
      utilityDoorFrameDescription =
          prefs.getString('utilityDoorFrameDescription_${propertyId}');
      utilityCeilingCondition =
          prefs.getString('utilityCeilingCondition_${propertyId}');
      utilityCeilingDescription =
          prefs.getString('utilityCeilingDescription_${propertyId}');
      utilityLightingCondition =
          prefs.getString('utilityLightingCondition_${propertyId}');
      utilitylightingDescription =
          prefs.getString('utilitylightingDescription_${propertyId}');
      utilitywallsCondition =
          prefs.getString('utilitywallsCondition_${propertyId}');
      utilitywallsDescription =
          prefs.getString('utilitywallsDescription_${propertyId}');
      utilityskirtingCondition =
          prefs.getString('utilityskirtingCondition_${propertyId}');
      utilityskirtingDescription =
          prefs.getString('utilityskirtingDescription_${propertyId}');
      utilitywindowSillCondition =
          prefs.getString('utilitywindowSillCondition_${propertyId}');
      utilitywindowSillDescription =
          prefs.getString('utilitywindowSillDescription_${propertyId}');
      utilitycurtainsCondition =
          prefs.getString('utilitycurtainsCondition_${propertyId}');
      utilitycurtainsDescription =
          prefs.getString('utilitycurtainsDescription_${propertyId}');
      utilityblindsCondition =
          prefs.getString('utilityblindsCondition_${propertyId}');
      utilityblindsDescription =
          prefs.getString('utilityblindsDescription_${propertyId}');
      utilitylightSwitchesCondition =
          prefs.getString('utilitylightSwitchesCondition_${propertyId}');
      utilitylightSwitchesDescription =
          prefs.getString('utilitylightSwitchesDescription_${propertyId}');
      utilitysocketsCondition =
          prefs.getString('utilitysocketsCondition_${propertyId}');
      utilitysocketsDescription =
          prefs.getString('utilitysocketsDescription_${propertyId}');
      utilityflooringCondition =
          prefs.getString('utilityflooringCondition_${propertyId}');
      utilityflooringDescription =
          prefs.getString('utilityflooringDescription_${propertyId}');
      utilityadditionalItemsCondition =
          prefs.getString('utilityadditionalItemsCondition_${propertyId}');
      utilityadditionalItemsDescription =
          prefs.getString('utilityadditionalItemsDescription_${propertyId}');
      utilitydoorImages =
          prefs.getStringList('utilitydoorImages_${propertyId}') ?? [];
      utilitydoorFrameImages =
          prefs.getStringList('utilitydoorFrameImages_${propertyId}') ?? [];
      utilityceilingImages =
          prefs.getStringList('utilityceilingImages_${propertyId}') ?? [];
      utilitylightingImages =
          prefs.getStringList('utilitylightingImages_${propertyId}') ?? [];
      utilitywallsImages =
          prefs.getStringList('utilitywallsImages_${propertyId}') ?? [];
      utilityskirtingImages =
          prefs.getStringList('utilityskirtingImages_${propertyId}') ?? [];
      utilitywindowSillImages =
          prefs.getStringList('utilitywindowSillImages_${propertyId}') ?? [];
      utilitycurtainsImages =
          prefs.getStringList('utilitycurtainsImages_${propertyId}') ?? [];
      utilityblindsImages =
          prefs.getStringList('utilityblindsImages_${propertyId}') ?? [];
      utilitylightSwitchesImages =
          prefs.getStringList('utilitylightSwitchesImages_${propertyId}') ?? [];
      utilitysocketsImages =
          prefs.getStringList('utilitysocketsImages_${propertyId}') ?? [];
      utilityflooringImages =
          prefs.getStringList('utilityflooringImages_${propertyId}') ?? [];
      utilityadditionalItemsImages =
          prefs.getStringList('utilityadditionalItemsImages_${propertyId}') ??
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
              // Door
              ConditionItem(
                name: "Door",
                condition: utilityDoorCondition,
                description: utilityNewdoor,
                images: utilitydoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityDoorCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'utilityDoorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityNewdoor = description;
                  });
                  _savePreference(propertyId, 'utilityNewdoor', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitydoorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'utilitydoorImages', utilitydoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: utilityDoorFrameCondition,
                description: utilityDoorFrameDescription,
                images: utilitydoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityDoorFrameCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityDoorFrameCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityDoorFrameDescription = description;
                  });
                  _savePreference(propertyId, 'utilityDoorFrameDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitydoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilitydoorFrameImages',
                      utilitydoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: utilityCeilingCondition,
                description: utilityCeilingDescription,
                images: utilityceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityCeilingCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityCeilingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityCeilingDescription = description;
                  });
                  _savePreference(propertyId, 'utilityCeilingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilityceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'utilityceilingImages', utilityceilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: utilityLightingCondition,
                description: utilitylightingDescription,
                images: utilitylightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityLightingCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityLightingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilitylightingDescription = description;
                  });
                  _savePreference(propertyId, 'utilitylightingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitylightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilitylightingImages',
                      utilitylightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: utilitywallsCondition,
                description: utilitywallsDescription,
                images: utilitywallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilitywallsCondition = condition;
                  });
                  _savePreference(propertyId, 'utilitywallsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilitywallsDescription = description;
                  });
                  _savePreference(propertyId, 'utilitywallsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitywallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'utilitywallsImages', utilitywallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: utilityskirtingCondition,
                description: utilityskirtingDescription,
                images: utilityskirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityskirtingCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityskirtingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityskirtingDescription = description;
                  });
                  _savePreference(propertyId, 'utilityskirtingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilityskirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilityskirtingImages',
                      utilityskirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: utilitywindowSillCondition,
                description: utilitywindowSillDescription,
                images: utilitywindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilitywindowSillCondition = condition;
                  });
                  _savePreference(propertyId, 'utilitywindowSillCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilitywindowSillDescription = description;
                  });
                  _savePreference(propertyId, 'utilitywindowSillDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitywindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilitywindowSillImages',
                      utilitywindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: utilitycurtainsCondition,
                description: utilitycurtainsDescription,
                images: utilitycurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilitycurtainsCondition = condition;
                  });
                  _savePreference(propertyId, 'utilitycurtainsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilitycurtainsDescription = description;
                  });
                  _savePreference(propertyId, 'utilitycurtainsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitycurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilitycurtainsImages',
                      utilitycurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: utilityblindsCondition,
                description: utilityblindsDescription,
                images: utilityblindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityblindsCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityblindsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityblindsDescription = description;
                  });
                  _savePreference(propertyId, 'utilityblindsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilityblindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'utilityblindsImages', utilityblindsImages);
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: utilitylightSwitchesCondition,
                description: utilitylightSwitchesDescription,
                images: utilitylightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilitylightSwitchesCondition = condition;
                  });
                  _savePreference(propertyId, 'utilitylightSwitchesCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilitylightSwitchesDescription = description;
                  });
                  _savePreference(propertyId, 'utilitylightSwitchesDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitylightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilitylightSwitchesImages',
                      utilitylightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: utilitysocketsCondition,
                description: utilitysocketsDescription,
                images: utilitysocketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilitysocketsCondition = condition;
                  });
                  _savePreference(propertyId, 'utilitysocketsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilitysocketsDescription = description;
                  });
                  _savePreference(propertyId, 'utilitysocketsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilitysocketsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'utilitysocketsImages', utilitysocketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: utilityflooringCondition,
                description: utilityflooringDescription,
                images: utilityflooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityflooringCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityflooringCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityflooringDescription = description;
                  });
                  _savePreference(propertyId, 'utilityflooringDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilityflooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'utilityflooringImages',
                      utilityflooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: utilityadditionalItemsCondition,
                description: utilityadditionalItemsDescription,
                images: utilityadditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    utilityadditionalItemsCondition = condition;
                  });
                  _savePreference(propertyId, 'utilityadditionalItemsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    utilityadditionalItemsDescription = description;
                  });
                  _savePreference(
                      propertyId,
                      'utilityadditionalItemsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    utilityadditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,
                      'utilityadditionalItemsImages',
                      utilityadditionalItemsImages);
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
