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

class Receripts extends StatefulWidget {
  final List<File>? capturedImages;

  const Receripts({super.key, this.capturedImages});

  @override
  State<Receripts> createState() => _ReceriptsState();
}

class _ReceriptsState extends State<Receripts> {
  String? houseApplinceManualCondition;
  String? houseApplinceManualDescription;
  String? kitchenApplinceManualCondition;
  String? kitchenApplinceManualDescription;
  String? heatingManualCondition;
  String? heatingManualDescription;
  String? landlordGasSafetyCertificateCondition;
  String? landlordGasSafetyCertificateDescription;
  String? legionellaRiskAssessmentCondition;
  String? legionellaRiskAssessmentDescription;
  String? electricalSafetyCertificateCondition;
  String? electricalSafetyCertificateDescription;
  String? energyPerformanceCertificateCondition;
  String? energyPerformanceCertificateDescription;
  String? moveInChecklistCondition;
  String? moveInChecklistDescription;
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
      houseApplinceManualCondition = prefs.getString('houseApplinceManualCondition');
      houseApplinceManualDescription = prefs.getString('houseApplinceManualDescription');
      kitchenApplinceManualCondition = prefs.getString('kitchenApplinceManualCondition');
      kitchenApplinceManualDescription = prefs.getString('kitchenApplinceManualDescription');
      heatingManualCondition = prefs.getString('heatingManualCondition');
      heatingManualDescription = prefs.getString('heatingManualDescription');
      landlordGasSafetyCertificateCondition = prefs.getString('landlordGasSafetyCertificateCondition');
      landlordGasSafetyCertificateDescription = prefs.getString('landlordGasSafetyCertificateDescription');
      legionellaRiskAssessmentCondition = prefs.getString('legionellaRiskAssessmentCondition');
      legionellaRiskAssessmentDescription = prefs.getString('legionellaRiskAssessmentDescription');
      electricalSafetyCertificateCondition = prefs.getString('electricalSafetyCertificateCondition');
      electricalSafetyCertificateDescription = prefs.getString('electricalSafetyCertificateDescription');
      energyPerformanceCertificateCondition = prefs.getString('energyPerformanceCertificateCondition');
      energyPerformanceCertificateDescription = prefs.getString('energyPerformanceCertificateDescription');
      moveInChecklistCondition = prefs.getString('moveInChecklistCondition');
      moveInChecklistDescription = prefs.getString('moveInChecklistDescription');
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
          'Receripts',
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
              // House Appliance Manual
              ConditionItem(
                name: "House Appliance Manual",
                condition: houseApplinceManualCondition,
                description: houseApplinceManualDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    houseApplinceManualCondition = condition;
                  });
                  _savePreference('houseApplinceManualCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    houseApplinceManualDescription = description;
                  });
                  _savePreference('houseApplinceManualDescription', description); // Save preference
                },
              ),

              // Kitchen Appliance Manual
              ConditionItem(
                name: "Kitchen Appliance Manual",
                condition: kitchenApplinceManualCondition,
                description: kitchenApplinceManualDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenApplinceManualCondition = condition;
                  });
                  _savePreference('kitchenApplinceManualCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenApplinceManualDescription = description;
                  });
                  _savePreference('kitchenApplinceManualDescription', description); // Save preference
                },
              ),

              // Heating Manual
              ConditionItem(
                name: "Heating Manual",
                condition: heatingManualCondition,
                description: heatingManualDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    heatingManualCondition = condition;
                  });
                  _savePreference('heatingManualCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatingManualDescription = description;
                  });
                  _savePreference('heatingManualDescription', description); // Save preference
                },
              ),

              // Landlord Gas Safety Certificate
              ConditionItem(
                name: "Landlord Gas Safety Certificate",
                condition: landlordGasSafetyCertificateCondition,
                description: landlordGasSafetyCertificateDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    landlordGasSafetyCertificateCondition = condition;
                  });
                  _savePreference('landlordGasSafetyCertificateCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landlordGasSafetyCertificateDescription = description;
                  });
                  _savePreference('landlordGasSafetyCertificateDescription', description); // Save preference
                },
              ),

              // Legionella Risk Assessment
              ConditionItem(
                name: "Legionella Risk Assessment",
                condition: legionellaRiskAssessmentCondition,
                description: legionellaRiskAssessmentDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    legionellaRiskAssessmentCondition = condition;
                  });
                  _savePreference('legionellaRiskAssessmentCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    legionellaRiskAssessmentDescription = description;
                  });
                  _savePreference('legionellaRiskAssessmentDescription', description); // Save preference
                },
              ),

              // Electrical Safety Certificate
              ConditionItem(
                name: "Electrical Safety Certificate",
                condition: electricalSafetyCertificateCondition,
                description: electricalSafetyCertificateDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    electricalSafetyCertificateCondition = condition;
                  });
                  _savePreference('electricalSafetyCertificateCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    electricalSafetyCertificateDescription = description;
                  });
                  _savePreference('electricalSafetyCertificateDescription', description); // Save preference
                },
              ),

              // Energy Performance Certificate
              ConditionItem(
                name: "Energy Performance Certificate",
                condition: energyPerformanceCertificateCondition,
                description: energyPerformanceCertificateDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    energyPerformanceCertificateCondition = condition;
                  });
                  _savePreference('energyPerformanceCertificateCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    energyPerformanceCertificateDescription = description;
                  });
                  _savePreference('energyPerformanceCertificateDescription', description); // Save preference
                },
              ),

              // Move In Checklist
              ConditionItem(
                name: "Move In Checklist",
                condition: moveInChecklistCondition,
                description: moveInChecklistDescription,
                onConditionSelected: (condition) {
                  setState(() {
                    moveInChecklistCondition = condition;
                  });
                  _savePreference('moveInChecklistCondition', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    moveInChecklistDescription = description;
                  });
                  _savePreference('moveInChecklistDescription', description); // Save preference
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
          SizedBox(height: 12,),
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
          SizedBox(height: 12,),
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