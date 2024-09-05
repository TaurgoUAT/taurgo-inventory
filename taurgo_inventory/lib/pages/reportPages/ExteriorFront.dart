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


class Exteriorfront extends StatefulWidget {
  final List<File>? capturedImages;

  const Exteriorfront({super.key, this.capturedImages});

  @override
  State<Exteriorfront> createState() => _ExteriorfrontState();
}

class _ExteriorfrontState extends State<Exteriorfront> {
  String? newdoor;
  String? doorCondition;
  String? doorDescription;
  String? doorFrameCondition;
  String? doorFrameDescription;
  String? porchCondition;
  String? porchDescription;
  String? additionalItemsCondition;
  String? additionalItemsDescription;
  List<String> doorImages = [];
  List<String> doorFrameImages = [];
  List<String> porchImages = [];
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
      porchCondition = prefs.getString('porchCondition');
      porchDescription = prefs.getString('porchDescription');
      additionalItemsCondition = prefs.getString('additionalItemsCondition');
      additionalItemsDescription = prefs.getString('additionalItemsDescription');

      doorImages = prefs.getStringList('doorImages') ?? [];
      doorFrameImages = prefs.getStringList('doorFrameImages') ?? [];
      porchImages = prefs.getStringList('porchImages') ?? [];
      additionalItemsImages = prefs.getStringList('additionalItemsImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
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
          'Exterior Front',
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
                  _savePreference('doorCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    newdoor = description;
                  });
                  _savePreference('newdoor', description);
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
                  _savePreference('doorFrameCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorFrameDescription = description;
                  });
                  _savePreference('doorFrameDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorFrameImages.add(imagePath);
                  });
                  _savePreferenceList('doorFrameImages', doorFrameImages); // Save preference
                },
              ),

              // Porch
              ConditionItem(
                name: "Porch",
                condition: porchCondition,
                description: porchDescription,
                images: porchImages,
                onConditionSelected: (condition) {
                  setState(() {
                    porchCondition = condition;
                  });
                  _savePreference('porchCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    porchDescription = description;
                  });
                  _savePreference('porchDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    porchImages.add(imagePath);
                  });
                  _savePreferenceList('porchImages', porchImages); // Save preference
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
                  _savePreference('additionalItemsCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    additionalItemsDescription = description;
                  });
                  _savePreference('additionalItemsDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList('additionalItemsImages', additionalItemsImages); // Save preference
                },
              ),

              // Display captured images
              ...capturedImages.map((file) => Image.file(file)).toList(),

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
