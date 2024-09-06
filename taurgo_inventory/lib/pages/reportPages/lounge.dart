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

class Lounge extends StatefulWidget {
  final List<File>? loungecapturedImages;
  final String propertyId;
  const Lounge(
      {super.key, this.loungecapturedImages, required this.propertyId});

  @override
  State<Lounge> createState() => _LoungeState();
}

class _LoungeState extends State<Lounge> {
  String? lougeDoorCondition;
  String? loungedoorDescription;
  String? loungedoorFrameCondition;
  String? loungedoorFrameDescription;
  String? loungeceilingCondition;
  String? loungeceilingDescription;
  String? loungelightingCondition;
  String? loungelightingDescription;
  String? loungewallsCondition;
  String? loungewallsDescription;
  String? loungeskirtingCondition;
  String? loungeskirtingDescription;
  String? loungewindowSillCondition;
  String? loungewindowSillDescription;
  String? loungecurtainsCondition;
  String? loungecurtainsDescription;
  String? loungeblindsCondition;
  String? loungeblindsDescription;
  String? loungelightSwitchesCondition;
  String? loungelightSwitchesDescription;
  String? loungesocketsCondition;
  String? loungesocketsDescription;
  String? loungeflooringCondition;
  String? loungeflooringDescription;
  String? loungeadditionalItemsCondition;
  String? loungeadditionalItemsDescription;
  List<String> loungedoorImages = [];
  List<String> loungedoorFrameImages = [];
  List<String> loungeceilingImages = [];
  List<String> loungelightingImages = [];
  List<String> loungewallsImages = [];
  List<String> loungeskirtingImages = [];
  List<String> loungewindowSillImages = [];
  List<String> loungecurtainsImages = [];
  List<String> loungeblindsImages = [];
  List<String> loungelightSwitchesImages = [];
  List<String> loungesocketsImages = [];
  List<String> loungeflooringImages = [];
  List<String> loungeadditionalItemsImages = [];
  late List<File> loungecapturedImages;

  @override
  void initState() {
    super.initState();
    loungecapturedImages = widget.loungecapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lougeDoorCondition = prefs.getString('doorCondition_${propertyId}');
      loungedoorDescription =
          prefs.getString('loungedoorDescription_${propertyId}');
      loungedoorFrameCondition =
          prefs.getString('loungedoorFrameCondition_${propertyId}');
      loungedoorFrameDescription =
          prefs.getString('loungedoorFrameDescription_${propertyId}');
      loungeceilingCondition =
          prefs.getString('loungeceilingCondition_${propertyId}');
      loungeceilingDescription =
          prefs.getString('loungeceilingDescription_${propertyId}');
      loungelightingCondition =
          prefs.getString('loungelightingCondition_${propertyId}');
      loungelightingDescription =
          prefs.getString('loungelightingDescription_${propertyId}');
      loungewallsCondition =
          prefs.getString('loungewallsCondition_${propertyId}');
      loungewallsDescription =
          prefs.getString('loungewallsDescription_${propertyId}');
      loungeskirtingCondition =
          prefs.getString('loungeskirtingCondition_${propertyId}');
      loungeskirtingDescription =
          prefs.getString('loungeskirtingDescription_${propertyId}');
      loungewindowSillCondition =
          prefs.getString('loungewindowSillCondition_${propertyId}');
      loungewindowSillDescription =
          prefs.getString('loungewindowSillDescription_${propertyId}');
      loungecurtainsCondition =
          prefs.getString('loungecurtainsCondition_${propertyId}');
      loungecurtainsDescription =
          prefs.getString('loungecurtainsDescription_${propertyId}');
      loungeblindsCondition =
          prefs.getString('loungeblindsCondition_${propertyId}');
      loungeblindsDescription =
          prefs.getString('loungeblindsDescription_${propertyId}');
      loungelightSwitchesCondition =
          prefs.getString('loungelightSwitchesCondition_${propertyId}');
      loungelightSwitchesDescription =
          prefs.getString('loungelightSwitchesDescription_${propertyId}');
      loungesocketsCondition =
          prefs.getString('loungesocketsCondition_${propertyId}');
      loungesocketsDescription =
          prefs.getString('loungesocketsDescription_${propertyId}');
      loungeflooringCondition =
          prefs.getString('loungeflooringCondition_${propertyId}');
      loungeflooringDescription =
          prefs.getString('loungeflooringDescription_${propertyId}');
      loungeadditionalItemsCondition =
          prefs.getString('loungeadditionalItemsCondition_${propertyId}');
      loungeadditionalItemsDescription =
          prefs.getString('loungeadditionalItemsDescription_${propertyId}');

      loungedoorImages =
          prefs.getStringList('loungedoorImages_${propertyId}') ?? [];
      loungedoorFrameImages =
          prefs.getStringList('loungedoorFrameImages_${propertyId}') ?? [];
      loungeceilingImages =
          prefs.getStringList('loungeceilingImages_${propertyId}') ?? [];
      loungelightingImages =
          prefs.getStringList('loungelightingImages_${propertyId}') ?? [];
      loungewallsImages =
          prefs.getStringList('loungewallsImages_${propertyId}') ?? [];
      loungeskirtingImages =
          prefs.getStringList('loungeskirtingImages_${propertyId}') ?? [];
      loungewindowSillImages =
          prefs.getStringList('loungewindowSillImages_${propertyId}') ?? [];
      loungecurtainsImages =
          prefs.getStringList('loungecurtainsImages_${propertyId}') ?? [];
      loungeblindsImages =
          prefs.getStringList('loungeblindsImages_${propertyId}') ?? [];
      loungelightSwitchesImages =
          prefs.getStringList('loungelightSwitchesImages_${propertyId}') ?? [];
      loungesocketsImages =
          prefs.getStringList('loungesocketsImages_${propertyId}') ?? [];
      loungeflooringImages =
          prefs.getStringList('loungeflooringImages_${propertyId}') ?? [];
      loungeadditionalItemsImages =
          prefs.getStringList('loungeadditionalItemsImages_${propertyId}') ??
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
          'Lounge',
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
                condition: lougeDoorCondition,
                description: loungedoorDescription,
                images: loungedoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    lougeDoorCondition = condition;
                  });
                  _savePreference(propertyId, 'doorCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungedoorDescription = description;
                  });
                  _savePreference(propertyId, 'loungedoorDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungedoorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungedoorImages', loungedoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: loungedoorFrameCondition,
                description: loungedoorFrameDescription,
                images: loungedoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungedoorFrameCondition = condition;
                  });
                  _savePreference(propertyId, 'loungedoorFrameCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungedoorFrameDescription = description;
                  });
                  _savePreference(propertyId, 'loungedoorFrameDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungedoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'loungedoorFrameImages',
                      loungedoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: loungeceilingCondition,
                description: loungeceilingDescription,
                images: loungeceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungeceilingCondition = condition;
                  });
                  _savePreference(propertyId, 'loungeceilingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungeceilingDescription = description;
                  });
                  _savePreference(propertyId, 'loungeceilingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungeceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungeceilingImages', loungeceilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: loungelightingCondition,
                description: loungelightingDescription,
                images: loungelightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungelightingCondition = condition;
                  });
                  _savePreference(propertyId, 'loungelightingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungelightingDescription = description;
                  });
                  _savePreference(propertyId, 'loungelightingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungelightingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungelightingImages', loungelightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: loungewallsCondition,
                description: loungewallsDescription,
                images: loungewallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungewallsCondition = condition;
                  });
                  _savePreference(propertyId, 'loungewallsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungewallsDescription = description;
                  });
                  _savePreference(propertyId, 'loungewallsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungewallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungewallsImages', loungewallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: loungeskirtingCondition,
                description: loungeskirtingDescription,
                images: loungeskirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungeskirtingCondition = condition;
                  });
                  _savePreference(propertyId, 'loungeskirtingCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungeskirtingDescription = description;
                  });
                  _savePreference(propertyId, 'loungeskirtingDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungeskirtingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungeskirtingImages', loungeskirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: loungewindowSillCondition,
                description: loungewindowSillDescription,
                images: loungewindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungewindowSillCondition = condition;
                  });
                  _savePreference(propertyId, 'loungewindowSillCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungewindowSillDescription = description;
                  });
                  _savePreference(propertyId, 'loungewindowSillDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungewindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'loungewindowSillImages',
                      loungewindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: loungecurtainsCondition,
                description: loungecurtainsDescription,
                images: loungecurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungecurtainsCondition = condition;
                  });
                  _savePreference(propertyId, 'loungecurtainsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungecurtainsDescription = description;
                  });
                  _savePreference(propertyId, 'loungecurtainsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungecurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungecurtainsImages', loungecurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: loungeblindsCondition,
                description: loungeblindsDescription,
                images: loungeblindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungeblindsCondition = condition;
                  });
                  _savePreference(propertyId, 'loungeblindsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungeblindsDescription = description;
                  });
                  _savePreference(propertyId, 'loungeblindsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungeblindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungeblindsImages', loungeblindsImages);
                },
              ),
              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: loungelightSwitchesCondition,
                description: loungelightSwitchesDescription,
                images: loungelightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungelightSwitchesCondition = condition;
                  });
                  _savePreference(propertyId, 'loungelightSwitchesCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungelightSwitchesDescription = description;
                  });
                  _savePreference(propertyId, 'loungelightSwitchesDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungelightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'loungelightSwitchesImages',
                      loungelightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: loungesocketsCondition,
                description: loungesocketsDescription,
                images: loungesocketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungesocketsCondition = condition;
                  });
                  _savePreference(propertyId, 'loungesocketsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungesocketsDescription = description;
                  });
                  _savePreference(propertyId, 'loungesocketsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungesocketsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungesocketsImages', loungesocketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: loungeflooringCondition,
                description: loungeflooringDescription,
                images: loungeflooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungeflooringCondition = condition;
                  });
                  _savePreference(propertyId, 'loungeflooringCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungeflooringDescription = description;
                  });
                  _savePreference(propertyId, 'loungeflooringDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungeflooringImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'loungeflooringImages', loungeflooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: loungeadditionalItemsCondition,
                description: loungeadditionalItemsDescription,
                images: loungeadditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    loungeadditionalItemsCondition = condition;
                  });
                  _savePreference(propertyId, 'loungeadditionalItemsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    loungeadditionalItemsDescription = description;
                  });
                  _savePreference(
                      propertyId,
                      'loungeadditionalItemsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    loungeadditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'loungeadditionalItemsImages',
                      loungeadditionalItemsImages);
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
