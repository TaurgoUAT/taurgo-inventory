import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';

class FrontGarden extends StatefulWidget {
  final List<File>? frontGardencapturedImages;
  final String propertyId;
  const FrontGarden(
      {super.key, this.frontGardencapturedImages, required this.propertyId});

  @override
  State<FrontGarden> createState() => _FrontGardenState();
}

class _FrontGardenState extends State<FrontGarden> {
  String? frontGardendriveWayCondition;
  String? frontGardendriveWayDescription;
  String? frontGardenoutsideLightingCondition;
  String? frontGardenoutsideLightingDescription;
  String? frontGardenadditionalItemsCondition;
  String? frontGardenadditionalItemsDescription;
  List<String> frontGardendriveWayImages = [];
  List<String> frontGardenoutsideLightingImages = [];
  List<String> frontGardenadditionalItemsImages = [];
  late List<File> frontGardencapturedImages;

  @override
  void initState() {
    super.initState();
    frontGardencapturedImages = widget.frontGardencapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      frontGardendriveWayCondition =
          prefs.getString('frontGardendriveWayCondition_${propertyId}');
      frontGardendriveWayDescription =
          prefs.getString('frontGardendriveWayDescription_${propertyId}');
      frontGardenoutsideLightingCondition =
          prefs.getString('frontGardenoutsideLightingCondition_${propertyId}');
      frontGardenoutsideLightingDescription = prefs
          .getString('frontGardenoutsideLightingDescription_${propertyId}');
      frontGardenadditionalItemsCondition =
          prefs.getString('frontGardenadditionalItemsCondition_${propertyId}');
      frontGardenadditionalItemsDescription = prefs
          .getString('frontGardenadditionalItemsDescription_${propertyId}');

      frontGardendriveWayImages =
          prefs.getStringList('frontGardendriveWayImages_${propertyId}') ?? [];
      frontGardenoutsideLightingImages = prefs.getStringList(
              'frontGardenoutsideLightingImages_${propertyId}') ??
          [];
      frontGardenadditionalItemsImages = prefs.getStringList(
              'frontGardenadditionalItemsImages_${propertyId}') ??
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
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Front Garden',
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
                  // Drive Way
                  ConditionItem(
                    name: "Drive Way",
                    condition: frontGardendriveWayCondition,
                    description: frontGardendriveWayDescription,
                    images: frontGardendriveWayImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        frontGardendriveWayCondition = condition;
                      });
                      _savePreference(
                          propertyId,
                          'frontGardendriveWayCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        frontGardendriveWayDescription = description;
                      });
                      _savePreference(
                          propertyId,
                          'frontGardendriveWayDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        frontGardendriveWayImages.add(imagePath);
                      });
                      _savePreferenceList(
                          propertyId,
                          'frontGardendriveWayImages',
                          frontGardendriveWayImages);
                    },
                  ),

                  // Outside Lighting
                  ConditionItem(
                    name: "Outside Lighting",
                    condition: frontGardenoutsideLightingCondition,
                    description: frontGardenoutsideLightingDescription,
                    images: frontGardenoutsideLightingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        frontGardenoutsideLightingCondition = condition;
                      });
                      _savePreference(
                          propertyId,
                          'frontGardenoutsideLightingCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        frontGardenoutsideLightingDescription = description;
                      });
                      _savePreference(
                          propertyId,
                          'frontGardenoutsideLightingDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        frontGardenoutsideLightingImages.add(imagePath);
                      });
                      _savePreferenceList(
                          propertyId,
                          'frontGardenoutsideLightingImages',
                          frontGardenoutsideLightingImages);
                    },
                  ),

                  // Additional Items
                  ConditionItem(
                    name: "Additional Items",
                    condition: frontGardenadditionalItemsCondition,
                    description: frontGardenadditionalItemsDescription,
                    images: frontGardenadditionalItemsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        frontGardenadditionalItemsCondition = condition;
                      });
                      _savePreference(
                          propertyId,
                          'frontGardenadditionalItemsCondition',
                          condition!); // Save preference
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        frontGardenadditionalItemsDescription = description;
                      });
                      _savePreference(
                          propertyId,
                          'frontGardenadditionalItemsDescription',
                          description!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        frontGardenadditionalItemsImages.add(imagePath);
                      });
                      _savePreferenceList(
                          propertyId,
                          'frontGardenadditionalItemsImages',
                          frontGardenadditionalItemsImages);
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
          SizedBox(
            height: 12,
          ),
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: condition,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onConditionSelected(result);
          //     }
          //   },
          //   child: Text(
          //     condition?.isNotEmpty == true ? condition! : "Condition",
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
