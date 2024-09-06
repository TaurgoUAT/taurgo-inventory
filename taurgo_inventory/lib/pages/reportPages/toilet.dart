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

class Toilet extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Toilet({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Toilet> createState() => _ToiletState();
}

class _ToiletState extends State<Toilet> {
  String? toiletDoorCondition;
  String? toiletDoorDescription;
  String? toiletDoorFrameCondition;
  String? toiletDoorFrameDescription;
  String? toiletCeilingCondition;
  String? toiletCeilingDescription;
  String? toiletExtractorFanCondition;
  String? toiletExtractorFanDescription;
  String? toiletLightingCondition;
  String? toiletLightingDescription;
  String? toiletWallsCondition;
  String? toiletWallsDescription;
  String? toiletSkirtingCondition;
  String? toiletSkirtingDescription;
  String? toiletWindowSillCondition;
  String? toiletwWindowSillDescription;
  String? toiletCurtainsCondition;
  String? toiletCurtainsDescription;
  String? toiletBlindsCondition;
  String? toiletBlindsDescription;
  String? toiletToiletCondition;
  String? toiletToiletDescription;
  String? toiletBasinCondition;
  String? toiletBasinDescription;
  String? toiletShowerCubicleCondition;
  String? toiletShowerCubicleDescription;
  String? toiletBathCondition;
  String? toiletBathDescription;
  String? toiletSwitchBoardCondition;
  String? toiletSwitchBoardDescription;
  String? toiletSocketCondition;
  String? toiletSocketDescription;
  String? toiletHeatingCondition;
  String? toiletHeatingDescription;
  String? toiletAccessoriesCondition;
  String? toiletAccessoriesDescription;
  String? toiletFlooringCondition;
  String? toiletFlooringDescription;
  String? toiletAdditionalItemsCondition;
  String? toiletAdditionalItemsDescription;

  // String? doorImagePath;
  // String? doorFrameImagePath;
  // String? ceilingImagePath;
  // String? extractorFanImagePath;
  // String? lightingImagePath;
  // String? wallsImagePath;
  // String? skirtingImagePath;
  // String? windowSillImagePath;
  // String? curtainsImagePath;
  // String? blindsImagePath;
  // String? toiletImagePath;
  // String? basinImagePath;
  // String? showerCubicleImagePath;
  // String? bathImagePath;
  // String? switchBoardImagePath;
  // String? socketImagePath;
  // String? heatingImagePath;
  // String? accessoriesImagePath;
  // String? flooringImagePath;
  // String? additionalItemsImagePath;
  List<String> toiletDoorImages = [];
  List<String> toiletDoorFrameImages = [];
  List<String> toiletCeilingImages = [];
  List<String> toiletExtractorFanImages = [];
  List<String> toiletlLightingImages = [];
  List<String> toiletWallsImages = [];
  List<String> toiletSkirtingImages = [];
  List<String> toiletWindowSillImages = [];
  List<String> toiletCurtainsImages = [];
  List<String> toiletBlindsImages = [];
  List<String> toiletToiletImages = [];
  List<String> toiletBasinImages = [];
  List<String> toiletShowerCubicleImages = [];
  List<String> toiletBathImages = [];
  List<String> toiletSwitchBoardImages = [];
  List<String> toiletSocketImages = [];
  List<String> toiletHeatingImages = [];
  List<String> toiletAccessoriesImages = [];
  List<String> toileFflooringImages = [];
  List<String> toiletAdditionalItemsImages = [];
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
      toiletDoorCondition = prefs.getString('doorCondition_${propertyId}');
      toiletDoorDescription = prefs.getString('doorDescription_${propertyId}');
      toiletDoorFrameCondition =
          prefs.getString('doorFrameCondition_${propertyId}');
      toiletDoorFrameDescription =
          prefs.getString('doorFrameDescription_${propertyId}');
      toiletCeilingCondition =
          prefs.getString('ceilingCondition_${propertyId}');
      toiletCeilingDescription =
          prefs.getString('ceilingDescription_${propertyId}');
      toiletExtractorFanCondition =
          prefs.getString('extractorFanCondition_${propertyId}');
      toiletExtractorFanDescription =
          prefs.getString('extractorFanDescription_${propertyId}');
      toiletLightingCondition =
          prefs.getString('lightingCondition_${propertyId}');
      toiletLightingDescription =
          prefs.getString('lightingDescriptionv_${propertyId}');
      toiletWallsCondition = prefs.getString('wallsCondition_${propertyId}');
      toiletWallsDescription =
          prefs.getString('wallsDescription_${propertyId}');
      toiletSkirtingCondition =
          prefs.getString('skirtingCondition_${propertyId}');
      toiletSkirtingDescription =
          prefs.getString('skirtingDescription_${propertyId}');
      toiletWindowSillCondition =
          prefs.getString('windowSillCondition_${propertyId}');
      toiletwWindowSillDescription =
          prefs.getString('windowSillDescription_${propertyId}');
      toiletCurtainsCondition =
          prefs.getString('curtainsCondition_${propertyId}');
      toiletCurtainsDescription =
          prefs.getString('curtainsDescription_${propertyId}');
      toiletBlindsCondition = prefs.getString('blindsCondition_${propertyId}');
      toiletBlindsDescription =
          prefs.getString('blindsDescription_${propertyId}');
      toiletToiletCondition = prefs.getString('toiletCondition_${propertyId}');
      toiletToiletDescription =
          prefs.getString('toiletDescription_${propertyId}');
      toiletBasinCondition = prefs.getString('basinCondition_${propertyId}');
      toiletBasinDescription =
          prefs.getString('basinDescription_${propertyId}');
      toiletShowerCubicleCondition =
          prefs.getString('showerCubicleCondition_${propertyId}');
      toiletShowerCubicleDescription =
          prefs.getString('showerCubicleDescription_${propertyId}');
      toiletBathCondition = prefs.getString('bathCondition_${propertyId}');
      toiletBathDescription = prefs.getString('bathDescription_${propertyId}');
      toiletSwitchBoardCondition =
          prefs.getString('switchBoardCondition_${propertyId}');
      toiletSwitchBoardDescription =
          prefs.getString('switchBoardDescription_${propertyId}');
      toiletSocketCondition = prefs.getString('socketCondition_${propertyId}');
      toiletSocketDescription =
          prefs.getString('socketDescription_${propertyId}');
      toiletHeatingCondition =
          prefs.getString('heatingCondition_${propertyId}');
      toiletHeatingDescription =
          prefs.getString('heatingDescription_${propertyId}');
      toiletAccessoriesCondition =
          prefs.getString('accessoriesCondition_${propertyId}');
      toiletAccessoriesDescription =
          prefs.getString('accessoriesDescription_${propertyId}');
      toiletFlooringCondition =
          prefs.getString('flooringCondition_${propertyId}');
      toiletFlooringDescription =
          prefs.getString('flooringDescription_${propertyId}');
      toiletAdditionalItemsCondition =
          prefs.getString('additionalItemsCondition_${propertyId}');
      toiletAdditionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');
      toiletDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      toiletDoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      toiletCeilingImages =
          prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      toiletExtractorFanImages =
          prefs.getStringList('extractorFanImages_${propertyId}') ?? [];
      toiletlLightingImages =
          prefs.getStringList('lightingImages_${propertyId}') ?? [];
      toiletWallsImages =
          prefs.getStringList('wallsImages_${propertyId}') ?? [];
      toiletSkirtingImages =
          prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      toiletWindowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      toiletCurtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      toiletBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      toiletToiletImages =
          prefs.getStringList('toiletImages_${propertyId}') ?? [];
      toiletBasinImages =
          prefs.getStringList('basinImages_${propertyId}') ?? [];
      toiletShowerCubicleImages =
          prefs.getStringList('showerCubicleImages_${propertyId}') ?? [];
      toiletBathImages = prefs.getStringList('bathImages_${propertyId}') ?? [];
      toiletSwitchBoardImages =
          prefs.getStringList('switchBoardImages_${propertyId}') ?? [];
      toiletSocketImages =
          prefs.getStringList('socketImages_${propertyId}') ?? [];
      toiletHeatingImages =
          prefs.getStringList('heatingImages_${propertyId}') ?? [];
      toiletAccessoriesImages =
          prefs.getStringList('accessoriesImages_${propertyId}') ?? [];
      toileFflooringImages =
          prefs.getStringList('flooringImages_${propertyId}') ?? [];
      toiletAdditionalItemsImages =
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
            'Toilet',
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
                // Door Frame
                ConditionItem(
                  name: "Door Frame",
                  condition: toiletDoorFrameCondition,
                  description: toiletDoorFrameDescription,
                  images: toiletDoorFrameImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletDoorFrameCondition = condition;
                    });
                    _savePreference(propertyId, 'doorFrameCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletDoorFrameDescription = description;
                    });
                    _savePreference(propertyId, 'doorFrameDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletDoorFrameImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'doorFrameImages',
                        toiletDoorFrameImages); // Save preference
                  },
                ),

                // Ceiling
                ConditionItem(
                  name: "Ceiling",
                  condition: toiletCeilingCondition,
                  description: toiletCeilingDescription,
                  images: toiletCeilingImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletCeilingCondition = condition;
                    });
                    _savePreference(propertyId, 'ceilingCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletCeilingDescription = description;
                    });
                    _savePreference(propertyId, 'ceilingDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletCeilingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'ceilingImages',
                        toiletCeilingImages); // Save preference
                  },
                ),

                // Extractor Fan
                ConditionItem(
                  name: "Extractor Fan",
                  condition: toiletExtractorFanCondition,
                  description: toiletExtractorFanDescription,
                  images: toiletExtractorFanImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletExtractorFanCondition = condition;
                    });
                    _savePreference(propertyId, 'extractorFanCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletExtractorFanDescription = description;
                    });
                    _savePreference(propertyId, 'extractorFanDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletExtractorFanImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'extractorFanImages',
                        toiletExtractorFanImages); // Save preference
                  },
                ),

                // Lighting
                ConditionItem(
                  name: "Lighting",
                  condition: toiletLightingCondition,
                  description: toiletLightingDescription,
                  images: toiletlLightingImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletLightingCondition = condition;
                    });
                    _savePreference(propertyId, 'lightingCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletLightingDescription = description;
                    });
                    _savePreference(propertyId, 'lightingDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletlLightingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'lightingImages',
                        toiletlLightingImages); // Save preference
                  },
                ),

                // Walls
                ConditionItem(
                  name: "Walls",
                  condition: toiletWallsCondition,
                  description: toiletWallsDescription,
                  images: toiletWallsImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletWallsCondition = condition;
                    });
                    _savePreference(propertyId, 'wallsCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletWallsDescription = description;
                    });
                    _savePreference(propertyId, 'wallsDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletWallsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'wallsImages',
                        toiletWallsImages); // Save preference
                  },
                ),

                // Skirting
                ConditionItem(
                  name: "Skirting",
                  condition: toiletSkirtingCondition,
                  description: toiletSkirtingDescription,
                  images: toiletSkirtingImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletSkirtingCondition = condition;
                    });
                    _savePreference(propertyId, 'skirtingCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletSkirtingDescription = description;
                    });
                    _savePreference(propertyId, 'skirtingDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletSkirtingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'skirtingImages',
                        toiletSkirtingImages); // Save preference
                  },
                ),

                // Window Sill
                ConditionItem(
                  name: "Window Sill",
                  condition: toiletWindowSillCondition,
                  description: toiletwWindowSillDescription,
                  images: toiletWindowSillImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletWindowSillCondition = condition;
                    });
                    _savePreference(propertyId, 'windowSillCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletwWindowSillDescription = description;
                    });
                    _savePreference(propertyId, 'windowSillDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletWindowSillImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'windowSillImages',
                        toiletWindowSillImages); // Save preference
                  },
                ),

                // Curtains
                ConditionItem(
                  name: "Curtains",
                  condition: toiletCurtainsCondition,
                  description: toiletCurtainsDescription,
                  images: toiletCurtainsImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletCurtainsCondition = condition;
                    });
                    _savePreference(propertyId, 'curtainsCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletCurtainsDescription = description;
                    });
                    _savePreference(propertyId, 'curtainsDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletCurtainsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'curtainsImages',
                        toiletCurtainsImages); // Save preference
                  },
                ),

                // Blinds
                ConditionItem(
                  name: "Blinds",
                  condition: toiletBlindsCondition,
                  description: toiletBlindsDescription,
                  images: toiletBlindsImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletBlindsCondition = condition;
                    });
                    _savePreference(propertyId, 'blindsCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletBlindsDescription = description;
                    });
                    _savePreference(propertyId, 'blindsDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletBlindsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'blindsImages',
                        toiletBlindsImages); // Save preference
                  },
                ),

                // Toilet
                ConditionItem(
                  name: "Toilet",
                  condition: toiletToiletCondition,
                  description: toiletToiletDescription,
                  images: toiletToiletImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletToiletCondition = condition;
                    });
                    _savePreference(propertyId, 'toiletCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletToiletDescription = description;
                    });
                    _savePreference(propertyId, 'toiletDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletToiletImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'toiletImages',
                        toiletToiletImages); // Save preference
                  },
                ),

                // Basin
                ConditionItem(
                  name: "Basin",
                  condition: toiletBasinCondition,
                  description: toiletBasinDescription,
                  images: toiletBasinImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletBasinCondition = condition;
                    });
                    _savePreference(propertyId, 'basinCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletBasinDescription = description;
                    });
                    _savePreference(propertyId, 'basinDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletBasinImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'basinImages',
                        toiletBasinImages); // Save preference
                  },
                ),

                // Shower Cubicle
                ConditionItem(
                  name: "Shower Cubicle",
                  condition: toiletShowerCubicleCondition,
                  description: toiletShowerCubicleDescription,
                  images: toiletShowerCubicleImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletShowerCubicleCondition = condition;
                    });
                    _savePreference(propertyId, 'showerCubicleCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletShowerCubicleDescription = description;
                    });
                    _savePreference(propertyId, 'showerCubicleDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletShowerCubicleImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'showerCubicleImages',
                        toiletShowerCubicleImages); // Save preference
                  },
                ),

                // Bath
                ConditionItem(
                  name: "Bath",
                  condition: toiletBathCondition,
                  description: toiletBathDescription,
                  images: toiletBathImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletBathCondition = condition;
                    });
                    _savePreference(propertyId, 'bathCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletBathDescription = description;
                    });
                    _savePreference(propertyId, 'bathDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletBathImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'bathImages',
                        toiletBathImages); // Save preference
                  },
                ),

                // Switch Board
                ConditionItem(
                  name: "Switch Board",
                  condition: toiletSwitchBoardCondition,
                  description: toiletSwitchBoardDescription,
                  images: toiletSwitchBoardImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletSwitchBoardCondition = condition;
                    });
                    _savePreference(propertyId, 'switchBoardCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletSwitchBoardDescription = description;
                    });
                    _savePreference(propertyId, 'switchBoardDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletSwitchBoardImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'switchBoardImages',
                        toiletSwitchBoardImages);
                  },
                ),

                // Socket
                ConditionItem(
                  name: "Socket",
                  condition: toiletSocketCondition,
                  description: toiletSocketDescription,
                  images: toiletSocketImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletSocketCondition = condition;
                    });
                    _savePreference(propertyId, 'socketCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletSocketDescription = description;
                    });
                    _savePreference(propertyId, 'socketDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletSocketImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'socketImages',
                        toiletSocketImages); // Save preference
                  },
                ),

                // Heating
                ConditionItem(
                  name: "Heating",
                  condition: toiletHeatingCondition,
                  description: toiletHeatingDescription,
                  images: toiletHeatingImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletHeatingCondition = condition;
                    });
                    _savePreference(propertyId, 'heatingCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletHeatingDescription = description;
                    });
                    _savePreference(propertyId, 'heatingDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletHeatingImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'heatingImages',
                        toiletHeatingImages); // Save preference
                  },
                ),

                // Accessories
                ConditionItem(
                  name: "Accessories",
                  condition: toiletAccessoriesCondition,
                  description: toiletAccessoriesDescription,
                  images: toiletAccessoriesImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletAccessoriesCondition = condition;
                    });
                    _savePreference(propertyId, 'accessoriesCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletAccessoriesDescription = description;
                    });
                    _savePreference(propertyId, 'accessoriesDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletAccessoriesImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'accessoriesImages',
                        toiletAccessoriesImages); // Save preference
                  },
                ),

                // Flooring
                ConditionItem(
                  name: "Flooring",
                  condition: toiletFlooringCondition,
                  description: toiletFlooringDescription,
                  images: toileFflooringImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletFlooringCondition = condition;
                    });
                    _savePreference(propertyId, 'flooringCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletFlooringDescription = description;
                    });
                    _savePreference(propertyId, 'flooringDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toileFflooringImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'flooringImages',
                        toileFflooringImages); // Save preference
                  },
                ),

                // Additional Items
                ConditionItem(
                  name: "Additional Items",
                  condition: toiletAdditionalItemsCondition,
                  description: toiletAdditionalItemsDescription,
                  images: toiletAdditionalItemsImages,
                  onConditionSelected: (condition) {
                    setState(() {
                      toiletAdditionalItemsCondition = condition;
                    });
                    _savePreference(propertyId, 'additionalItemsCondition',
                        condition!); // Save preference
                  },
                  onDescriptionSelected: (description) {
                    setState(() {
                      toiletAdditionalItemsDescription = description;
                    });
                    _savePreference(propertyId, 'additionalItemsDescription',
                        description!); // Save preference
                  },
                  onImageAdded: (imagePath) {
                    setState(() {
                      toiletAdditionalItemsImages.add(imagePath);
                    });
                    _savePreferenceList(propertyId, 'additionalItemsImages',
                        toiletAdditionalItemsImages); // Save preference
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
