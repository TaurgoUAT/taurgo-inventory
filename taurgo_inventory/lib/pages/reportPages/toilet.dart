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

  const Toilet({super.key, this.capturedImages});

  @override
  State<Toilet> createState() => _ToiletState();
}

class _ToiletState extends State<Toilet> {
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
  String? additionalItemsCondition;
  String? additionalItemsDescription;
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
  String? additionalItemsImagePath;
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
      doorCondition = prefs.getString('doorCondition');
      doorDescription = prefs.getString('doorDescription');
      doorFrameCondition = prefs.getString('doorFrameCondition');
      doorFrameDescription = prefs.getString('doorFrameDescription');
      ceilingCondition = prefs.getString('ceilingCondition');
      ceilingDescription = prefs.getString('ceilingDescription');
      extractorFanCondition = prefs.getString('extractorFanCondition');
      extractorFanDescription = prefs.getString('extractorFanDescription');
      lightingCondition = prefs.getString('lightingCondition');
      lightingDescription = prefs.getString('lightingDescription');
      wallsCondition = prefs.getString('wallsCondition');
      wallsDescription = prefs.getString('wallsDescription');
      skirtingCondition = prefs.getString('skirtingCondition');
      skirtingDescription = prefs.getString('skirtingDescription');
      windowSillCondition = prefs.getString('windowSillCondition');
      windowSillDescription = prefs.getString('windowSillDescription');
      curtainsCondition = prefs.getString('curtainsCondition');
      curtainsDescription = prefs.getString('curtainsDescription');
      blindsCondition = prefs.getString('blindsCondition');
      blindsDescription = prefs.getString('blindsDescription');
      toiletCondition = prefs.getString('toiletCondition');
      toiletDescription = prefs.getString('toiletDescription');
      basinCondition = prefs.getString('basinCondition');
      basinDescription = prefs.getString('basinDescription');
      showerCubicleCondition = prefs.getString('showerCubicleCondition');
      showerCubicleDescription = prefs.getString('showerCubicleDescription');
      bathCondition = prefs.getString('bathCondition');
      bathDescription = prefs.getString('bathDescription');
      switchBoardCondition = prefs.getString('switchBoardCondition');
      switchBoardDescription = prefs.getString('switchBoardDescription');
      socketCondition = prefs.getString('socketCondition');
      socketDescription = prefs.getString('socketDescription');
      heatingCondition = prefs.getString('heatingCondition');
      heatingDescription = prefs.getString('heatingDescription');
      accessoriesCondition = prefs.getString('accessoriesCondition');
      accessoriesDescription = prefs.getString('accessoriesDescription');
      flooringCondition = prefs.getString('flooringCondition');
      flooringDescription = prefs.getString('flooringDescription');
      additionalItemsCondition = prefs.getString('additionalItemsCondition');
      additionalItemsDescription =
          prefs.getString('additionalItemsDescription');
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
      additionalItemsImages =
          prefs.getStringList('additionalItemsImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
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
                  _savePreference(
                      'doorFrameCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorFrameDescription = description;
                  });
                  _savePreference(
                      'doorFrameDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    doorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'doorFrameImages', doorFrameImages); // Save preference
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
                  _savePreference(
                      'ceilingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    ceilingDescription = description;
                  });
                  _savePreference(
                      'ceilingDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ceilingImages', ceilingImages); // Save preference
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
                  _savePreference(
                      'extractorFanCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    extractorFanDescription = description;
                  });
                  _savePreference('extractorFanDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    extractorFanImages.add(imagePath);
                  });
                  _savePreferenceList('extractorFanImages',
                      extractorFanImages); // Save preference
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
                  _savePreference(
                      'lightingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    lightingDescription = description;
                  });
                  _savePreference(
                      'lightingDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    lightingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'lightingImages', lightingImages); // Save preference
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
                  _savePreference(
                      'wallsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    wallsDescription = description;
                  });
                  _savePreference(
                      'wallsDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    wallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'wallsImages', wallsImages); // Save preference
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
                  _savePreference(
                      'skirtingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    skirtingDescription = description;
                  });
                  _savePreference(
                      'skirtingDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    skirtingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'skirtingImages', skirtingImages); // Save preference
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
                  _savePreference(
                      'windowSillCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    windowSillDescription = description;
                  });
                  _savePreference(
                      'windowSillDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowSillImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'windowSillImages', windowSillImages); // Save preference
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
                  _savePreference(
                      'curtainsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    curtainsDescription = description;
                  });
                  _savePreference(
                      'curtainsDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    curtainsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'curtainsImages', curtainsImages); // Save preference
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
                  _savePreference(
                      'blindsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    blindsDescription = description;
                  });
                  _savePreference(
                      'blindsDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    blindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'blindsImages', blindsImages); // Save preference
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
                  _savePreference(
                      'toiletCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    toiletDescription = description;
                  });
                  _savePreference(
                      'toiletDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    toiletImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'toiletImages', toiletImages); // Save preference
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
                  _savePreference(
                      'basinCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    basinDescription = description;
                  });
                  _savePreference(
                      'basinDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    basinImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'basinImages', basinImages); // Save preference
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
                  _savePreference(
                      'showerCubicleCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    showerCubicleDescription = description;
                  });
                  _savePreference('showerCubicleDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    showerCubicleImages.add(imagePath);
                  });
                  _savePreferenceList('showerCubicleImages',
                      showerCubicleImages); // Save preference
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
                  _savePreference(
                      'bathCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathDescription = description;
                  });
                  _savePreference(
                      'bathDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    bathImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'bathImages', bathImages); // Save preference
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
                  _savePreference(
                      'switchBoardCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    switchBoardDescription = description;
                  });
                  _savePreference('switchBoardDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    switchBoardImages.add(imagePath);
                  });
                  _savePreferenceList('switchBoardImages', switchBoardImages);
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
                  _savePreference(
                      'socketCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    socketDescription = description;
                  });
                  _savePreference(
                      'socketDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    socketImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'socketImages', socketImages); // Save preference
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
                  _savePreference(
                      'heatingCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatingDescription = description;
                  });
                  _savePreference(
                      'heatingDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    heatingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'heatingImages', heatingImages); // Save preference
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
                  _savePreference(
                      'accessoriesCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    accessoriesDescription = description;
                  });
                  _savePreference('accessoriesDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    accessoriesImages.add(imagePath);
                  });
                  _savePreferenceList('accessoriesImages',
                      accessoriesImages); // Save preference
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
                  _savePreference(
                      'flooringCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    flooringDescription = description;
                  });
                  _savePreference(
                      'flooringDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    flooringImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'flooringImages', flooringImages); // Save preference
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
                  _savePreference('additionalItemsCondition',
                      condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    additionalItemsDescription = description;
                  });
                  _savePreference('additionalItemsDescription',
                      description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    additionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList('additionalItemsImages',
                      additionalItemsImages); // Save preference
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