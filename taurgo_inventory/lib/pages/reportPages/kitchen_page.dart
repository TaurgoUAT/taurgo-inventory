import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class KitchenPage extends StatefulWidget {
  final List<File>? kitchenCapturedImages;
  final String propertyId;

  const KitchenPage(
      {super.key, this.kitchenCapturedImages, required this.propertyId});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  String? kitchenNewDoor;
  String? kitchenDoorCondition;
  String? kitchenDoorDescription;
  String? kitchenDoorFrameCondition;
  String? kitchenDoorFrameDescription;
  String? kitchenCeilingCondition;
  String? kitchenCeilingDescription;
  String? kitchenExtractorFanCondition;
  String? kitchenExtractorFanDescription;
  String? kitchenLightingCondition;
  String? kitchenLightingDescription;
  String? kitchenWallsCondition;
  String? kitchenWallsDescription;
  String? kitchenSkirtingCondition;
  String? kitchenSkirtingDescription;
  String? kitchenWindowSillCondition;
  String? kitchenWindowSillDescription;
  String? kitchenCurtainsCondition;
  String? kitchenCurtainsDescription;
  String? kitchenBlindsCondition;
  String? kitchenBlindsDescription;
  String? kitchenToiletCondition;
  String? kitchenToiletDescription;
  String? kitchenBasinCondition;
  String? kitchenBasinDescription;
  String? kitchenShowerCubicleCondition;
  String? kitchenShowerCubicleDescription;
  String? kitchenBathCondition;
  String? kitchenBathDescription;
  String? kitchenSwitchBoardCondition;
  String? kitchenSwitchBoardDescription;
  String? kitchenSocketCondition;
  String? kitchenSocketDescription;
  String? kitchenHeatingCondition;
  String? kitchenHeatingDescription;
  String? kitchenAccessoriesCondition;
  String? kitchenAccessoriesDescription;
  String? kitchenFlooringCondition;
  String? kitchenFlooringDescription;
  String? kitchenAdditionItemsCondition;
  String? kitchenAdditionItemsDescription;
  List<String> kitchenDoorImages = [];
  List<String> kitchenDoorFrameImages = [];
  List<String> kitchenCeilingImages = [];
  List<String> kitchenExtractorFanImages = [];
  List<String> kitchenLightingImages = [];
  List<String> kitchenWallsImages = [];
  List<String> kitchenSkirtingImages = [];
  List<String> kitchenWindowSillImages = [];
  List<String> ktichenCurtainsImages = [];
  List<String> kitchenBlindsImages = [];
  List<String> kitchenToiletImages = [];
  List<String> kitchenBasinImages = [];
  List<String> kitchenShowerCubicleImages = [];
  List<String> kitchenBathImages = [];
  List<String> kitchenSwitchBoardImages = [];
  List<String> kitchenSocketImages = [];
  List<String> kitchenHeatingImages = [];
  List<String> kitchenAccessoriesImages = [];
  List<String> kitchenFlooringImages = [];
  List<String> kitchenAdditionItemsImages = [];
  late List<File> kitchenCapturedImages;

  @override
  void initState() {
    super.initState();
    kitchenCapturedImages = widget.kitchenCapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Load saved preferences
  Future<void> _loadPreferences(String propertyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      kitchenNewDoor = prefs.getString('kitchenNewDoor_${propertyId}');
      kitchenDoorCondition =
          prefs.getString('kitchenDoorCondition_${propertyId}');
      kitchenDoorDescription =
          prefs.getString('kitchenDoorDescription_${propertyId}');
      kitchenDoorFrameCondition =
          prefs.getString('kitchenDoorFrameCondition_${propertyId}');
      kitchenDoorFrameDescription =
          prefs.getString('kitchenDoorFrameDescription_${propertyId}');
      kitchenCeilingCondition =
          prefs.getString('kitchenCeilingCondition_${propertyId}');
      kitchenCeilingDescription =
          prefs.getString('kitchenCeilingDescription_${propertyId}');
      kitchenExtractorFanCondition =
          prefs.getString('kitchenExtractorFanCondition_${propertyId}');
      kitchenExtractorFanDescription =
          prefs.getString('kitchenExtractorFanDescription_${propertyId}');
      kitchenLightingCondition =
          prefs.getString('kitchenLightingCondition_${propertyId}');
      kitchenLightingDescription =
          prefs.getString('kitchenLightingDescription_${propertyId}');
      kitchenWallsCondition =
          prefs.getString('kitchenWallsCondition_${propertyId}');
      kitchenWallsDescription =
          prefs.getString('kitchenWallsDescription_${propertyId}');
      kitchenSkirtingCondition =
          prefs.getString('kitchenSkirtingCondition_${propertyId}');
      kitchenSkirtingDescription =
          prefs.getString('kitchenSkirtingDescription_${propertyId}');
      kitchenWindowSillCondition =
          prefs.getString('kitchenWindowSillCondition_${propertyId}');
      kitchenWindowSillDescription =
          prefs.getString('kitchenWindowSillDescription_${propertyId}');
      kitchenCurtainsCondition =
          prefs.getString('kitchenCurtainsCondition_${propertyId}');
      kitchenCurtainsDescription =
          prefs.getString('kitchenCurtainsDescription_${propertyId}');
      kitchenBlindsCondition =
          prefs.getString('kitchenBlindsCondition_${propertyId}');
      kitchenBlindsDescription =
          prefs.getString('kitchenBlindsDescription_${propertyId}');
      kitchenToiletCondition =
          prefs.getString('kitchenToiletCondition_${propertyId}');
      kitchenToiletDescription =
          prefs.getString('kitchenToiletDescription_${propertyId}');
      kitchenBasinCondition =
          prefs.getString('kitchenBasinCondition_${propertyId}');
      kitchenBasinDescription =
          prefs.getString('kitchenBasinDescription_${propertyId}');
      kitchenShowerCubicleCondition =
          prefs.getString('kitchenShowerCubicleCondition_${propertyId}');
      kitchenShowerCubicleDescription =
          prefs.getString('kitchenShowerCubicleDescription_${propertyId}');
      kitchenBathCondition =
          prefs.getString('kitchenBathCondition_${propertyId}');
      kitchenBathDescription =
          prefs.getString('kitchenBathDescription_${propertyId}');
      kitchenSwitchBoardCondition =
          prefs.getString('kitchenSwitchBoardCondition_${propertyId}');
      kitchenSwitchBoardDescription =
          prefs.getString('kitchenSwitchBoardDescription_${propertyId}');
      kitchenSocketCondition =
          prefs.getString('kitchenSocketCondition_${propertyId}');
      kitchenSocketDescription =
          prefs.getString('kitchenSocketDescription_${propertyId}');
      kitchenHeatingCondition =
          prefs.getString('kitchenHeatingCondition_${propertyId}');
      kitchenHeatingDescription =
          prefs.getString('kitchenHeatingDescription_${propertyId}');
      kitchenAccessoriesCondition =
          prefs.getString('kitchenAccessoriesCondition_${propertyId}');
      kitchenAccessoriesDescription =
          prefs.getString('kitchenAccessoriesDescription_${propertyId}');
      kitchenFlooringCondition =
          prefs.getString('kitchenFlooringCondition_${propertyId}');
      kitchenFlooringDescription =
          prefs.getString('kitchenFlooringDescription_${propertyId}');
      kitchenAdditionItemsCondition =
          prefs.getString('kitchenAdditionItemsCondition_${propertyId}');
      kitchenAdditionItemsDescription =
          prefs.getString('kitchenAdditionItemsDescription_${propertyId}');

      kitchenDoorImages =
          prefs.getStringList('kitchenDoorImages_${propertyId}') ?? [];
      kitchenDoorFrameImages =
          prefs.getStringList('kitchenDoorFrameImages_${propertyId}') ?? [];
      kitchenCeilingImages =
          prefs.getStringList('kitchenCeilingImages_${propertyId}') ?? [];
      kitchenExtractorFanImages =
          prefs.getStringList('kitchenExtractorFanImages_${propertyId}') ?? [];
      kitchenLightingImages =
          prefs.getStringList('kitchenLightingImages_${propertyId}') ?? [];
      kitchenWallsImages =
          prefs.getStringList('kitchenWallsImages_${propertyId}') ?? [];
      kitchenSkirtingImages =
          prefs.getStringList('kitchenSkirtingImages_${propertyId}') ?? [];
      kitchenWindowSillImages =
          prefs.getStringList('kitchenWindowSillImages_${propertyId}') ?? [];
      ktichenCurtainsImages =
          prefs.getStringList('ktichenCurtainsImages_${propertyId}') ?? [];
      kitchenBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      kitchenToiletImages =
          prefs.getStringList('kitchenToiletImages_${propertyId}') ?? [];
      kitchenBasinImages =
          prefs.getStringList('kitchenBasinImages_${propertyId}') ?? [];
      kitchenShowerCubicleImages =
          prefs.getStringList('kitchenShowerCubicleImages_${propertyId}') ?? [];
      kitchenBathImages =
          prefs.getStringList('kitchenBathImages_${propertyId}') ?? [];
      kitchenSwitchBoardImages =
          prefs.getStringList('kitchenSwitchBoardImages_${propertyId}') ?? [];
      kitchenSocketImages =
          prefs.getStringList('kitchenSocketImages_${propertyId}') ?? [];
      kitchenHeatingImages =
          prefs.getStringList('kitchenHeatingImages_${propertyId}') ?? [];
      kitchenAccessoriesImages =
          prefs.getStringList('kitchenAccessoriesImages_${propertyId}') ?? [];
      kitchenFlooringImages =
          prefs.getStringList('kitchenFlooringImages_${propertyId}') ?? [];
      kitchenAdditionItemsImages =
          prefs.getStringList('kitchenAdditionItemsImages_${propertyId}') ?? [];
    });
  }

  // Save preferences when a condition is selected
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
          'Kitchen',
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
              // Door
              ConditionItem(
                name: "Door",
                condition: kitchenDoorCondition,
                description: kitchenNewDoor,
                images: kitchenDoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenDoorCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenDoorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenNewDoor = description;
                  });
                  _savePreference(propertyId, 'kitchenNewDoor', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenDoorImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenDoorImages', kitchenDoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: kitchenDoorFrameCondition,
                description: kitchenDoorFrameDescription,
                images: kitchenDoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenDoorFrameCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenDoorFrameCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenDoorFrameDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenDoorFrameDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenDoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenDoorFrameImages',
                      kitchenDoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: kitchenCeilingCondition,
                description: kitchenCeilingDescription,
                images: kitchenCeilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenCeilingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenCeilingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenCeilingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenCeilingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenCeilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenCeilingImages', kitchenCeilingImages);
                },
              ),

              // Extractor Fan
              ConditionItem(
                name: "Extractor Fan",
                condition: kitchenExtractorFanCondition,
                description: kitchenExtractorFanDescription,
                images: kitchenExtractorFanImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenExtractorFanCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenExtractorFanCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenExtractorFanDescription = description;
                  });
                  _savePreference(propertyId, 'kitchenExtractorFanDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenExtractorFanImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenExtractorFanImages',
                      kitchenExtractorFanImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: kitchenLightingCondition,
                description: kitchenLightingDescription,
                images: kitchenLightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenLightingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenLightingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenLightingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenLightingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenLightingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenLightingImages',
                      kitchenLightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: kitchenWallsCondition,
                description: kitchenWallsDescription,
                images: kitchenWallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenWallsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenWallsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenWallsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenWallsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenWallsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenWallsImages', kitchenWallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: kitchenSkirtingCondition,
                description: kitchenSkirtingDescription,
                images: kitchenSkirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenSkirtingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenSkirtingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenSkirtingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenSkirtingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenSkirtingImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenSkirtingImages',
                      kitchenSkirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: kitchenWindowSillCondition,
                description: kitchenWindowSillDescription,
                images: kitchenWindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenWindowSillCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenWindowSillCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenWindowSillDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenWindowSillDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenWindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenWindowSillImages',
                      kitchenWindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: kitchenCurtainsCondition,
                description: kitchenCurtainsDescription,
                images: ktichenCurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenCurtainsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenCurtainsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenCurtainsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenCurtainsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ktichenCurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'ktichenCurtainsImages',
                      ktichenCurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: kitchenBlindsCondition,
                description: kitchenBlindsDescription,
                images: kitchenBlindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenBlindsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenBlindsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenBlindsDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenBlindsDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenBlindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'blindsImages', kitchenBlindsImages);
                },
              ),

              // Toilet
              ConditionItem(
                name: "Toilet",
                condition: kitchenToiletCondition,
                description: kitchenToiletDescription,
                images: kitchenToiletImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenToiletCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenToiletCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenToiletDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenToiletDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenToiletImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenToiletImages', kitchenToiletImages);
                },
              ),

              // Basin
              ConditionItem(
                name: "Basin",
                condition: kitchenBasinCondition,
                description: kitchenBasinDescription,
                images: kitchenBasinImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenBasinCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenBasinCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenBasinDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenBasinDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenBasinImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenBasinImages', kitchenBasinImages);
                },
              ),

              // Shower Cubicle
              ConditionItem(
                name: "Shower Cubicle",
                condition: kitchenShowerCubicleCondition,
                description: kitchenShowerCubicleDescription,
                images: kitchenShowerCubicleImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenShowerCubicleCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenShowerCubicleCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenShowerCubicleDescription = description;
                  });
                  _savePreference(propertyId, 'kitchenShowerCubicleDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenShowerCubicleImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenShowerCubicleImages',
                      kitchenShowerCubicleImages);
                },
              ),

              // Bath
              ConditionItem(
                name: "Bath",
                condition: kitchenBathCondition,
                description: kitchenBathDescription,
                images: kitchenBathImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenBathCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenBathCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenBathDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenBathDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenBathImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenBathImages', kitchenBathImages);
                },
              ),

              // Switch Board
              ConditionItem(
                name: "Switch Board",
                condition: kitchenSwitchBoardCondition,
                description: kitchenSwitchBoardDescription,
                images: kitchenSwitchBoardImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenSwitchBoardCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenSwitchBoardCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenSwitchBoardDescription = description;
                  });
                  _savePreference(propertyId, 'kitchenSwitchBoardDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenSwitchBoardImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenSwitchBoardImages',
                      kitchenSwitchBoardImages);
                },
              ),

              // Socket
              ConditionItem(
                name: "Socket",
                condition: kitchenSocketCondition,
                description: kitchenSocketDescription,
                images: kitchenSocketImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenSocketCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenSocketCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenSocketDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenSocketDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenSocketImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenSocketImages', kitchenSocketImages);
                },
              ),

              // Heating
              ConditionItem(
                name: "Heating",
                condition: kitchenHeatingCondition,
                description: kitchenHeatingDescription,
                images: kitchenHeatingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenHeatingCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenHeatingCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenHeatingDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenHeatingDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenHeatingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      propertyId, 'kitchenHeatingImages', kitchenHeatingImages);
                },
              ),

              // Accessories
              ConditionItem(
                name: "Accessories",
                condition: kitchenAccessoriesCondition,
                description: kitchenAccessoriesDescription,
                images: kitchenAccessoriesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenAccessoriesCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenAccessoriesCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenAccessoriesDescription = description;
                  });
                  _savePreference(propertyId, 'kitchenAccessoriesDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenAccessoriesImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenAccessoriesImages',
                      kitchenAccessoriesImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: kitchenFlooringCondition,
                description: kitchenFlooringDescription,
                images: kitchenFlooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenFlooringCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenFlooringCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenFlooringDescription = description;
                  });
                  _savePreference(
                      propertyId, 'kitchenFlooringDescription', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenFlooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenFlooringImages',
                      kitchenFlooringImages);
                },
              ),

              // Addition Items
              ConditionItem(
                name: "Addition Items",
                condition: kitchenAdditionItemsCondition,
                description: kitchenAdditionItemsDescription,
                images: kitchenAdditionItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenAdditionItemsCondition = condition;
                  });
                  _savePreference(
                      propertyId, 'kitchenAdditionItemsCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenAdditionItemsDescription = description;
                  });
                  _savePreference(propertyId, 'kitchenAdditionItemsDescription',
                      description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenAdditionItemsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'kitchenAdditionItemsImages',
                      kitchenAdditionItemsImages);
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
