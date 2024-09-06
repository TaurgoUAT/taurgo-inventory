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

class Garage extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Garage({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  String? newdoor;
  String? garageDoorCondition;
  String? garageDoorDescription;
  String? garageDoorFrameCondition;
  String? garageDoorFrameDescription;
  String? garageceilingCondition;
  String? garageceilingDescription;
  String? garagelightingCondition;
  String? garagelightingDescription;
  String? garagewallsCondition;
  String? garagewallsDescription;
  String? garageskirtingCondition;
  String? garageskirtingDescription;
  String? garagewindowSillCondition;
  String? garagewindowSillDescription;
  String? garagecurtainsCondition;
  String? garagecurtainsDescription;
  String? garageblindsCondition;
  String? garageblindsDescription;
  String? garagelightSwitchesCondition;
  String? garagelightSwitchesDescription;
  String? garagesocketsCondition;
  String? garagesocketsDescription;
  String? garageflooringCondition;
  String? garageflooringDescription;
  String? garageadditionalItemsCondition;
  String? garageadditionalItemsDescription;
  String? garagedoorImagePath;
  String? garagedoorFrameImagePath;
  String? garageceilingImagePath;
  String? garagelightingImagePath;
  String? garagewallsImagePath;
  String? garageskirtingImagePath;
  String? garagewindowSillImagePath;
  String? garagecurtainsImagePath;
  String? garageblindsImagePath;
  String? garagelightSwitchesImagePath;
  String? garagesocketsImagePath;
  String? garageflooringImagePath;
  String? garageadditionalItemsImagePath;
  List<String> garagedoorImages = [];
  List<String> garagedoorFrameImages = [];
  List<String> garageceilingImages = [];
  List<String> garagelightingImages = [];
  List<String> garagewallsImages = [];
  List<String> garageskirtingImages = [];
  List<String> garagewindowSillImages = [];
  List<String> garagecurtainsImages = [];
  List<String> garageblindsImages = [];
  List<String> garagelightSwitchesImages = [];
  List<String> garagesocketsImages = [];
  List<String> garageflooringImages = [];
  List<String> garageadditionalItemsImages = [];
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
      newdoor = prefs.getString('newdoor_${propertyId}');
      garageDoorCondition = prefs.getString('doorCondition_${propertyId}');
      garageDoorDescription = prefs.getString('doorDescription_${propertyId}');
      garageDoorFrameCondition =
          prefs.getString('doorFrameCondition_${propertyId}');
      garageDoorFrameDescription =
          prefs.getString('doorFrameDescription_${propertyId}');
      garageceilingCondition =
          prefs.getString('ceilingCondition_${propertyId}');
      garageceilingDescription =
          prefs.getString('ceilingDescription_${propertyId}');
      garagelightingCondition =
          prefs.getString('lightingCondition_${propertyId}');
      garagelightingDescription =
          prefs.getString('lightingDescription_${propertyId}');
      garagewallsCondition = prefs.getString('wallsCondition_${propertyId}');
      garagewallsDescription =
          prefs.getString('wallsDescription_${propertyId}');
      garageskirtingCondition =
          prefs.getString('skirtingCondition_${propertyId}');
      garageskirtingDescription =
          prefs.getString('skirtingDescription_${propertyId}');
      garagewindowSillCondition =
          prefs.getString('windowSillCondition_${propertyId}');
      garagewindowSillDescription =
          prefs.getString('windowSillDescription_${propertyId}');
      garagecurtainsCondition =
          prefs.getString('curtainsCondition_${propertyId}');
      garagecurtainsDescription =
          prefs.getString('curtainsDescription_${propertyId}');
      garageblindsCondition = prefs.getString('blindsCondition_${propertyId}');
      garageblindsDescription =
          prefs.getString('blindsDescription_${propertyId}');
      garagelightSwitchesCondition =
          prefs.getString('lightSwitchesCondition_${propertyId}');
      garagelightSwitchesDescription =
          prefs.getString('lightSwitchesDescription_${propertyId}');
      garagesocketsCondition =
          prefs.getString('socketsCondition_${propertyId}');
      garagesocketsDescription =
          prefs.getString('socketsDescription_${propertyId}');
      garageflooringCondition =
          prefs.getString('flooringCondition_${propertyId}');
      garageflooringDescription =
          prefs.getString('flooringDescription_${propertyId}');
      garageadditionalItemsCondition =
          prefs.getString('additionalItemsCondition_${propertyId}');
      garageadditionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');

      garagedoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      garageceilingImages =
          prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      garagelightingImages =
          prefs.getStringList('lightingImages_${propertyId}') ?? [];
      garagewallsImages =
          prefs.getStringList('wallsImages_${propertyId}') ?? [];
      garageskirtingImages =
          prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      garagewindowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      garagecurtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      garageblindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      garagelightSwitchesImages =
          prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      garagesocketsImages =
          prefs.getStringList('socketsImages_${propertyId}') ?? [];
      garageflooringImages =
          prefs.getStringList('flooringImages_${propertyId}') ?? [];
      garageadditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];
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
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Garage',
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
                    condition: garageDoorCondition,
                    description: newdoor,
                    images: garagedoorImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageDoorCondition = condition;
                      });
                      _savePreference(propertyId, 'doorCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        newdoor = description;
                      });
                      _savePreference(propertyId, 'newdoor', description!);
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagedoorImages.add(imagePath);
                      });
                      _savePreferenceList(
                          propertyId, 'doorImages', garagedoorImages);
                    },
                  ),

                  // Door Frame
                  ConditionItem(
                    name: "Door Frame",
                    condition: garageDoorFrameCondition,
                    description: garageDoorFrameDescription,
                    images: garagedoorFrameImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageDoorFrameCondition = condition;
                      });
                      _savePreference(propertyId, 'doorFrameCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garageDoorFrameDescription = description;
                      });
                      _savePreference(propertyId, 'doorFrameDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagedoorFrameImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'doorFrameImages',
                          garagedoorFrameImages); // Save preference
                    },
                  ),

                  // Ceiling
                  ConditionItem(
                    name: "Ceiling",
                    condition: garageceilingCondition,
                    description: garageceilingDescription,
                    images: garageceilingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageceilingCondition = condition;
                      });
                      _savePreference(propertyId, 'ceilingCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garageceilingDescription = description;
                      });
                      _savePreference(propertyId, 'ceilingDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garageceilingImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'lightingImages',
                          garageceilingImages); // Save preference
                    },
                  ),

                  // Lighting
                  ConditionItem(
                    name: "Lighting",
                    condition: garagelightingCondition,
                    description: garagelightingDescription,
                    images: garagelightingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garagelightingCondition = condition;
                      });
                      _savePreference(propertyId, 'lightingCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garagelightingDescription = description;
                      });
                      _savePreference(propertyId, 'lightingDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagelightingImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'lightingImages',
                          garagelightingImages); // Save preference
                    },
                  ),

                  // Walls
                  ConditionItem(
                    name: "Walls",
                    condition: garagewallsCondition,
                    description: garagewallsDescription,
                    images: garagewallsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garagewallsCondition = condition;
                      });
                      _savePreference(propertyId, 'wallsCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garagewallsDescription = description;
                      });
                      _savePreference(propertyId, 'wallsDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagewallsImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'wallsImages',
                          garagewallsImages); // Save preference
                    },
                  ),

                  // Skirting
                  ConditionItem(
                    name: "Skirting",
                    condition: garageskirtingCondition,
                    description: garageskirtingDescription,
                    images: garageskirtingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageskirtingCondition = condition;
                      });
                      _savePreference(propertyId, 'skirtingCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garageskirtingDescription = description;
                      });
                      _savePreference(propertyId, 'skirtingDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garageskirtingImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'skirtingImages',
                          garageskirtingImages); // Save preference
                    },
                  ),

                  // Window Sill
                  ConditionItem(
                    name: "Window Sill",
                    condition: garagewindowSillCondition,
                    description: garagewindowSillDescription,
                    images: garagewindowSillImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garagewindowSillCondition = condition;
                      });
                      _savePreference(propertyId, 'windowSillCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garagewindowSillDescription = description;
                      });
                      _savePreference(propertyId, 'windowSillDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagewindowSillImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'windowSillImages',
                          garagewindowSillImages); // Save preference
                    },
                  ),

                  // Curtains
                  ConditionItem(
                    name: "Curtains",
                    condition: garagecurtainsCondition,
                    description: garagecurtainsDescription,
                    images: garagecurtainsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garagecurtainsCondition = condition;
                      });
                      _savePreference(propertyId, 'curtainsCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garagecurtainsDescription = description;
                      });
                      _savePreference(propertyId, 'curtainsDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagecurtainsImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'curtainsImages',
                          garagecurtainsImages); // Save preference
                    },
                  ),

                  // Blinds
                  ConditionItem(
                    name: "Blinds",
                    condition: garageblindsCondition,
                    description: garageblindsDescription,
                    images: garageblindsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageblindsCondition = condition;
                      });
                      _savePreference(propertyId, 'blindsCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garageblindsDescription = description;
                      });
                      _savePreference(propertyId, 'blindsDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garageblindsImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'blindsImages',
                          garageblindsImages); // Save preference
                    },
                  ),

                  // Light Switches
                  ConditionItem(
                    name: "Light Switches",
                    condition: garagelightSwitchesCondition,
                    description: garagelightSwitchesDescription,
                    images: garagelightSwitchesImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garagelightSwitchesCondition = condition;
                      });
                      _savePreference(propertyId, 'lightSwitchesCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garagelightSwitchesDescription = description;
                      });
                      _savePreference(propertyId, 'lightSwitchesDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagelightSwitchesImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'lightSwitchesImages',
                          garagelightSwitchesImages); // Save preference
                    },
                  ),

                  // Sockets
                  ConditionItem(
                    name: "Sockets",
                    condition: garagesocketsCondition,
                    description: garagesocketsDescription,
                    images: garagesocketsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garagesocketsCondition = condition;
                      });
                      _savePreference(propertyId, 'socketsCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garagesocketsDescription = description;
                      });
                      _savePreference(propertyId, 'socketsDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garagesocketsImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'socketsImages',
                          garagesocketsImages); // Save preference
                    },
                  ),

                  // Flooring
                  ConditionItem(
                    name: "Flooring",
                    condition: garageflooringCondition,
                    description: garageflooringDescription,
                    images: garageflooringImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageflooringCondition = condition;
                      });
                      _savePreference(propertyId, 'flooringCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garageflooringDescription = description;
                      });
                      _savePreference(propertyId, 'flooringDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garageflooringImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'flooringImages',
                          garageflooringImages); // Save preference
                    },
                  ),

                  // Additional Items
                  ConditionItem(
                    name: "Additional Items",
                    condition: garageadditionalItemsCondition,
                    description: garageadditionalItemsDescription,
                    images: garageadditionalItemsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        garageadditionalItemsCondition = condition;
                      });
                      _savePreference(propertyId, 'additionalItemsCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        garageadditionalItemsDescription = description;
                      });
                      _savePreference(propertyId, 'additionalItemsDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        garageadditionalItemsImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'additionalItemsImages',
                          garageadditionalItemsImages); // Save preference
                    },
                  ),

                  // Add more ConditionItem widgets as needed
                ],
              ),
            ),
          ),
        ));
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
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.warning_amber,
                  //     size: 24,
                  //     color: kAccentColor,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => AddAction(),
                  //       ),
                  //     );
                  //   },
                  // ),
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
          // SizedBox(
          //   height: 12,
          // ),
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
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: description,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onDescriptionSelected(result);
          //     }
          //   },
          //   child: Text(
          //     description?.isNotEmpty == true ? description! : "Description",
          //     style: TextStyle(
          //       fontSize: 12.0,
          //       fontWeight: FontWeight.w700,
          //       color: kPrimaryTextColourTwo,
          //       fontStyle: FontStyle.italic,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 12,
          // ),
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
