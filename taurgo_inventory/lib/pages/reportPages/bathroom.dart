import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import '../camera_preview_page.dart';

class Bathroom extends StatefulWidget {
  final List<File>? capturedImages;

  const Bathroom({super.key, this.capturedImages});

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
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    _loadPreferences(); // Load preferences on init
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      additionItemsCondition = prefs.getString('additionItemsCondition');
      additionItemsDescription = prefs.getString('additionItemsDescription');
    });
  }

  // Save preferences when a condition or description is selected
  Future<void> _savePreference(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value ?? '');
  }

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => EditReportPage(),
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
                onConditionSelected: (condition) {
                  setState(() {
                    doorCondition = condition;
                  });
                  _savePreference('doorCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorDescription = description;
                  });
                  _savePreference('doorDescription', description);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: doorFrameCondition,
                description: doorFrameDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrameCondition = condition;
                  });
                  _savePreference('doorFrameCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    doorFrameDescription = description;
                  });
                  _savePreference('doorFrameDescription', description);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: ceilingCondition,
                description: ceilingDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilingCondition = condition;
                  });
                  _savePreference('ceilingCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    ceilingDescription = description;
                  });
                  _savePreference('ceilingDescription', description);
                },
              ),

              // Extractor Fan
              ConditionItem(
                name: "Extractor Fan",
                condition: extractorFanCondition,
                description: extractorFanDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    extractorFanCondition = condition;
                  });
                  _savePreference('extractorFanCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    extractorFanDescription = description;
                  });
                  _savePreference('extractorFanDescription', description);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: lightingCondition,
                description: lightingDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    lightingCondition = condition;
                  });
                  _savePreference('lightingCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    lightingDescription = description;
                  });
                  _savePreference('lightingDescription', description);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: wallsCondition,
                description: wallsDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    wallsCondition = condition;
                  });
                  _savePreference('wallsCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    wallsDescription = description;
                  });
                  _savePreference('wallsDescription', description);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: skirtingCondition,
                description: skirtingDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    skirtingCondition = condition;
                  });
                  _savePreference('skirtingCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    skirtingDescription = description;
                  });
                  _savePreference('skirtingDescription', description);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: windowSillCondition,
                description: windowSillDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSillCondition = condition;
                  });
                  _savePreference('windowSillCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    windowSillDescription = description;
                  });
                  _savePreference('windowSillDescription', description);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: curtainsCondition,
                description: curtainsDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    curtainsCondition = condition;
                  });
                  _savePreference('curtainsCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    curtainsDescription = description;
                  });
                  _savePreference('curtainsDescription', description);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: blindsCondition,
                description: blindsDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    blindsCondition = condition;
                  });
                  _savePreference('blindsCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    blindsDescription = description;
                  });
                  _savePreference('blindsDescription', description);
                },
              ),

              // Toilet
              ConditionItem(
                name: "Toilet",
                condition: toiletCondition,
                description: toiletDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    toiletCondition = condition;
                  });
                  _savePreference('toiletCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    toiletDescription = description;
                  });
                  _savePreference('toiletDescription', description);
                },
              ),

              // Basin
              ConditionItem(
                name: "Basin",
                condition: basinCondition,
                description: basinDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    basinCondition = condition;
                  });
                  _savePreference('basinCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    basinDescription = description;
                  });
                  _savePreference('basinDescription', description);
                },
              ),

              // Shower Cubicle
              ConditionItem(
                name: "Shower Cubicle",
                condition: showerCubicleCondition,
                description: showerCubicleDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    showerCubicleCondition = condition;
                  });
                  _savePreference('showerCubicleCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    showerCubicleDescription = description;
                  });
                  _savePreference('showerCubicleDescription', description);
                },
              ),

              // Bath
              ConditionItem(
                name: "Bath",
                condition: bathCondition,
                description: bathDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    bathCondition = condition;
                  });
                  _savePreference('bathCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    bathDescription = description;
                  });
                  _savePreference('bathDescription', description);
                },
              ),

              // Switch Board
              ConditionItem(
                name: "Switch Board",
                condition: switchBoardCondition,
                description: switchBoardDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    switchBoardCondition = condition;
                  });
                  _savePreference('switchBoardCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    switchBoardDescription = description;
                  });
                  _savePreference('switchBoardDescription', description);
                },
              ),

              // Socket
              ConditionItem(
                name: "Socket",
                condition: socketCondition,
                description: socketDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    socketCondition = condition;
                  });
                  _savePreference('socketCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    socketDescription = description;
                  });
                  _savePreference('socketDescription', description);
                },
              ),

              // Heating
              ConditionItem(
                name: "Heating",
                condition: heatingCondition,
                description: heatingDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    heatingCondition = condition;
                  });
                  _savePreference('heatingCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatingDescription = description;
                  });
                  _savePreference('heatingDescription', description);
                },
              ),

              // Accessories
              ConditionItem(
                name: "Accessories",
                condition: accessoriesCondition,
                description: accessoriesDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    accessoriesCondition = condition;
                  });
                  _savePreference('accessoriesCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    accessoriesDescription = description;
                  });
                  _savePreference('accessoriesDescription', description);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: flooringCondition,
                description: flooringDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    flooringCondition = condition;
                  });
                  _savePreference('flooringCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    flooringDescription = description;
                  });
                  _savePreference('flooringDescription', description);
                },
              ),

              // Addition Items
              ConditionItem(
                name: "Addition Items",
                condition: additionItemsCondition,
                description: additionItemsDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    additionItemsCondition = condition;
                  });
                  _savePreference('additionItemsCondition', condition);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    additionItemsDescription = description;
                  });
                  _savePreference('additionItemsDescription', description);
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
  final Function(String?) onConditionSelected;
  final Function(String?) onDescriptionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.description,
    required this.onConditionSelected,
    required this.onDescriptionSelected,
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
                      // Initialize the camera when the button is pressed
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        print("${cameras.toString()}");
                        final cameraController = CameraController(
                          cameras.first,
                          ResolutionPreset.high,
                        );
                        await cameraController.initialize();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPreviewPage(
                              cameraController: cameraController,
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
          Divider(thickness: 1, color: Color(0xFFC2C2C2)),
        ],
      ),
    );
  }
}
