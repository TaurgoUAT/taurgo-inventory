import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart'
as reportPages;

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Bathroom extends StatefulWidget {
  final List<File>? bathroomcapturedImages;
  final String propertyId;
  const Bathroom(
      {super.key, this.bathroomcapturedImages, required this.propertyId});

  @override
  State<Bathroom> createState() => _BathroomState();
}

class _BathroomState extends State<Bathroom> {
  String? bathroomdoorCondition;
  String? bathroomdoorDescription;
  String? bathroomdoorFrameCondition;
  String? bathroomdoorFrameDescription;
  String? bathroomceilingCondition;
  String? bathroomceilingDescription;
  String? bathroomextractorFanCondition;
  String? bathroomextractorFanDescription;
  String? bathroomlightingCondition;
  String? bathroomlightingDescription;
  String? bathroomwallsCondition;
  String? bathroomwallsDescription;
  String? bathroomskirtingCondition;
  String? bathroomskirtingDescription;
  String? bathroomwindowSillCondition;
  String? bathroomwindowSillDescription;
  String? bathroomcurtainsCondition;
  String? bathroomcurtainsDescription;
  String? bathroomblindsCondition;
  String? bathroomblindsDescription;
  String? bathroomtoiletCondition;
  String? bathroomtoiletDescription;
  String? bathroombasinCondition;
  String? bathroombasinDescription;
  String? bathroomshowerCubicleCondition;
  String? bathroomshowerCubicleDescription;
  String? bathroombathCondition;
  String? bathroombathDescription;
  String? bathroomswitchBoardCondition;
  String? bathroomswitchBoardDescription;
  String? bathroomsocketCondition;
  String? bathroomsocketDescription;
  String? bathroomheatingCondition;
  String? bathroomheatingDescription;
  String? bathroomaccessoriesCondition;
  String? bathroomaccessoriesDescription;
  String? bathroomflooringCondition;
  String? bathroomflooringDescription;
  String? bathroomadditionItemsCondition;
  String? bathroomadditionItemsDescription;
  String? doorImagePath;
  String? doorFrameImagePath;
  String? ceilingImagePath;
  String? extractorFanImagePath;
  String? lightingImagePath;
  String? wallsImagePath;
  String? skirtingImagePath;
  String? windowSillImagePath;
  String? curtainsImagePath;
  String? blindsImagePath;
  String? toiletImagePath;
  String? basinImagePath;
  String? showerCubicleImagePath;
  String? bathImagePath;
  String? switchBoardImagePath;
  String? socketImagePath;
  String? heatingImagePath;
  String? accessoriesImagePath;
  String? flooringImagePath;
  String? additionItemsImagePath;
  List<String> bathroomdoorImages = [];
  List<String> bathroomdoorFrameImages = [];
  List<String> bathroomceilingImages = [];
  List<String> bathroomextractorFanImages = [];
  List<String> bathroomlightingImages = [];
  List<String> bathroomwallsImages = [];
  List<String> bathroomskirtingImages = [];
  List<String> bathroomwindowSillImages = [];
  List<String> bathroomcurtainsImages = [];
  List<String> bathroomblindsImages = [];
  List<String> bathroomtoiletImages = [];
  List<String> bathroombasinImages = [];
  List<String> bathroomshowerCubicleImages = [];
  List<String> bathroombathImages = [];
  List<String> bathroomswitchBoardImages = [];
  List<String> bathroomsocketImages = [];
  List<String> bathroom = [];
  List<String> bathroomaccessoriesImages = [];
  List<String> bathroomflooringImages = [];
  List<String> bathroomadditionItemsImages = [];
  late List<File> bathroomcapturedImages;

  @override
  void initState() {
    super.initState();
    bathroomcapturedImages = widget.bathroomcapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Load saved preferences
  Future<void> _loadPreferences(String propertyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bathroomdoorCondition =
          prefs.getString('bathroomdoorCondition_${propertyId}');
      bathroomdoorDescription =
          prefs.getString('bathroomdoorDescription_${propertyId}');
      bathroomdoorFrameCondition =
          prefs.getString('bathroomdoorFrameCondition_${propertyId}');
      bathroomdoorFrameDescription =
          prefs.getString('bathroomdoorFrameDescription_${propertyId}');
      bathroomceilingCondition =
          prefs.getString('bathroomceilingCondition_${propertyId}');
      bathroomceilingDescription =
          prefs.getString('bathroomceilingDescription_${propertyId}');
      bathroomextractorFanCondition =
          prefs.getString('bathroomextractorFanCondition_${propertyId}');
      bathroomextractorFanDescription =
          prefs.getString('bathroomextractorFanDescription_${propertyId}');
      bathroomlightingCondition =
          prefs.getString('bathroomlightingCondition_${propertyId}');
      bathroomlightingDescription =
          prefs.getString('bathroomlightingDescription_${propertyId}');
      bathroomwallsCondition =
          prefs.getString('bathroomwallsCondition_${propertyId}');
      bathroomwallsDescription =
          prefs.getString('bathroomwallsDescription_${propertyId}');
      bathroomskirtingCondition =
          prefs.getString('bathroomskirtingCondition_${propertyId}');
      bathroomskirtingDescription =
          prefs.getString('bathroomskirtingDescription_${propertyId}');
      bathroomwindowSillCondition =
          prefs.getString('bathroomwindowSillCondition_${propertyId}');
      bathroomwindowSillDescription =
          prefs.getString('bathroomwindowSillDescription_${propertyId}');
      bathroomcurtainsCondition =
          prefs.getString('bathroomcurtainsCondition_${propertyId}');
      bathroomcurtainsDescription =
          prefs.getString('bathroomcurtainsDescription_${propertyId}');
      bathroomblindsCondition =
          prefs.getString('bathroomblindsCondition_${propertyId}');
      bathroomblindsDescription =
          prefs.getString('bathroomblindsDescription_${propertyId}');
      bathroomtoiletCondition =
          prefs.getString('bathroomtoiletCondition_${propertyId}');
      bathroomtoiletDescription =
          prefs.getString('bathroomtoiletDescription_${propertyId}');
      bathroombasinCondition =
          prefs.getString('bathroombasinCondition_${propertyId}');
      bathroombasinDescription =
          prefs.getString('bathroombasinDescription_${propertyId}');
      bathroomshowerCubicleCondition =
          prefs.getString('bathroomshowerCubicleCondition_${propertyId}');
      bathroomshowerCubicleDescription =
          prefs.getString('bathroomshowerCubicleDescription_${propertyId}');
      bathroombathCondition =
          prefs.getString('bathroombathCondition_${propertyId}');
      bathroombathDescription =
          prefs.getString('bathroombathDescription_${propertyId}');
      bathroomswitchBoardCondition =
          prefs.getString('bathroomswitchBoardCondition_${propertyId}');
      bathroomswitchBoardDescription =
          prefs.getString('bathroomswitchBoardDescription_${propertyId}');
      bathroomsocketCondition =
          prefs.getString('bathroomsocketCondition_${propertyId}');
      bathroomsocketDescription =
          prefs.getString('bathroomsocketDescription_${propertyId}');
      bathroomheatingCondition =
          prefs.getString('bathroomheatingCondition_${propertyId}');
      bathroomheatingDescription =
          prefs.getString('bathroomheatingDescription_${propertyId}');
      bathroomaccessoriesCondition =
          prefs.getString('bathroomaccessoriesCondition_${propertyId}');
      bathroomaccessoriesDescription =
          prefs.getString('bathroomaccessoriesDescription_${propertyId}');
      bathroomflooringCondition =
          prefs.getString('bathroomflooringCondition_${propertyId}');
      bathroomflooringDescription =
          prefs.getString('bathroomflooringDescription_${propertyId}');
      bathroomadditionItemsCondition =
          prefs.getString('bathroomadditionItemsCondition_${propertyId}');
      bathroomadditionItemsDescription =
          prefs.getString('bathroomadditionItemsDescription_${propertyId}');
      bathroomcapturedImages =
          (prefs.getStringList('bathroomcapturedImages_${propertyId}') ?? [])
              .map((path) => File(path))
              .toList();
      bathroomdoorImages = prefs.getStringList('bathroomdoorImages') ?? [];
      bathroomdoorFrameImages =
          prefs.getStringList('bathroomdoorFrameImages') ?? [];
      bathroomceilingImages =
          prefs.getStringList('bathroomceilingImages') ?? [];
      bathroomextractorFanImages =
          prefs.getStringList('bathroomextractorFanImages') ?? [];
      bathroomlightingImages =
          prefs.getStringList('bathroomlightingImages') ?? [];
      bathroomwallsImages = prefs.getStringList('bathroomwallsImages') ?? [];
      bathroomskirtingImages =
          prefs.getStringList('bathroomskirtingImages') ?? [];
      bathroomwindowSillImages =
          prefs.getStringList('bathroomwindowSillImages') ?? [];
      bathroomcurtainsImages =
          prefs.getStringList('bathroomcurtainsImages') ?? [];
      bathroomblindsImages = prefs.getStringList('bathroomblindsImages') ?? [];
      bathroomtoiletImages = prefs.getStringList('bathroomtoiletImages') ?? [];
      bathroombasinImages = prefs.getStringList('bathroombasinImages') ?? [];
      bathroomshowerCubicleImages =
          prefs.getStringList('bathroomshowerCubicleImages') ?? [];
      bathroombathImages = prefs.getStringList('bathroombathImages') ?? [];
      bathroomswitchBoardImages =
          prefs.getStringList('bathroomswitchBoardImages') ?? [];
      bathroomsocketImages = prefs.getStringList('bathroomsocketImages') ?? [];
      bathroom = prefs.getStringList('bathroom') ?? [];
      bathroomaccessoriesImages =
          prefs.getStringList('bathroomaccessoriesImages') ?? [];
      bathroomflooringImages =
          prefs.getStringList('bathroomflooringImages') ?? [];
      bathroomadditionItemsImages =
          prefs.getStringList('bathroomadditionItemsImages') ?? [];
    });
  }

  // Save preferences when a condition or description is selected
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
          'Bath Room',
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
                condition: bathroomdoorCondition,
                description: bathroomdoorDescription,
                images: bathroomdoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomdoorCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomdoorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomdoorDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomdoorDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomdoorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroomdoorImages', bathroomdoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: bathroomdoorFrameCondition,
                description: bathroomdoorFrameDescription,
                images: bathroomdoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomdoorFrameCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomdoorFrameCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomdoorFrameDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomdoorFrameDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomdoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomdoorFrameImages',
                      bathroomdoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: bathroomceilingCondition,
                description: bathroomceilingDescription,
                images: bathroomceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomceilingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomceilingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomceilingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomceilingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomceilingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomceilingImages',
                      bathroomceilingImages);
                },
              ),

              // Extractor Fan
              ConditionItem(
                name: "Extractor Fan",
                condition: bathroomextractorFanCondition,
                description: bathroomextractorFanDescription,
                images: bathroomextractorFanImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomextractorFanCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomextractorFanCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomextractorFanDescription = description;
                  });
                  _savePreference(propertyId, 'bathroomextractorFanDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomextractorFanImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomextractorFanImages',
                      bathroomextractorFanImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: bathroomlightingCondition,
                description: bathroomlightingDescription,
                images: bathroomlightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomlightingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomlightingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomlightingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomlightingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomlightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomlightingImages',
                      bathroomlightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: bathroomwallsCondition,
                description: bathroomwallsDescription,
                images: bathroomwallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomwallsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomwallsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomwallsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomwallsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomwallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroomwallsImages', bathroomwallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: bathroomskirtingCondition,
                description: bathroomskirtingDescription,
                images: bathroomskirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomskirtingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomskirtingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomskirtingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomskirtingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomskirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomskirtingImages',
                      bathroomskirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: bathroomwindowSillCondition,
                description: bathroomwindowSillDescription,
                images: bathroomwindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomwindowSillCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomwindowSillCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomwindowSillDescription = description;
                  });
                  _savePreference(propertyId, 'bathroomwindowSillDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomwindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomwindowSillImages',
                      bathroomwindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: bathroomcurtainsCondition,
                description: bathroomcurtainsDescription,
                images: bathroomcurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomcurtainsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomcurtainsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomcurtainsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomcurtainsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomcurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomcurtainsImages',
                      bathroomcurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: bathroomblindsCondition,
                description: bathroomblindsDescription,
                images: bathroomblindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomblindsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomblindsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomblindsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomblindsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomblindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroomblindsImages', bathroomblindsImages);
                },
              ),

              // Toilet
              ConditionItem(
                name: "Toilet",
                condition: bathroomtoiletCondition,
                description: bathroomtoiletDescription,
                images: bathroomtoiletImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomtoiletCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomtoiletCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomtoiletDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomtoiletDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomtoiletImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroomtoiletImages', bathroomtoiletImages);
                },
              ),

              // Basin
              ConditionItem(
                name: "Basin",
                condition: bathroombasinCondition,
                description: bathroombasinDescription,
                images: bathroombasinImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroombasinCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroombasinCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroombasinDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroombasinDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroombasinImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroombasinImages', bathroombasinImages);
                },
              ),

              // Shower Cubicle
              ConditionItem(
                name: "Shower Cubicle",
                condition: bathroomshowerCubicleCondition,
                description: bathroomshowerCubicleDescription,
                images: bathroomshowerCubicleImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomshowerCubicleCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomshowerCubicleCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomshowerCubicleDescription = description;
                  });
                  _savePreference(propertyId,
                      'bathroomshowerCubicleDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomshowerCubicleImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomshowerCubicleImages',
                      bathroomshowerCubicleImages);
                },
              ),

              // Bath
              ConditionItem(
                name: "Bath",
                condition: bathroombathCondition,
                description: bathroombathDescription,
                images: bathroombathImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroombathCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroombathCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroombathDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroombathDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroombathImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroombathImages', bathroombathImages);
                },
              ),

              // Switch Board
              ConditionItem(
                name: "Switch Board",
                condition: bathroomswitchBoardCondition,
                description: bathroomswitchBoardDescription,
                images: bathroomswitchBoardImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomswitchBoardCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomswitchBoardCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomswitchBoardDescription = description;
                  });
                  _savePreference(propertyId, 'bathroomswitchBoardDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomswitchBoardImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomswitchBoardImages',
                      bathroomswitchBoardImages);
                },
              ),

              // Socket
              ConditionItem(
                name: "Socket",
                condition: bathroomsocketCondition,
                description: bathroomsocketDescription,
                images: bathroomsocketImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomsocketCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomsocketCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomsocketDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomsocketDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomsocketImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'bathroomsocketImages', bathroomsocketImages);
                },
              ),

              // Heating
              ConditionItem(
                name: "Heating",
                condition: bathroomheatingCondition,
                description: bathroomheatingDescription,
                images: bathroom,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomheatingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomheatingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomheatingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomheatingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroom.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroom', bathroom);
                },
              ),

              // Accessories
              ConditionItem(
                name: "Accessories",
                condition: bathroomaccessoriesCondition,
                description: bathroomaccessoriesDescription,
                images: bathroomaccessoriesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomaccessoriesCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomaccessoriesCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomaccessoriesDescription = description;
                  });
                  _savePreference(propertyId, 'bathroomaccessoriesDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomaccessoriesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomaccessoriesImages',
                      bathroomaccessoriesImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: bathroomflooringCondition,
                description: bathroomflooringDescription,
                images: bathroomflooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomflooringCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomflooringCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomflooringDescription = description;
                  });
                  _savePreference(
                      propertyId, 'bathroomflooringDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomflooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomflooringImages',
                      bathroomflooringImages);
                },
              ),

              // Addition Items
              ConditionItem(
                name: "Addition Items",
                condition: bathroomadditionItemsCondition,
                description: bathroomadditionItemsDescription,
                images: bathroomadditionItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathroomadditionItemsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'bathroomadditionItemsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathroomadditionItemsDescription = description;
                  });
                  _savePreference(propertyId,
                      'bathroomadditionItemsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathroomadditionItemsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'bathroomadditionItemsImages',
                      bathroomadditionItemsImages);
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
                            builder: (context) => reportPages.CameraPreviewPage(
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
