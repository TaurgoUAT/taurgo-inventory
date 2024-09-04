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

class Manuals extends StatefulWidget {
  final List<File>? capturedImages;

  const Manuals({super.key, this.capturedImages});

  @override
  State<Manuals> createState() => _ManualsState();
}

class _ManualsState extends State<Manuals> {
  String? houseApplinceManual;
  String? houseApplinceManualDescription;
  String? kitchenApplinceManual;
  String? kitchenApplinceManualDescription;
  String? heatingManual;
  String? heatingManualDescription;
  String? landlordGasSafetyCertificate;
  String? landlordGasSafetyCertificateDescription;
  String? legionellaRiskAssessment;
  String? legionellaRiskAssessmentDescription;
  String? electricalSafetyCertificate;
  String? electricalSafetyCertificateDescription;
  String? energyPerformanceCertificate;
  String? energyPerformanceCertificateDescription;
  String? moveInChecklist;
  String? moveInChecklistDescription;
  List<String> houseApplinceManualImages = [];
  List<String> kitchenApplinceManualImages = [];
  List<String> heatingManualImages = [];
  List<String> landlordGasSafetyCertificateImages = [];
  List<String> legionellaRiskAssessmentImages = [];
  List<String> electricalSafetyCertificateImages = [];
  List<String> energyPerformanceCertificateImages = [];
  List<String> moveInChecklistImages = [];
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
      houseApplinceManualDescription = prefs.getString('houseApplinceManualDescription');
      kitchenApplinceManual = prefs.getString('kitchenApplinceManual');
      kitchenApplinceManualDescription = prefs.getString('kitchenApplinceManualDescription');
      heatingManual = prefs.getString('heatingManual');
      heatingManualDescription = prefs.getString('heatingManualDescription');
      landlordGasSafetyCertificate = prefs.getString('landlordGasSafetyCertificate');
      landlordGasSafetyCertificateDescription = prefs.getString('landlordGasSafetyCertificateDescription');
      legionellaRiskAssessment = prefs.getString('legionellaRiskAssessment');
      legionellaRiskAssessmentDescription = prefs.getString('legionellaRiskAssessmentDescription');
      electricalSafetyCertificate = prefs.getString('electricalSafetyCertificate');
      electricalSafetyCertificateDescription = prefs.getString('electricalSafetyCertificateDescription');
      energyPerformanceCertificate = prefs.getString('energyPerformanceCertificate');
      energyPerformanceCertificateDescription = prefs.getString('energyPerformanceCertificateDescription');
      moveInChecklist = prefs.getString('moveInChecklist');
      moveInChecklistDescription = prefs.getString('moveInChecklistDescription');

      houseApplinceManualImages = prefs.getStringList('houseApplinceManualImages') ?? [];
      kitchenApplinceManualImages = prefs.getStringList('kitchenApplinceManualImages') ?? [];
      heatingManualImages = prefs.getStringList('heatingManualImages') ?? [];
      landlordGasSafetyCertificateImages = prefs.getStringList('landlordGasSafetyCertificateImages') ?? [];
      legionellaRiskAssessmentImages = prefs.getStringList('legionellaRiskAssessmentImages') ?? [];
      electricalSafetyCertificateImages = prefs.getStringList('electricalSafetyCertificateImages') ?? [];
      energyPerformanceCertificateImages = prefs.getStringList('energyPerformanceCertificateImages') ?? [];
      moveInChecklistImages = prefs.getStringList('moveInChecklistImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
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
          'Manuals',
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
                condition: houseApplinceManual,
                description: houseApplinceManualDescription,
                images: houseApplinceManualImages,
                onConditionSelected: (condition) {
                  setState(() {
                    houseApplinceManual = condition;
                  });
                  _savePreference('houseApplinceManual', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    houseApplinceManualDescription = description;
                  });
                  _savePreference('houseApplinceManualDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    houseApplinceManualImages.add(imagePath);
                  });
                  _savePreferenceList('houseApplinceManualImages', houseApplinceManualImages);
                },
              ),

              // Kitchen Appliance Manual
              ConditionItem(
                name: "Kitchen Appliance Manual",
                condition: kitchenApplinceManual,
                description: kitchenApplinceManualDescription,
                images: kitchenApplinceManualImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenApplinceManual = condition;
                  });
                  _savePreference('kitchenApplinceManual', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenApplinceManualDescription = description;
                  });
                  _savePreference('kitchenApplinceManualDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenApplinceManualImages.add(imagePath);
                  });
                  _savePreferenceList('kitchenApplinceManualImages', kitchenApplinceManualImages);
                },
              ),

              // Heating Manual
              ConditionItem(
                name: "Heating Manual",
                condition: heatingManual,
                description: heatingManualDescription,
                images: heatingManualImages,
                onConditionSelected: (condition) {
                  setState(() {
                    heatingManual = condition;
                  });
                  _savePreference('heatingManual', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatingManualDescription = description;
                  });
                  _savePreference('heatingManualDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    heatingManualImages.add(imagePath);
                  });
                  _savePreferenceList('heatingManualImages', heatingManualImages);
                },
              ),

              // Landlord Gas Safety Certificate
              ConditionItem(
                name: "Landlord Gas Safety Certificate",
                condition: landlordGasSafetyCertificate,
                description: landlordGasSafetyCertificateDescription,
                images: landlordGasSafetyCertificateImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landlordGasSafetyCertificate = condition;
                  });
                  _savePreference('landlordGasSafetyCertificate', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landlordGasSafetyCertificateDescription = description;
                  });
                  _savePreference('landlordGasSafetyCertificateDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landlordGasSafetyCertificateImages.add(imagePath);
                  });
                  _savePreferenceList('landlordGasSafetyCertificateImages', landlordGasSafetyCertificateImages);
                },
              ),

              // Legionella Risk Assessment
              ConditionItem(
                name: "Legionella Risk Assessment",
                condition: legionellaRiskAssessment,
                description: legionellaRiskAssessmentDescription,
                images: legionellaRiskAssessmentImages,
                onConditionSelected: (condition) {
                  setState(() {
                    legionellaRiskAssessment = condition;
                  });
                  _savePreference('legionellaRiskAssessment', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    legionellaRiskAssessmentDescription = description;
                  });
                  _savePreference('legionellaRiskAssessmentDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    legionellaRiskAssessmentImages.add(imagePath);
                  });
                  _savePreferenceList('legionellaRiskAssessmentImages', legionellaRiskAssessmentImages);
                },
              ),

              // Electrical Safety Certificate
              ConditionItem(
                name: "Electrical Safety Certificate",
                condition: electricalSafetyCertificate,
                description: electricalSafetyCertificateDescription,
                images: electricalSafetyCertificateImages,
                onConditionSelected: (condition) {
                  setState(() {
                    electricalSafetyCertificate = condition;
                  });
                  _savePreference('electricalSafetyCertificate', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    electricalSafetyCertificateDescription = description;
                  });
                  _savePreference('electricalSafetyCertificateDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    electricalSafetyCertificateImages.add(imagePath);
                  });
                  _savePreferenceList('electricalSafetyCertificateImages', electricalSafetyCertificateImages);
                },
              ),

              // Energy Performance Certificate
              ConditionItem(
                name: "Energy Performance Certificate",
                condition: energyPerformanceCertificate,
                description: energyPerformanceCertificateDescription,
                images: energyPerformanceCertificateImages,
                onConditionSelected: (condition) {
                  setState(() {
                    energyPerformanceCertificate = condition;
                  });
                  _savePreference('energyPerformanceCertificate', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    energyPerformanceCertificateDescription = description;
                  });
                  _savePreference('energyPerformanceCertificateDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    energyPerformanceCertificateImages.add(imagePath);
                  });
                  _savePreferenceList('energyPerformanceCertificateImages', energyPerformanceCertificateImages);
                },
              ),

              // Move In Checklist
              ConditionItem(
                name: "Move In Checklist",
                condition: moveInChecklist,
                description: moveInChecklistDescription,
                images: moveInChecklistImages,
                onConditionSelected: (condition) {
                  setState(() {
                    moveInChecklist = condition;
                  });
                  _savePreference('moveInChecklist', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    moveInChecklistDescription = description;
                  });
                  _savePreference('moveInChecklistDescription', description); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    moveInChecklistImages.add(imagePath);
                  });
                  _savePreferenceList('moveInChecklistImages', moveInChecklistImages);
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