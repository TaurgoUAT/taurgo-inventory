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

class Landing extends StatefulWidget {
  final List<File>? landingcapturedImages;
  final String propertyId;
  const Landing(
      {super.key, this.landingcapturedImages, required this.propertyId});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String? landingnewdoor;
  String? landingdoorCondition;
  String? landingdoorDescription;
  String? landingdoorFrameCondition;
  String? landingdoorFrameDescription;
  String? landingceilingCondition;
  String? landingceilingDescription;
  String? landinglightingCondition;
  String? landinglightingDescription;
  String? landingwallsCondition;
  String? landingwallsDescription;
  String? landingskirtingCondition;
  String? landingskirtingDescription;
  String? landingwindowSillCondition;
  String? landingwindowSillDescription;
  String? landingcurtainsCondition;
  String? landingcurtainsDescription;
  String? landingblindsCondition;
  String? landingblindsDescription;
  String? landinglightSwitchesCondition;
  String? landinglightSwitchesDescription;
  String? landingsocketsCondition;
  String? landingsocketsDescription;
  String? landingflooringCondition;
  String? landingflooringDescription;
  String? landingadditionalItemsCondition;
  String? landingadditionalItemsDescription;
  List<String> landingdoorImages = [];
  List<String> landingdoorFrameImages = [];
  List<String> landingceilingImages = [];
  List<String> landinglightingImages = [];
  List<String> ladingwallsImages = [];
  List<String> landingskirtingImages = [];
  List<String> landingwindowSillImages = [];
  List<String> landingcurtainsImages = [];
  List<String> landingblindsImages = [];
  List<String> landinglightSwitchesImages = [];
  List<String> landingsocketsImages = [];
  List<String> landingflooringImages = [];
  List<String> landingadditionalItemsImages = [];
  late List<File> landingcapturedImages;

  @override
  void initState() {
    super.initState();
    landingcapturedImages = widget.landingcapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      landingnewdoor = prefs.getString('landingnewdoor_${propertyId}');
      landingdoorCondition =
          prefs.getString('landingdoorCondition_${propertyId}');
      landingdoorDescription =
          prefs.getString('landingdoorDescription_${propertyId}');
      landingdoorFrameCondition =
          prefs.getString('landingdoorFrameCondition_${propertyId}');
      landingdoorFrameDescription =
          prefs.getString('landingdoorFrameDescription_${propertyId}');
      landingceilingCondition =
          prefs.getString('landingceilingCondition_${propertyId}');
      landingceilingDescription =
          prefs.getString('landingceilingDescription_${propertyId}');
      landinglightingCondition =
          prefs.getString('landinglightingCondition_${propertyId}');
      landinglightingDescription =
          prefs.getString('landinglightingDescription_${propertyId}');
      landingwallsCondition =
          prefs.getString('landingwallsCondition_${propertyId}');
      landingwallsDescription =
          prefs.getString('landingwallsDescription_${propertyId}');
      landingskirtingCondition =
          prefs.getString('landingskirtingCondition_${propertyId}');
      landingskirtingDescription =
          prefs.getString('landingskirtingDescription_${propertyId}');
      landingwindowSillCondition =
          prefs.getString('landingwindowSillCondition_${propertyId}');
      landingwindowSillDescription =
          prefs.getString('landingwindowSillDescription_${propertyId}');
      landingcurtainsCondition =
          prefs.getString('landingcurtainsCondition_${propertyId}');
      landingcurtainsDescription =
          prefs.getString('landingcurtainsDescription_${propertyId}');
      landingblindsCondition =
          prefs.getString('landingblindsCondition_${propertyId}');
      landingblindsDescription =
          prefs.getString('landingblindsDescription_${propertyId}');
      landinglightSwitchesCondition =
          prefs.getString('landinglightSwitchesCondition_${propertyId}');
      landinglightSwitchesDescription =
          prefs.getString('landinglightSwitchesDescription_${propertyId}');
      landingsocketsCondition =
          prefs.getString('landingsocketsCondition_${propertyId}');
      landingsocketsDescription =
          prefs.getString('landingsocketsDescription_${propertyId}');
      landingflooringCondition =
          prefs.getString('landingflooringCondition_${propertyId}');
      landingflooringDescription =
          prefs.getString('landingflooringDescription_${propertyId}');
      landingadditionalItemsCondition =
          prefs.getString('landingadditionalItemsCondition_${propertyId}');
      landingadditionalItemsDescription =
          prefs.getString('landingadditionalItemsDescription_${propertyId}');
      landingdoorImages =
          prefs.getStringList('landingdoorImages_${propertyId}') ?? [];
      landingdoorFrameImages =
          prefs.getStringList('landingdoorFrameImages_${propertyId}') ?? [];
      landingceilingImages =
          prefs.getStringList('landingceilingImages_${propertyId}') ?? [];
      landinglightingImages =
          prefs.getStringList('landinglightingImages_${propertyId}') ?? [];
      ladingwallsImages =
          prefs.getStringList('ladingwallsImages_${propertyId}') ?? [];
      landingskirtingImages =
          prefs.getStringList('landingskirtingImages_${propertyId}') ?? [];
      landingwindowSillImages =
          prefs.getStringList('landingwindowSillImages_${propertyId}') ?? [];
      landingcurtainsImages =
          prefs.getStringList('landingcurtainsImages_${propertyId}') ?? [];
      landingblindsImages =
          prefs.getStringList('landingblindsImages_${propertyId}') ?? [];
      landinglightSwitchesImages =
          prefs.getStringList('landinglightSwitchesImages_${propertyId}') ?? [];
      landingsocketsImages =
          prefs.getStringList('landingsocketsImages_${propertyId}') ?? [];
      landingflooringImages =
          prefs.getStringList('landingflooringImages_${propertyId}') ?? [];
      landingadditionalItemsImages =
          prefs.getStringList('landingadditionalItemsImages_${propertyId}') ??
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
          'Landing',
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
                condition: landingdoorCondition,
                description: landingnewdoor,
                images: landingdoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingdoorCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'landingdoorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingnewdoor = description;
                  });
                  _savePreference(propertyId, 'landingnewdoor', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingdoorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'landingdoorImages', landingdoorImages);
                },
              ),
              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: landingdoorFrameCondition,
                description: landingdoorFrameDescription,
                images: landingdoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingdoorFrameCondition = condition;
                  });
                  _savePreference(propertyId, 'landingdoorFrameCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingdoorFrameDescription = description;
                  });
                  _savePreference(propertyId, 'landingdoorFrameDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingdoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landingdoorFrameImages',
                      landingdoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: landingceilingCondition,
                description: landingceilingDescription,
                images: landingceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingceilingCondition = condition;
                  });
                  _savePreference(propertyId, 'landingceilingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingceilingDescription = description;
                  });
                  _savePreference(propertyId, 'landingceilingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'landingceilingImages', landingceilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: landinglightingCondition,
                description: landinglightingDescription,
                images: landinglightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landinglightingCondition = condition;
                  });
                  _savePreference(propertyId, 'landinglightingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landinglightingDescription = description;
                  });
                  _savePreference(propertyId, 'landinglightingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landinglightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landinglightingImages',
                      landinglightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: landingwallsCondition,
                description: landingwallsDescription,
                images: ladingwallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingwallsCondition = condition;
                  });
                  _savePreference(propertyId, 'landingwallsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingwallsDescription = description;
                  });
                  _savePreference(propertyId, 'landingwallsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ladingwallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'ladingwallsImages', ladingwallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: landingskirtingCondition,
                description: landingskirtingDescription,
                images: landingskirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingskirtingCondition = condition;
                  });
                  _savePreference(propertyId, 'landingskirtingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingskirtingDescription = description;
                  });
                  _savePreference(propertyId, 'landingskirtingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingskirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landingskirtingImages',
                      landingskirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: landingwindowSillCondition,
                description: landingwindowSillDescription,
                images: landingwindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingwindowSillCondition = condition;
                  });
                  _savePreference(propertyId, 'landingwindowSillCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingwindowSillDescription = description;
                  });
                  _savePreference(propertyId, 'landingwindowSillDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingwindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landingwindowSillImages',
                      landingwindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: landingcurtainsCondition,
                description: landingcurtainsDescription,
                images: landingcurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingcurtainsCondition = condition;
                  });
                  _savePreference(propertyId, 'landingcurtainsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingcurtainsDescription = description;
                  });
                  _savePreference(propertyId, 'landingcurtainsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingcurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landingcurtainsImages',
                      landingcurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: landingblindsCondition,
                description: landingblindsDescription,
                images: landingblindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingblindsCondition = condition;
                  });
                  _savePreference(propertyId, 'landingblindsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingblindsDescription = description;
                  });
                  _savePreference(propertyId, 'landingblindsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingblindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'landingblindsImages', landingblindsImages);
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: landinglightSwitchesCondition,
                description: landinglightSwitchesDescription,
                images: landinglightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landinglightSwitchesCondition = condition;
                  });
                  _savePreference(propertyId, 'landinglightSwitchesCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landinglightSwitchesDescription = description;
                  });
                  _savePreference(propertyId, 'landinglightSwitchesDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landinglightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landinglightSwitchesImages',
                      landinglightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: landingsocketsCondition,
                description: landingsocketsDescription,
                images: landingsocketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingsocketsCondition = condition;
                  });
                  _savePreference(propertyId, 'landingsocketsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingsocketsDescription = description;
                  });
                  _savePreference(propertyId, 'landingsocketsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingsocketsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'landingsocketsImages', landingsocketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: landingflooringCondition,
                description: landingflooringDescription,
                images: landingflooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingflooringCondition = condition;
                  });
                  _savePreference(propertyId, 'landingflooringCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingflooringDescription = description;
                  });
                  _savePreference(propertyId, 'landingflooringDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingflooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'landingflooringImages',
                      landingflooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: landingadditionalItemsCondition,
                description: landingadditionalItemsDescription,
                images: landingadditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landingadditionalItemsCondition = condition;
                  });
                  _savePreference(propertyId, 'landingadditionalItemsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landingadditionalItemsDescription = description;
                  });
                  _savePreference(
                      propertyId,
                      'landingadditionalItemsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landingadditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,
                      'landingadditionalItemsImages',
                      landingadditionalItemsImages);
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
