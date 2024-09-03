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

class MeterReading extends StatefulWidget {
  final List<File>? capturedImages;

  const MeterReading({super.key, this.capturedImages});

  @override
  State<MeterReading> createState() => _MeterReadingState();
}

class _MeterReadingState extends State<MeterReading> {
  String? houseApplinceManual;
  String? kitchenApplinceManual;
  String? heatingManual;
  String? landlordGasSafetyCertificate;
  String? legionellaRiskAssessment;
  String? electricalSafetyCertificate;
  String? energyPerformanceCertificate;
  String? moveInChecklist;
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
      houseApplinceManual = prefs.getString('houseApplinceManual');
      kitchenApplinceManual = prefs.getString('kitchenApplinceManual');
      heatingManual = prefs.getString('heatingManual');
      landlordGasSafetyCertificate =
          prefs.getString('landlordGasSafetyCertificate');
      legionellaRiskAssessment = prefs.getString('legionellaRiskAssessment');
      electricalSafetyCertificate =
          prefs.getString('electricalSafetyCertificate');
      energyPerformanceCertificate =
          prefs.getString('energyPerformanceCertificate');
      moveInChecklist = prefs.getString('moveInChecklist');
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
              //House Appliance Manual
              ConditionItem(
                name: "House Appliance Manual",
                selectedCondition: houseApplinceManual,
                onConditionSelected: (condition) {
                  setState(() {
                    houseApplinceManual = condition;
                  });
                  _savePreference(
                      'houseApplinceManual', condition); // Save preference
                },
              ),

              //Kitchen Appliance Manual
              ConditionItem(
                name: "Kitchen Appliance Manual",
                selectedCondition: kitchenApplinceManual,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenApplinceManual = condition;
                  });
                  _savePreference(
                      'kitchenApplinceManual', condition); // Save preference
                },
              ),

              //Heating Manual
              ConditionItem(
                name: "Heating Manual",
                selectedCondition: heatingManual,
                onConditionSelected: (condition) {
                  setState(() {
                    heatingManual = condition;
                  });
                  _savePreference(
                      'heatingManual', condition); // Save preference
                },
              ),

              //Landlord Gas Safety Certificate
              ConditionItem(
                name: "Landlord Gas Safety Certificate",
                selectedCondition: landlordGasSafetyCertificate,
                onConditionSelected: (condition) {
                  setState(() {
                    landlordGasSafetyCertificate = condition;
                  });
                  _savePreference('landlordGasSafetyCertificate',
                      condition); // Save preference
                },
              ),

              //Legionella Risk Assessment
              ConditionItem(
                name: "Legionella Risk Assessment",
                selectedCondition: legionellaRiskAssessment,
                onConditionSelected: (condition) {
                  setState(() {
                    legionellaRiskAssessment = condition;
                  });
                  _savePreference(
                      'legionellaRiskAssessment', condition); // Save preference
                },
              ),

              //Electrical Safety Certificate
              ConditionItem(
                name: "Electrical Safety Certificate",
                selectedCondition: electricalSafetyCertificate,
                onConditionSelected: (condition) {
                  setState(() {
                    electricalSafetyCertificate = condition;
                  });
                  _savePreference('electricalSafetyCertificate',
                      condition); // Save preference
                },
              ),

              //Energy Performance Certificate
              ConditionItem(
                name: "Energy Performance Certificate",
                selectedCondition: energyPerformanceCertificate,
                onConditionSelected: (condition) {
                  setState(() {
                    energyPerformanceCertificate = condition;
                  });
                  _savePreference('energyPerformanceCertificate',
                      condition); // Save preference
                },
              ),

              //Move In Checklist
              ConditionItem(
                name: "Move In Checklist",
                selectedCondition: moveInChecklist,
                onConditionSelected: (condition) {
                  setState(() {
                    moveInChecklist = condition;
                  });
                  _savePreference(
                      'moveInChecklist', condition); // Save preference
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
