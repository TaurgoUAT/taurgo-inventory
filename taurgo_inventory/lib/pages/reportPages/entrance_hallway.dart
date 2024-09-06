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
  String? entranceDoorCondition;
  String? entranceDoorLocation;
  String? entranceDoorFrameCondition;
  String? entranceDoorFrameLocation;
  String? entranceCeilingCondition;
  String? entranceCeilingLocation;
  String? entranceLightingCondition;
  String? entranceLightingLocation;
  String? entranceWallsCondition;
  String? entranceWallsLocation;
  String? entranceSkirtingCondition;
  String? entranceSkirtingLocation;
  String? entranceWindowSillCondition;
  String? entranceWindowSillLocation;
  String? entranceCurtainsCondition;
  String? entranceCurtainsLocation;
  String? entranceBlindsCondition;
  String? entranceBlindsLocation;
  String? entranceLightSwitchesCondition;
  String? entranceLightSwitchesLocation;
  String? entranceSocketsCondition;
  String? entranceSocketsLocation;
  String? entranceFlooringCondition;
  String? entranceFlooringLocation;
  String? entranceAdditionalItemsCondition;
  String? entranceAdditionalItemsLocation;
  // String? entranceDoorImagePaths;
  // String? doorFrameImagePaths;
  // String? ceilingImagePaths;
  // String? lightingImagePaths;
  // String? wallsImagePaths;
  // String? skirtingImagePaths;
  // String? windowSillImagePaths;
  // String? curtainsImagePaths;
  // String? blindsImagePaths;
  // String? lightSwitchesImagePaths;
  // String? socketsImagePaths;
  // String? flooringImagePaths;
  // String? additionalItemsImagePaths;

  List<String> entranceDoorImages = [];
  List<String> entranceDoorFrameImages = [];
  List<String> entranceCeilingImages = [];
  List<String> entranceLightingImages = [];
  List<String> entranceWallsImages = [];
  List<String> entranceSkirtingImages = [];
  List<String> entranceWindowSillImages = [];
  List<String> entranceCurtainsImages = [];
  List<String> entranceBlindsImages = [];
  List<String> entranceLightSwitchesImages = [];
  List<String> entranceSocketsImages = [];
  List<String> entranceFlooringImages = [];
  List<String> entranceAdditionalItemsImages = [];
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
      entranceDoorCondition = prefs.getString('doorCondition_${propertyId}');
      entranceDoorLocation = prefs.getString('doorLocation_${propertyId}');
      entranceDoorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      entranceDoorFrameLocation = prefs.getString('doorFrameLocation_${propertyId}');
      entranceCeilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      entranceCeilingLocation = prefs.getString('ceilingLocation_${propertyId}');
      entranceLightingCondition = prefs.getString('lightingCondition_${propertyId}');
      entranceLightingLocation = prefs.getString('lightingLocation_${propertyId}');
      entranceWallsCondition = prefs.getString('wallsCondition_${propertyId}');
      entranceWallsLocation = prefs.getString('wallsLocation_${propertyId}');
      entranceSkirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      entranceSkirtingLocation = prefs.getString('skirtingLocation_${propertyId}');
      entranceWindowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      entranceWindowSillLocation = prefs.getString('windowSillLocation_${propertyId}');
      entranceCurtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      entranceCurtainsLocation = prefs.getString('curtainsLocation_${propertyId}');
      entranceBlindsCondition = prefs.getString('blindsCondition_${propertyId}');
      entranceBlindsLocation = prefs.getString('blindsLocation_${propertyId}');
      entranceLightSwitchesCondition = prefs.getString('lightSwitchesCondition_${propertyId}');
      entranceLightSwitchesLocation = prefs.getString('lightSwitchesLocation_${propertyId}');
      entranceSocketsCondition = prefs.getString('socketsCondition_${propertyId}');
      entranceSocketsLocation = prefs.getString('socketsLocation_${propertyId}');
      entranceFlooringCondition = prefs.getString('flooringCondition_${propertyId}');
      entranceFlooringLocation = prefs.getString('flooringLocation_${propertyId}');
      entranceAdditionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      entranceAdditionalItemsLocation = prefs.getString('additionalItemsLocation_${propertyId}');

      entranceDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      entranceDoorFrameImages = prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      entranceCeilingImages = prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      entranceLightingImages = prefs.getStringList('lightingImages_${propertyId}') ?? [];
      entranceWallsImages = prefs.getStringList('wallsImages_${propertyId}') ?? [];
      entranceSkirtingImages = prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      entranceWindowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      entranceCurtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      entranceBlindsImages = prefs.getStringList('blindsImages_${propertyId}') ?? [];
      entranceLightSwitchesImages = prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      entranceSocketsImages = prefs.getStringList('socketsImages_${propertyId}') ?? [];
      entranceFlooringImages = prefs.getStringList('flooringImages_${propertyId}') ?? [];
      entranceAdditionalItemsImages =
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
    return PopScope(child: Scaffold(
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
          onTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Icon(Icons.info_outline, color: kPrimaryColor),
                      SizedBox(width: 10),
                      Text(
                        'Exit',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'You may lost your data if you exit the process '
                        'without saving',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        print("SOC -> EP ${widget.propertyId}");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditReportPage(propertyId: widget.propertyId)), // Replace HomePage with your
                          // home page
                          // widget
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(Icons.info_outline, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Continue Saving',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Please Make Sure You Have Added All the Necessary '
                          'Information',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          print("SOC -> EP ${widget.propertyId}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditReportPage(propertyId: widget.propertyId)), // Replace HomePage with your
                            // home page
                            // widget
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Save', // Replace with the actual location
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 14, // Adjust the font size
                  fontFamily: "Inter",
                ),
              ),
            ),
          )
        ],
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
                condition: entranceDoorCondition,
                location: entranceDoorLocation,
                images: entranceDoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceDoorCondition = condition;
                  });
                  _savePreference(
                      propertyId,'doorCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceDoorLocation = location;
                  });
                  _savePreference(propertyId,'doorLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceDoorImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorImages', entranceDoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: entranceDoorFrameCondition,
                location: entranceDoorFrameLocation,
                images: entranceDoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceDoorFrameCondition = condition;
                  });
                  _savePreference(
                      propertyId,'doorFrameCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceDoorFrameLocation = location;
                  });
                  _savePreference(
                      propertyId,'doorFrameLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceDoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorFrameImages', entranceDoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: entranceCeilingCondition,
                location: entranceCeilingLocation,
                images: entranceCeilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceCeilingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'ceilingCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceCeilingLocation = location;
                  });
                  _savePreference(
                      propertyId,'ceilingLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceCeilingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'ceilingImages', entranceCeilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: entranceLightingCondition,
                location: entranceLightingLocation,
                images: entranceLightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceLightingCondition = condition;
                  });
                  _savePreference(
                      propertyId,'lightingCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceLightingLocation = location;
                  });
                  _savePreference(
                      propertyId,'lightingLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceLightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'lightingImages', entranceLightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: entranceWallsCondition,
                location: entranceWallsLocation,
                images: entranceWallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceWallsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'wallsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceWallsLocation = location;
                  });
                  _savePreference(propertyId,'wallsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceWallsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'wallsImages', entranceWallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: entranceSkirtingCondition,
                location: entranceSkirtingLocation,
                images: entranceSkirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceSkirtingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'skirtingCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceSkirtingLocation = location;
                  });
                  _savePreference(
                      propertyId, 'skirtingLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceSkirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'skirtingImages', entranceSkirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: entranceWindowSillCondition,
                location: entranceWindowSillLocation,
                images: entranceWindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceWindowSillCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'windowSillCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceWindowSillLocation = location;
                  });
                  _savePreference(
                      propertyId, 'windowSillLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceWindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'windowSillImages', entranceWindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: entranceCurtainsCondition,
                location: entranceCurtainsLocation,
                images: entranceCurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceCurtainsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'curtainsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceCurtainsLocation = location;
                  });
                  _savePreference(
                      propertyId,'curtainsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceCurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'curtainsImages', entranceCurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: entranceBlindsCondition,
                location: entranceBlindsLocation,
                images: entranceBlindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceBlindsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'blindsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceBlindsLocation = location;
                  });
                  _savePreference(
                      propertyId,'blindsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceBlindsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'blindsImages', entranceBlindsImages);
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: entranceLightSwitchesCondition,
                location: entranceLightSwitchesLocation,
                images: entranceLightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceLightSwitchesCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'lightSwitchesCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceLightSwitchesLocation = location;
                  });
                  _savePreference(
                      propertyId,'lightSwitchesLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceLightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'lightSwitchesImages', entranceLightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: entranceSocketsCondition,
                location: entranceSocketsLocation,
                images: entranceSocketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceSocketsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'socketsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceSocketsLocation = location;
                  });
                  _savePreference(
                      propertyId, 'socketsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceSocketsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'socketsImages', entranceSocketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: entranceFlooringCondition,
                location: entranceFlooringLocation,
                images: entranceFlooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceFlooringCondition = condition;
                  });
                  _savePreference(
                      propertyId,  'flooringCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceFlooringLocation = location;
                  });
                  _savePreference(
                      propertyId, 'flooringLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceFlooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'flooringImages', entranceFlooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: entranceAdditionalItemsCondition,
                location: entranceAdditionalItemsLocation,
                images: entranceAdditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    entranceAdditionalItemsCondition = condition;
                  });
                  _savePreference(
                      propertyId,'additionalItemsCondition', condition!); // Save preference
                },
                onLocationSelected: (location) {
                  setState(() {
                    entranceAdditionalItemsLocation = location;
                  });
                  _savePreference(
                      propertyId, 'additionalItemsLocation', location!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    entranceAdditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'additionalItemsImages', entranceAdditionalItemsImages);
                },
              ),
            ],
          ),
        ),
      ),
    ),canPop: false,);
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
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: location,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onLocationSelected(result);
          //     }
          //   },
          //   child: Text(
          //     location?.isNotEmpty == true ? location! : "Location",
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
