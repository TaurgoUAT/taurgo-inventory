import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import '../camera_preview_page.dart';

class RearGarden extends StatefulWidget {
  final List<File>? capturedImages;

  const RearGarden({super.key, this.capturedImages});

  @override
  State<RearGarden> createState() => _RearGardenState();
}

class _RearGardenState extends State<RearGarden> {
  String? gardenDescription;
  String? outsideLighting;
  String? summerHouse;
  String? shed;
  String? additionalInformation;
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
      gardenDescription = prefs.getString('gardenDescription');
      outsideLighting = prefs.getString('outsideLighting');
      summerHouse = prefs.getString('summerHouse');
      shed = prefs.getString('shed');
      additionalInformation = prefs.getString('additionalInformation');
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bed Room',
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
              //Garden Description
              ConditionItem(
                name: "Garden Description",
                selectedCondition: gardenDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    gardenDescription = condition;
                  });
                  _savePreference(
                      'gardenDescription', condition); // Save preference
                },
              ),

              //Outside Lighting
              ConditionItem(
                name: "Outside Lighting",
                selectedCondition: outsideLighting,
                onConditionSelected: (condition) {
                  setState(() {
                    outsideLighting = condition;
                  });
                  _savePreference(
                      'outsideLighting', condition); // Save preference
                },
              ),

              //Summer House
              ConditionItem(
                name: "Summer House",
                selectedCondition: summerHouse,
                onConditionSelected: (condition) {
                  setState(() {
                    summerHouse = condition;
                  });
                  _savePreference('summerHouse', condition); // Save preference
                },
              ),

              //Shed
              ConditionItem(
                name: "Shed",
                selectedCondition: shed,
                onConditionSelected: (condition) {
                  setState(() {
                    shed = condition;
                  });
                  _savePreference('shed', condition); // Save preference
                },
              ),

              //Additional Information
              ConditionItem(
                name: "Additional Information",
                selectedCondition: additionalInformation,
                onConditionSelected: (condition) {
                  setState(() {
                    additionalInformation = condition;
                  });
                  _savePreference(
                      'additionalInformation', condition); // Save preference
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
