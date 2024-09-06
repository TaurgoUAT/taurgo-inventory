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

class Stairs extends StatefulWidget {
  final List<File>? stairscapturedImages;
  final String propertyId;
  const Stairs(
      {super.key, this.stairscapturedImages, required this.propertyId});

  @override
  State<Stairs> createState() => _StairsState();
}

class _StairsState extends State<Stairs> {
  String? stairsdoorCondition;
  String? stairsdoorDescription;
  String? stairsdoorFrameCondition;
  String? stairsdoorFrameDescription;
  String? stairsceilingCondition;
  String? stairsceilingDescription;
  String? stairslightingCondition;
  String? stairslightingDescription;
  String? stairswallsCondition;
  String? stairswallsDescription;
  String? stairsskirtingCondition;
  String? stairsskirtingDescription;
  String? stairswindowSillCondition;
  String? stairswindowSillDescription;
  String? stairscurtainsCondition;
  String? stairscurtainsDescription;
  String? stairsblindsCondition;
  String? stairsblindsDescription;
  String? stairslightSwitchesCondition;
  String? stairslightSwitchesDescription;
  String? stairssocketsCondition;
  String? stairssocketsDescription;
  String? stairsflooringCondition;
  String? stairsflooringDescription;
  String? stairsadditionalItemsCondition;
  String? stairsadditionalItemsDescription;
  List<String> stairsdoorImages = [];
  List<String> stairsdoorFrameImages = [];
  List<String> stairsceilingImages = [];
  List<String> stairslightingImages = [];
  List<String> stairswallsImages = [];
  List<String> stairsskirtingImages = [];
  List<String> stairswindowSillImages = [];
  List<String> stairscurtainsImages = [];
  List<String> stairsblindsImages = [];
  List<String> stairslightSwitchesImages = [];
  List<String> stairssocketsImages = [];
  List<String> stairslooringImages = [];
  List<String> stairsadditionalItemsImages = [];
  late List<File> stairscapturedImages;

  @override
  void initState() {
    super.initState();
    stairscapturedImages = widget.stairscapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      stairsdoorCondition =
          prefs.getString('stairsdoorCondition_${propertyId}');
      stairsdoorDescription =
          prefs.getString('stairsdoorDescription_${propertyId}');
      stairsdoorFrameCondition =
          prefs.getString('doorFrameCondition_${propertyId}');
      stairsdoorFrameDescription =
          prefs.getString('stairsdoorFrameDescription_${propertyId}');
      stairsceilingCondition =
          prefs.getString('stairsceilingCondition_${propertyId}');
      stairsceilingDescription =
          prefs.getString('stairsceilingDescription_${propertyId}');
      stairslightingCondition =
          prefs.getString('stairslightingCondition_${propertyId}');
      stairslightingDescription =
          prefs.getString('stairslightingDescription_${propertyId}');
      stairswallsCondition =
          prefs.getString('stairswallsCondition_${propertyId}');
      stairswallsDescription =
          prefs.getString('stairswallsDescription_${propertyId}');
      stairsskirtingCondition =
          prefs.getString('stairsskirtingCondition_${propertyId}');
      stairsskirtingDescription =
          prefs.getString('stairsskirtingDescription_${propertyId}');
      stairswindowSillCondition =
          prefs.getString('stairswindowSillCondition_${propertyId}');
      stairswindowSillDescription =
          prefs.getString('stairswindowSillDescription_${propertyId}');
      stairscurtainsCondition =
          prefs.getString('stairscurtainsCondition_${propertyId}');
      stairscurtainsDescription =
          prefs.getString('stairscurtainsDescription_${propertyId}');
      stairsblindsCondition =
          prefs.getString('stairsblindsCondition_${propertyId}');
      stairsblindsDescription =
          prefs.getString('stairsblindsDescription_${propertyId}');
      stairslightSwitchesCondition =
          prefs.getString('stairslightSwitchesCondition_${propertyId}');
      stairslightSwitchesDescription =
          prefs.getString('stairsstairslightSwitchesDescription_${propertyId}');
      stairssocketsCondition =
          prefs.getString('stairssocketsCondition_${propertyId}');
      stairssocketsDescription =
          prefs.getString('socketsDescription_${propertyId}');
      stairsflooringCondition =
          prefs.getString('stairsflooringCondition_${propertyId}');
      stairsflooringDescription =
          prefs.getString('stairsflooringDescription_${propertyId}');
      stairsadditionalItemsCondition =
          prefs.getString('stairsadditionalItemsCondition_${propertyId}');
      stairsadditionalItemsDescription =
          prefs.getString('stairsadditionalItemsDescription_${propertyId}');

      stairsdoorImages =
          prefs.getStringList('stairsdoorImages_${propertyId}') ?? [];
      stairsdoorFrameImages =
          prefs.getStringList('stairsdoorFrameImages_${propertyId}') ?? [];
      stairsceilingImages =
          prefs.getStringList('stairsceilingImages_${propertyId}') ?? [];
      stairslightingImages =
          prefs.getStringList('stairslightingImages_${propertyId}') ?? [];
      stairswallsImages =
          prefs.getStringList('stairswallsImages_${propertyId}') ?? [];
      stairsskirtingImages =
          prefs.getStringList('stairsskirtingImages_${propertyId}') ?? [];
      stairswindowSillImages =
          prefs.getStringList('stairswindowSillImages_${propertyId}') ?? [];
      stairscurtainsImages =
          prefs.getStringList('stairscurtainsImages_${propertyId}') ?? [];
      stairsblindsImages =
          prefs.getStringList('stairsblindsImages_${propertyId}') ?? [];
      stairslightSwitchesImages =
          prefs.getStringList('stairslightSwitchesImages_${propertyId}') ?? [];
      stairssocketsImages =
          prefs.getStringList('stairssocketsImages_${propertyId}') ?? [];
      stairslooringImages =
          prefs.getStringList('fstairslooringImages_${propertyId}') ?? [];
      stairsadditionalItemsImages =
          prefs.getStringList('stairsadditionalItemsImages_${propertyId}') ??
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
          'Stairs',
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
                condition: stairsdoorCondition,
                description: stairsdoorDescription,
                images: stairsdoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsdoorCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsdoorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsdoorDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairsdoorDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairsdoorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairsdoorImages', stairsdoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: stairsdoorFrameCondition,
                description: stairsdoorFrameDescription,
                images: stairsdoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsdoorFrameCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsdoorFrameCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsdoorFrameDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairsdoorFrameDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairsdoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'stairsdoorFrameImages',
                      stairsdoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: stairsceilingCondition,
                description: stairsceilingDescription,
                images: stairsceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsceilingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsceilingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsceilingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairsceilingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairsceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairsceilingImages', stairsceilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: stairslightingCondition,
                description: stairslightingDescription,
                images: stairslightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairslightingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairslightingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairslightingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairslightingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairslightingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairslightingImages', stairslightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: stairswallsCondition,
                description: stairswallsDescription,
                images: stairswallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairswallsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairswallsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairswallsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairswallsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairswallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairswallsImages', stairswallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: stairsskirtingCondition,
                description: stairsskirtingDescription,
                images: stairsskirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsskirtingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsskirtingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsskirtingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairsskirtingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairsskirtingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairsskirtingImages', stairsskirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: stairswindowSillCondition,
                description: stairswindowSillDescription,
                images: stairswindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairswindowSillCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairswindowSillCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairswindowSillDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairswindowSillDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairswindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'stairswindowSillImages',
                      stairswindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: stairscurtainsCondition,
                description: stairscurtainsDescription,
                images: stairscurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairscurtainsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairscurtainsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairscurtainsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairscurtainsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairscurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairscurtainsImages', stairscurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: stairsblindsCondition,
                description: stairsblindsDescription,
                images: stairsblindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsblindsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsblindsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsblindsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairsblindsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairsblindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairsblindsImages', stairsblindsImages);
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: stairslightSwitchesCondition,
                description: stairslightSwitchesDescription,
                images: stairslightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairslightSwitchesCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairslightSwitchesCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairslightSwitchesDescription = description;
                  });
                  _savePreference(propertyId,
                      'stairsstairslightSwitchesDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairslightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'stairslightSwitchesImages',
                      stairslightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: stairssocketsCondition,
                description: stairssocketsDescription,
                images: stairssocketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairssocketsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairssocketsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairssocketsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'socketsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairssocketsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'stairssocketsImages', stairssocketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: stairsflooringCondition,
                description: stairsflooringDescription,
                images: stairslooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsflooringCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsflooringCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsflooringDescription = description;
                  });
                  _savePreference(
                      propertyId, 'stairsflooringDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairslooringImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'fstairslooringImages', stairslooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: stairsadditionalItemsCondition,
                description: stairsadditionalItemsDescription,
                images: stairsadditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    stairsadditionalItemsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'stairsadditionalItemsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    stairsadditionalItemsDescription = description;
                  });
                  _savePreference(propertyId,
                      'stairsadditionalItemsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    stairsadditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'stairsadditionalItemsImages',
                      stairsadditionalItemsImages);
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
