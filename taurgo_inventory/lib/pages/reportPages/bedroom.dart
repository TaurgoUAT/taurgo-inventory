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
  String? bedRoomDoorLocation;
  String? bedRoomDoorCondition;
  String? bedRoomDoorFrameLocation;
  String? bedRoomDoorFrameCondition;
  String? bedRoomCeilingLocation;
  String? bedRoomCeilingCondition;
  String? bedRoomLightingLocation;
  String? bedRoomLightingCondition;
  String? bedRoomWallsLocation;
  String? bedRoomWallsCondition;
  String? bedRoomSkirtingLocation;
  String? bedRoomsSkirtingCondition;
  String? bedRoomWindowSillLocation;
  String? bedRoomWindowSillCondition;
  String? bedRoomCurtainsLocation;
  String? bedRoomCurtainsCondition;
  String? bedRoomBlindsLocation;
  String? bedRoomBlindsCondition;
  String? bedRoomLightSwitchesLocation;
  String? bedRoomLightSwitchesCondition;
  String? bedRoomSocketsLocation;
  String? bedRoomSocketsCondition;
  String? bedRoomFlooringLocation;
  String? bedRoomFlooringCondition;
  String? bedRoomAdditionalItemsLocation;
  String? bedRoomAdditionalItemsCondition;

  // String? bedRoomDoorImage;
  // String? doorFrameImage;
  // String? ceilingImage;
  // String? lightingImage;
  // String? wallsImage;
  // String? skirtingImage;
  // String? windowSillImage;
  // String? curtainsImage;
  // String? blindsImage;
  // String? lightSwitchesImage;
  // String? socketsImage;
  // String? flooringImage;
  // String? additionalItemsImage;
  List<String> bedRoomDoorImages = [];
  List<String> bedRoomDoorFrameImages = [];
  List<String> bedRoomCeilingImages = [];
  List<String> bedRoomlLightingImages = [];
  List<String> bedRoomwWallsImages = [];
  List<String> bedRoomSkirtingImages = [];
  List<String> bedRoomWindowSillImages = [];
  List<String> bedRoomCurtainsImages = [];
  List<String> bedRoomBlindsImages = [];
  List<String> bedRoomLightSwitchesImages = [];
  List<String> bedRoomSocketsImages = [];
  List<String> bedRoomFlooringImages = [];
  List<String> bedRoomAdditionalItemsImages = [];
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
      bedRoomDoorLocation = prefs.getString('doorLocation_${propertyId}');
      bedRoomDoorCondition = prefs.getString('doorCondition_${propertyId}');
      bedRoomDoorFrameLocation =
          prefs.getString('doorFrameLocation_${propertyId}');
      bedRoomDoorFrameCondition =
          prefs.getString('doorFrameCondition_${propertyId}');
      bedRoomCeilingLocation = prefs.getString('ceilingLocation_${propertyId}');
      bedRoomCeilingCondition =
          prefs.getString('ceilingCondition_${propertyId}');
      bedRoomLightingLocation =
          prefs.getString('lightingLocation_${propertyId}');
      bedRoomLightingCondition =
          prefs.getString('lightingCondition_${propertyId}');
      bedRoomWallsLocation = prefs.getString('wallsLocation_${propertyId}');
      bedRoomWallsCondition = prefs.getString('wallsCondition_${propertyId}');
      bedRoomSkirtingLocation =
          prefs.getString('skirtingLocation_${propertyId}');
      bedRoomsSkirtingCondition =
          prefs.getString('skirtingCondition_${propertyId}');
      bedRoomWindowSillLocation =
          prefs.getString('windowSillLocation_${propertyId}');
      bedRoomWindowSillCondition =
          prefs.getString('windowSillCondition_${propertyId}');
      bedRoomCurtainsLocation =
          prefs.getString('curtainsLocation_${propertyId}');
      bedRoomCurtainsCondition =
          prefs.getString('curtainsCondition_${propertyId}');
      bedRoomBlindsLocation = prefs.getString('blindsLocation_${propertyId}');
      bedRoomBlindsCondition = prefs.getString('blindsCondition_${propertyId}');
      bedRoomLightSwitchesLocation =
          prefs.getString('lightSwitchesLocation_${propertyId}');
      bedRoomLightSwitchesCondition =
          prefs.getString('lightSwitchesCondition_${propertyId}');
      bedRoomSocketsLocation = prefs.getString('socketsLocation_${propertyId}');
      bedRoomSocketsCondition =
          prefs.getString('socketsCondition_${propertyId}');
      bedRoomFlooringLocation =
          prefs.getString('flooringLocation_${propertyId}');
      bedRoomFlooringCondition =
          prefs.getString('flooringCondition_${propertyId}');
      bedRoomAdditionalItemsLocation =
          prefs.getString('additionalItemsLocation_${propertyId}');
      bedRoomAdditionalItemsCondition =
          prefs.getString('additionalItemsCondition_${propertyId}');
      bedRoomDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      bedRoomDoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      bedRoomCeilingImages =
          prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      bedRoomlLightingImages =
          prefs.getStringList('lightingImages_${propertyId}') ?? [];
      bedRoomwWallsImages =
          prefs.getStringList('wallsImages_${propertyId}') ?? [];
      bedRoomSkirtingImages =
          prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      bedRoomWindowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      bedRoomCurtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      bedRoomBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      bedRoomLightSwitchesImages =
          prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      bedRoomSocketsImages =
          prefs.getStringList('socketsImages_${propertyId}') ?? [];
      bedRoomFlooringImages =
          prefs.getStringList('flooringImages_${propertyId}') ?? [];
      bedRoomAdditionalItemsImages =
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
      child: Scaffold(
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
                  location: bedRoomDoorLocation,
                  condition: bedRoomDoorCondition,
                  images: bedRoomDoorImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomDoorLocation = location;
                    });
                    _savePreference(propertyId, 'doorLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomDoorCondition = condition;
                    });
                    _savePreference(propertyId, 'doorCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomDoorImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'doorImages',
                        bedRoomDoorImages); // Save preference
                  },
                ),

                // Door Frame
                ConditionItem(
                  name: "Door Frame",
                  location: bedRoomDoorFrameLocation,
                  condition: bedRoomDoorFrameCondition,
                  images: bedRoomDoorFrameImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomDoorFrameLocation = location;
                    });
                    _savePreference(propertyId, 'doorFrameLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomDoorFrameCondition = condition;
                    });
                    _savePreference(propertyId, 'doorFrameCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomDoorFrameImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'doorFrameImages',
                        bedRoomDoorFrameImages); // Save preference
                  },
                ),

                // Ceiling
                ConditionItem(
                  name: "Ceiling",
                  location: bedRoomCeilingLocation,
                  condition: bedRoomCeilingCondition,
                  images: bedRoomCeilingImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomCeilingLocation = location;
                    });
                    _savePreference(propertyId, 'ceilingLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomCeilingCondition = condition;
                    });
                    _savePreference(propertyId, 'ceilingCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomCeilingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'ceilingImages',
                        bedRoomCeilingImages); // Save preference
                  },
                ),

                // Lighting
                ConditionItem(
                  name: "Lighting",
                  location: bedRoomLightingLocation,
                  condition: bedRoomLightingCondition,
                  images: bedRoomlLightingImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomLightingLocation = location;
                    });
                    _savePreference(propertyId, 'lightingLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomLightingCondition = condition;
                    });
                    _savePreference(propertyId, 'lightingCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomlLightingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'lightingImages',
                        bedRoomlLightingImages); // Save preference
                  },
                ),

                // Walls
                ConditionItem(
                  name: "Walls",
                  location: bedRoomWallsLocation,
                  condition: bedRoomWallsCondition,
                  images: bedRoomwWallsImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomWallsLocation = location;
                    });
                    _savePreference(propertyId, 'wallsLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomWallsCondition = condition;
                    });
                    _savePreference(propertyId, 'wallsCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomwWallsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'wallsImages',
                        bedRoomwWallsImages); // Save preference
                  },
                ),

                // Skirting
                ConditionItem(
                  name: "Skirting",
                  location: bedRoomSkirtingLocation,
                  condition: bedRoomsSkirtingCondition,
                  images: bedRoomSkirtingImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomSkirtingLocation = location;
                    });
                    _savePreference(propertyId, 'skirtingLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomsSkirtingCondition = condition;
                    });
                    _savePreference(propertyId, 'skirtingCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomSkirtingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'skirtingImages',
                        bedRoomSkirtingImages); // Save preference
                  },
                ),

                // Window Sill
                ConditionItem(
                  name: "Window Sill",
                  location: bedRoomWindowSillLocation,
                  condition: bedRoomWindowSillCondition,
                  images: bedRoomWindowSillImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomWindowSillLocation = location;
                    });
                    _savePreference(propertyId, 'windowSillLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomWindowSillCondition = condition;
                    });
                    _savePreference(propertyId, 'windowSillCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomWindowSillImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'windowSillImages',
                        bedRoomWindowSillImages); // Save preference
                  },
                ),

                // Curtains
                ConditionItem(
                  name: "Curtains",
                  location: bedRoomCurtainsLocation,
                  condition: bedRoomCurtainsCondition,
                  images: bedRoomCurtainsImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomCurtainsLocation = location;
                    });
                    _savePreference(propertyId, 'curtainsLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomCurtainsCondition = condition;
                    });
                    _savePreference(propertyId, 'curtainsCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomCurtainsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'curtainsImages',
                        bedRoomCurtainsImages); // Save preference
                  },
                ),

                // Blinds
                ConditionItem(
                  name: "Blinds",
                  location: bedRoomBlindsLocation,
                  condition: bedRoomBlindsCondition,
                  images: bedRoomBlindsImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomBlindsLocation = location;
                    });
                    _savePreference(propertyId, 'blindsLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomBlindsCondition = condition;
                    });
                    _savePreference(propertyId, 'blindsCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomBlindsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'blindsImages',
                        bedRoomBlindsImages); // Save preference
                  },
                ),

                // Light Switches
                ConditionItem(
                  name: "Light Switches",
                  location: bedRoomLightSwitchesLocation,
                  condition: bedRoomLightSwitchesCondition,
                  images: bedRoomLightSwitchesImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomLightSwitchesLocation = location;
                    });
                    _savePreference(propertyId, 'lightSwitchesLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomLightSwitchesCondition = condition;
                    });
                    _savePreference(propertyId, 'lightSwitchesCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomLightSwitchesImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'lightSwitchesImages',
                        bedRoomLightSwitchesImages); // Save preference
                  },
                ),

                // Sockets
                ConditionItem(
                  name: "Sockets",
                  location: bedRoomSocketsLocation,
                  condition: bedRoomSocketsCondition,
                  images: bedRoomSocketsImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomSocketsLocation = location;
                    });
                    _savePreference(propertyId, 'socketsLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomSocketsCondition = condition;
                    });
                    _savePreference(propertyId, 'socketsCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomSocketsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'socketsImages',
                        bedRoomSocketsImages); // Save preference
                  },
                ),

                // Flooring
                ConditionItem(
                  name: "Flooring",
                  location: bedRoomFlooringLocation,
                  condition: bedRoomFlooringCondition,
                  images: bedRoomFlooringImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomFlooringLocation = location;
                    });
                    _savePreference(propertyId, 'flooringLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomFlooringCondition = condition;
                    });
                    _savePreference(propertyId, 'flooringCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomFlooringImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'flooringImages',
                        bedRoomFlooringImages); // Save preference
                  },
                ),

                // Additional Items
                ConditionItem(
                  name: "Additional Items",
                  location: bedRoomAdditionalItemsLocation,
                  condition: bedRoomAdditionalItemsCondition,
                  images: bedRoomAdditionalItemsImages,
                  onlocationSelected: (location) {
                    setState(() {
                      bedRoomAdditionalItemsLocation = location;
                    });
                    _savePreference(propertyId, 'additionalItemsLocation',
                        location!); // Save preference
                  },
                  onConditionSelected: (condition) {
                    setState(() {
                      bedRoomAdditionalItemsCondition = condition;
                    });
                    _savePreference(propertyId, 'additionalItemsCondition',
                        condition!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      bedRoomAdditionalItemsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'additionalItemsImages',
                        bedRoomAdditionalItemsImages); // Save preference
                  },
                ),

                // Add more ConditionItem widgets as needed
              ],
            ),
          ),
        ),
      ),
      canPop: false,
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
          //       onlocationSelected(result);
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
