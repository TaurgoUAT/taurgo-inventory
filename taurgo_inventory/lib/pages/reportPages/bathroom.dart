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
import '../camera_preview_page.dart';

class Bathroom extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const Bathroom({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Bathroom> createState() => _BathroomState();
}

class _BathroomState extends State<Bathroom> {
  String? doorCondition;
  String? doorDescription;
  String? doorFrameCondition;
  String? doorFrameDescription;
  String? ceilingCondition;
  String? ceilingDescription;
  String? extractorFanCondition;
  String? extractorFanDescription;
  String? lightingCondition;
  String? lightingDescription;
  String? wallsCondition;
  String? wallsDescription;
  String? skirtingCondition;
  String? skirtingDescription;
  String? windowSillCondition;
  String? windowSillDescription;
  String? curtainsCondition;
  String? curtainsDescription;
  String? blindsCondition;
  String? blindsDescription;
  String? toiletCondition;
  String? toiletDescription;
  String? basinCondition;
  String? basinDescription;
  String? showerCubicleCondition;
  String? showerCubicleDescription;
  String? bathCondition;
  String? bathDescription;
  String? switchBoardCondition;
  String? switchBoardDescription;
  String? socketCondition;
  String? socketDescription;
  String? heatingCondition;
  String? heatingDescription;
  String? accessoriesCondition;
  String? accessoriesDescription;
  String? flooringCondition;
  String? flooringDescription;
  String? additionItemsCondition;
  String? additionItemsDescription;
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
  List<String> doorImages = [];
  List<String> doorFrameImages = [];
  List<String> ceilingImages = [];
  List<String> extractorFanImages = [];
  List<String> lightingImages = [];
  List<String> wallsImages = [];
  List<String> skirtingImages = [];
  List<String> windowSillImages = [];
  List<String> curtainsImages = [];
  List<String> blindsImages = [];
  List<String> toiletImages = [];
  List<String> basinImages = [];
  List<String> showerCubicleImages = [];
  List<String> bathImages = [];
  List<String> switchBoardImages = [];
  List<String> socketImages = [];
  List<String> heatingImages = [];
  List<String> accessoriesImages = [];
  List<String> flooringImages = [];
  List<String> additionItemsImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Load saved preferences
  Future<void> _loadPreferences(String propertyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doorCondition = prefs.getString('doorCondition_${propertyId}');
      doorDescription = prefs.getString('doorDescription_${propertyId}');
      doorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      doorFrameDescription = prefs.getString('doorFrameDescription_${propertyId}');
      ceilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      ceilingDescription = prefs.getString('ceilingDescription_${propertyId}');
      extractorFanCondition = prefs.getString('extractorFanCondition_${propertyId}');
      extractorFanDescription = prefs.getString('extractorFanDescription_${propertyId}');
      lightingCondition = prefs.getString('lightingCondition_${propertyId}');
      lightingDescription = prefs.getString('lightingDescription_${propertyId}');
      wallsCondition = prefs.getString('wallsCondition_${propertyId}');
      wallsDescription = prefs.getString('wallsDescription_${propertyId}');
      skirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      skirtingDescription = prefs.getString('skirtingDescription_${propertyId}');
      windowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      windowSillDescription = prefs.getString('windowSillDescription_${propertyId}');
      curtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      curtainsDescription = prefs.getString('curtainsDescription_${propertyId}');
      blindsCondition = prefs.getString('blindsCondition_${propertyId}');
      blindsDescription = prefs.getString('blindsDescription_${propertyId}');
      toiletCondition = prefs.getString('toiletCondition_${propertyId}');
      toiletDescription = prefs.getString('toiletDescription_${propertyId}');
      basinCondition = prefs.getString('basinCondition_${propertyId}');
      basinDescription = prefs.getString('basinDescription_${propertyId}');
      showerCubicleCondition = prefs.getString('showerCubicleCondition_${propertyId}');
      showerCubicleDescription = prefs.getString('showerCubicleDescription_${propertyId}');
      bathCondition = prefs.getString('bathCondition_${propertyId}');
      bathDescription = prefs.getString('bathDescription_${propertyId}');
      switchBoardCondition = prefs.getString('switchBoardCondition_${propertyId}');
      switchBoardDescription = prefs.getString('switchBoardDescription_${propertyId}');
      socketCondition = prefs.getString('socketCondition_${propertyId}');
      socketDescription = prefs.getString('socketDescription_${propertyId}');
      heatingCondition = prefs.getString('heatingCondition_${propertyId}');
      heatingDescription = prefs.getString('heatingDescription_${propertyId}');
      accessoriesCondition = prefs.getString('accessoriesCondition_${propertyId}');
      accessoriesDescription = prefs.getString('accessoriesDescription_${propertyId}');
      flooringCondition = prefs.getString('flooringCondition_${propertyId}');
      flooringDescription = prefs.getString('flooringDescription_${propertyId}');
      additionItemsCondition = prefs.getString('additionItemsCondition_${propertyId}');
      additionItemsDescription = prefs.getString('additionItemsDescription_${propertyId}');
      capturedImages = (prefs.getStringList('capturedImages_${propertyId}') ?? [])
          .map((path) => File(path))
          .toList();
      doorImages = prefs.getStringList('doorImages') ?? [];
      doorFrameImages = prefs.getStringList('doorFrameImages') ?? [];
      ceilingImages = prefs.getStringList('ceilingImages') ?? [];
      extractorFanImages = prefs.getStringList('extractorFanImages') ?? [];
      lightingImages = prefs.getStringList('lightingImages') ?? [];
      wallsImages = prefs.getStringList('wallsImages') ?? [];
      skirtingImages = prefs.getStringList('skirtingImages') ?? [];
      windowSillImages = prefs.getStringList('windowSillImages') ?? [];
      curtainsImages = prefs.getStringList('curtainsImages') ?? [];
      blindsImages = prefs.getStringList('blindsImages') ?? [];
      toiletImages = prefs.getStringList('toiletImages') ?? [];
      basinImages = prefs.getStringList('basinImages') ?? [];
      showerCubicleImages = prefs.getStringList('showerCubicleImages') ?? [];
      bathImages = prefs.getStringList('bathImages') ?? [];
      switchBoardImages = prefs.getStringList('switchBoardImages') ?? [];
      socketImages = prefs.getStringList('socketImages') ?? [];
      heatingImages = prefs.getStringList('heatingImages') ?? [];
      accessoriesImages = prefs.getStringList('accessoriesImages') ?? [];
      flooringImages = prefs.getStringList('flooringImages') ?? [];
      additionItemsImages = prefs.getStringList('additionItemsImages') ?? [];
    });
  }

  // Save preferences when a condition or description is selected
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
                description: doorDescription,
                images: doorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference(propertyId,'doorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorDescription = description;
                  });
                  _savePreference(propertyId,'doorDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorImages', doorImages);
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
                  _savePreference(propertyId,'doorFrameCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorFrameDescription = description;
                  });
                  _savePreference(propertyId,'doorFrameDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorFrameImages', doorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: ceilingCondition,
                description: ceilingDescription,
                images: ceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference(propertyId,'ceilingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    ceilingDescription = description;
                  });
                  _savePreference(propertyId,'ceilingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ceilingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'ceilingImages', ceilingImages);
                },
              ),

              // Extractor Fan
              ConditionItem(
                name: "Extractor Fan",
                condition: extractorFanCondition,
                description: extractorFanDescription,
                images: extractorFanImages,
                onConditionSelected: (condition) {
                  setState(() {
                    extractorFanCondition = condition;
                  });
                  _savePreference(propertyId,'extractorFanCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    extractorFanDescription = description;
                  });
                  _savePreference(propertyId,'extractorFanDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    extractorFanImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'extractorFanImages', extractorFanImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: lightingCondition,
                description: lightingDescription,
                images: lightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference(propertyId,'lightingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    lightingDescription = description;
                  });
                  _savePreference(propertyId,'lightingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'lightingImages', lightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: wallsCondition,
                description: wallsDescription,
                images: wallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference(propertyId,'wallsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    wallsDescription = description;
                  });
                  _savePreference(propertyId,'wallsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    wallsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'wallsImages', wallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: skirtingCondition,
                description: skirtingDescription,
                images: skirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference(propertyId,'skirtingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    skirtingDescription = description;
                  });
                  _savePreference(propertyId,'skirtingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    skirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'skirtingImages', skirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: windowSillCondition,
                description: windowSillDescription,
                images: windowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference(propertyId,'windowSillCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    windowSillDescription = description;
                  });
                  _savePreference(propertyId,'windowSillDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'windowSillImages', windowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: curtainsCondition,
                description: curtainsDescription,
                images: curtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference(propertyId,'curtainsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    curtainsDescription = description;
                  });
                  _savePreference(propertyId,'curtainsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    curtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'curtainsImages', curtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: blindsCondition,
                description: blindsDescription,
                images: blindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference(propertyId,'blindsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    blindsDescription = description;
                  });
                  _savePreference(propertyId,'blindsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    blindsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'blindsImages', blindsImages);
                },
              ),

              // Toilet
              ConditionItem(
                name: "Toilet",
                condition: toiletCondition,
                description: toiletDescription,
                images: toiletImages,
                onConditionSelected: (condition) {
                  setState(() {
                    toiletCondition = condition;
                  });
                  _savePreference(propertyId,'toiletCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    toiletDescription = description;
                  });
                  _savePreference(propertyId,'toiletDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    toiletImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'toiletImages', toiletImages);
                },
              ),

              // Basin
              ConditionItem(
                name: "Basin",
                condition: basinCondition,
                description: basinDescription,
                images: basinImages,
                onConditionSelected: (condition) {
                  setState(() {
                    basinCondition = condition;
                  });
                  _savePreference(propertyId,'basinCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    basinDescription = description;
                  });
                  _savePreference(propertyId,'basinDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    basinImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'basinImages', basinImages);
                },
              ),

              // Shower Cubicle
              ConditionItem(
                name: "Shower Cubicle",
                condition: showerCubicleCondition,
                description: showerCubicleDescription,
                images: showerCubicleImages,
                onConditionSelected: (condition) {
                  setState(() {
                    showerCubicleCondition = condition;
                  });
                  _savePreference(propertyId,'showerCubicleCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    showerCubicleDescription = description;
                  });
                  _savePreference(propertyId,'showerCubicleDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    showerCubicleImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId,'showerCubicleImages', showerCubicleImages);
                },
              ),

              // Bath
              ConditionItem(
                name: "Bath",
                condition: bathCondition,
                description: bathDescription,
                images: bathImages,
                onConditionSelected: (condition) {
                  setState(() {
                    bathCondition = condition;
                  });
                  _savePreference(propertyId,'bathCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathDescription = description;
                  });
                  _savePreference(propertyId,'bathDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'bathImages', bathImages);
                },
              ),

              // Switch Board
              ConditionItem(
                name: "Switch Board",
                condition: switchBoardCondition,
                description: switchBoardDescription,
                images: switchBoardImages,
                onConditionSelected: (condition) {
                  setState(() {
                    switchBoardCondition = condition;
                  });
                  _savePreference(propertyId,'switchBoardCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    switchBoardDescription = description;
                  });
                  _savePreference(propertyId,'switchBoardDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    switchBoardImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'switchBoardImages', switchBoardImages);
                },
              ),

              // Socket
              ConditionItem(
                name: "Socket",
                condition: socketCondition,
                description: socketDescription,
                images: socketImages,
                onConditionSelected: (condition) {
                  setState(() {
                    socketCondition = condition;
                  });
                  _savePreference(propertyId,'socketCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    socketDescription = description;
                  });
                  _savePreference(propertyId,'socketDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    socketImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'socketImages', socketImages);
                },
              ),

              // Heating
              ConditionItem(
                name: "Heating",
                condition: heatingCondition,
                description: heatingDescription,
                images: heatingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    heatingCondition = condition;
                  });
                  _savePreference(propertyId,'heatingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatingDescription = description;
                  });
                  _savePreference(propertyId,'heatingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    heatingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'heatingImages', heatingImages);
                },
              ),

              // Accessories
              ConditionItem(
                name: "Accessories",
                condition: accessoriesCondition,
                description: accessoriesDescription,
                images: accessoriesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    accessoriesCondition = condition;
                  });
                  _savePreference(propertyId,'accessoriesCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    accessoriesDescription = description;
                  });
                  _savePreference(propertyId,'accessoriesDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    accessoriesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'accessoriesImages', accessoriesImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: flooringCondition,
                description: flooringDescription,
                images: flooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference(propertyId,'flooringCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    flooringDescription = description;
                  });
                  _savePreference(propertyId,'flooringDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    flooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'flooringImages', flooringImages);
                },
              ),

              // Addition Items
              ConditionItem(
                name: "Addition Items",
                condition: additionItemsCondition,
                description: additionItemsDescription,
                images: additionItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    additionItemsCondition = condition;
                  });
                  _savePreference(propertyId,'additionItemsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    additionItemsDescription = description;
                  });
                  _savePreference(propertyId,'additionItemsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionItemsImages.add(imagePath);
                  });
                  _savePreferenceList(
                     propertyId, 'additionItemsImages', additionItemsImages);
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
