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

class Toilet extends StatefulWidget {
  final List<File>? capturedImages;

  const Toilet({super.key, this.capturedImages});

  @override
  State<Toilet> createState() => _ToiletState();
}

class _ToiletState extends State<Toilet> {
  String? door;
  String? doorFrame;
  String? ceiling;
  String? extractorFan;
  String? lighting;
  String? walls;
  String? skirting;
  String? windowSill;
  String? curtains;
  String? blinds;
  String? toilet;
  String? basin;
  String? showerCubicle;
  String? bath;
  String? switchBoard;
  String? socket;
  String? heating;
  String? accessories;
  String? flooring;
  String? additionItems;
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
      door = prefs.getString('door');
      doorFrame = prefs.getString('doorFrame');
      ceiling = prefs.getString('ceiling');
      extractorFan = prefs.getString('extractorFan');
      lighting = prefs.getString('lighting');
      walls = prefs.getString('walls');
      skirting = prefs.getString('skirting');
      windowSill = prefs.getString('windowSill');
      curtains = prefs.getString('curtains');
      blinds = prefs.getString('blinds');
      toilet = prefs.getString('toilet');
      basin = prefs.getString('basin');
      showerCubicle = prefs.getString('showerCubicle');
      bath = prefs.getString('bath');
      switchBoard = prefs.getString('switchBoard');
      socket = prefs.getString('socket');
      heating = prefs.getString('heating');
      accessories = prefs.getString('accessories');
      flooring = prefs.getString('flooring');
      additionItems = prefs.getString('additionItems');
    });
  }

  // Save preferences when a condition is selected
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
                selectedCondition: door,
                onConditionSelected: (condition) {
                  setState(() {
                    door = condition;
                  });
                  _savePreference('door', condition);
                },
              ),

              // Electric Meter
              ConditionItem(
                name: "Door Frame",
                selectedCondition: doorFrame,
                onConditionSelected: (condition) {
                  setState(() {
                    doorFrame = condition;
                  });
                  _savePreference('doorFrame', condition);
                },
              ),

              // Water Meter
              ConditionItem(
                name: "Ceiling",
                selectedCondition: ceiling,
                onConditionSelected: (condition) {
                  setState(() {
                    ceiling = condition;
                  });
                  _savePreference('ceiling', condition);
                },
              ),

              // Oil Meter
              ConditionItem(
                name: "Extractor Fan",
                selectedCondition: extractorFan,
                onConditionSelected: (condition) {
                  setState(() {
                    extractorFan = condition;
                  });
                  _savePreference('extractorFan', condition);
                },
              ),

              //Lighting
              ConditionItem(
                name: "Lighting",
                selectedCondition: lighting,
                onConditionSelected: (condition) {
                  setState(() {
                    lighting = condition;
                  });
                  _savePreference('lighting', condition);
                },
              ),

              //Walls
              ConditionItem(
                name: "Walls",
                selectedCondition: walls,
                onConditionSelected: (condition) {
                  setState(() {
                    walls = condition;
                  });
                  _savePreference('walls', condition);
                },
              ),

              //Skirting
              ConditionItem(
                name: "Skirting",
                selectedCondition: skirting,
                onConditionSelected: (condition) {
                  setState(() {
                    skirting = condition;
                  });
                  _savePreference('skirting', condition);
                },
              ),

              //Window Sill
              ConditionItem(
                name: "Window Sill",
                selectedCondition: windowSill,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSill = condition;
                  });
                  _savePreference('windowSill', condition);
                },
              ),

              //Curtains
              ConditionItem(
                name: "Curtains",
                selectedCondition: curtains,
                onConditionSelected: (condition) {
                  setState(() {
                    curtains = condition;
                  });
                  _savePreference('curtains', condition);
                },
              ),

              //Blinds
              ConditionItem(
                name: "Blinds",
                selectedCondition: blinds,
                onConditionSelected: (condition) {
                  setState(() {
                    blinds = condition;
                  });
                  _savePreference('blinds', condition);
                },
              ),

              //Toilet
              ConditionItem(
                name: "Toilet",
                selectedCondition: toilet,
                onConditionSelected: (condition) {
                  setState(() {
                    toilet = condition;
                  });
                  _savePreference('toilet', condition);
                },
              ),

              //Basin
              ConditionItem(
                name: "Basin",
                selectedCondition: basin,
                onConditionSelected: (condition) {
                  setState(() {
                    basin = condition;
                  });
                  _savePreference('basin', condition);
                },
              ),

              //Shower Cubicle
              ConditionItem(
                name: "Shower Cubicle",
                selectedCondition: showerCubicle,
                onConditionSelected: (condition) {
                  setState(() {
                    showerCubicle = condition;
                  });
                  _savePreference('showerCubicle', condition);
                },
              ),

              //Bath
              ConditionItem(
                name: "Bath",
                selectedCondition: bath,
                onConditionSelected: (condition) {
                  setState(() {
                    bath = condition;
                  });
                  _savePreference('bath', condition);
                },
              ),

              //Switch Board
              ConditionItem(
                name: "Switch Board",
                selectedCondition: switchBoard,
                onConditionSelected: (condition) {
                  setState(() {
                    switchBoard = condition;
                  });
                  _savePreference('switchBoard', condition);
                },
              ),

              //Socket
              ConditionItem(
                name: "Socket",
                selectedCondition: socket,
                onConditionSelected: (condition) {
                  setState(() {
                    socket = condition;
                  });
                  _savePreference('socket', condition);
                },
              ),

              //Heating
              ConditionItem(
                name: "Heating",
                selectedCondition: heating,
                onConditionSelected: (condition) {
                  setState(() {
                    heating = condition;
                  });
                  _savePreference('heating', condition);
                },
              ),

              //Accessories
              ConditionItem(
                name: "Accessories",
                selectedCondition: accessories,
                onConditionSelected: (condition) {
                  setState(() {
                    accessories = condition;
                  });
                  _savePreference('accessories', condition);
                },
              ),

              //Flooring
              ConditionItem(
                name: "Flooring",
                selectedCondition: flooring,
                onConditionSelected: (condition) {
                  setState(() {
                    flooring = condition;
                  });
                  _savePreference('flooring', condition);
                },
              ),

              //Addition Items
              ConditionItem(
                name: "Addition Items",
                selectedCondition: additionItems,
                onConditionSelected: (condition) {
                  setState(() {
                    additionItems = condition;
                  });
                  _savePreference('additionItems', condition);
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
  final String? selectedCondition;
  final Function(String?) onConditionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.selectedCondition,
    required this.onConditionSelected,
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
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Location",
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
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Serial Number",
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
                    initialCondition: selectedCondition,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onConditionSelected(result);
              }
            },
            child: Text(
              selectedCondition ?? "Reading",
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
