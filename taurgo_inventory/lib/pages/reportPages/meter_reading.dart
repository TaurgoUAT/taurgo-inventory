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
  String? houseApplinceManualLocation;
  String? houseApplinceManualReading;
  String? houseApplinceManualSerialNumber;
  String? kitchenApplinceManualLocation;
  String? kitchenApplinceManualReading;
  String? kitchenApplinceManualSerialNumber;
  String? heatingManualLocation;
  String? heatingManualReading;
  String? heatingManualSerialNumber;
  String? landlordGasSafetyCertificateLocation;
  String? landlordGasSafetyCertificateReading;
  String? landlordGasSafetyCertificateSerialNumber;
  String? legionellaRiskAssessmentLocation;
  String? legionellaRiskAssessmentReading;
  String? legionellaRiskAssessmentSerialNumber;
  String? electricalSafetyCertificateLocation;
  String? electricalSafetyCertificateReading;
  String? electricalSafetyCertificateSerialNumber;
  String? energyPerformanceCertificateLocation;
  String? energyPerformanceCertificateReading;
  String? energyPerformanceCertificateSerialNumber;
  String? moveInChecklistLocation;
  String? moveInChecklistReading;
  String? moveInChecklistSerialNumber;
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
      houseApplinceManualLocation =
          prefs.getString('houseApplinceManualLocation');
      houseApplinceManualReading =
          prefs.getString('houseApplinceManualReading');
      houseApplinceManualSerialNumber =
          prefs.getString('houseApplinceManualSerialNumber');
      kitchenApplinceManualLocation =
          prefs.getString('kitchenApplinceManualLocation');
      kitchenApplinceManualReading =
          prefs.getString('kitchenApplinceManualReading');
      kitchenApplinceManualSerialNumber =
          prefs.getString('kitchenApplinceManualSerialNumber');
      heatingManualLocation = prefs.getString('heatingManualLocation');
      heatingManualReading = prefs.getString('heatingManualReading');
      heatingManualSerialNumber = prefs.getString('heatingManualSerialNumber');
      landlordGasSafetyCertificateLocation =
          prefs.getString('landlordGasSafetyCertificateLocation');
      landlordGasSafetyCertificateReading =
          prefs.getString('landlordGasSafetyCertificateReading');
      landlordGasSafetyCertificateSerialNumber =
          prefs.getString('landlordGasSafetyCertificateSerialNumber');
      legionellaRiskAssessmentLocation =
          prefs.getString('legionellaRiskAssessmentLocation');
      legionellaRiskAssessmentReading =
          prefs.getString('legionellaRiskAssessmentReading');
      legionellaRiskAssessmentSerialNumber =
          prefs.getString('legionellaRiskAssessmentSerialNumber');
      electricalSafetyCertificateLocation =
          prefs.getString('electricalSafetyCertificateLocation');
      electricalSafetyCertificateReading =
          prefs.getString('electricalSafetyCertificateReading');
      electricalSafetyCertificateSerialNumber =
          prefs.getString('electricalSafetyCertificateSerialNumber');
      energyPerformanceCertificateLocation =
          prefs.getString('energyPerformanceCertificateLocation');
      energyPerformanceCertificateReading =
          prefs.getString('energyPerformanceCertificateReading');
      energyPerformanceCertificateSerialNumber =
          prefs.getString('energyPerformanceCertificateSerialNumber');
      moveInChecklistLocation = prefs.getString('moveInChecklistLocation');
      moveInChecklistReading = prefs.getString('moveInChecklistReading');
      moveInChecklistSerialNumber =
          prefs.getString('moveInChecklistSerialNumber');
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
          'Meter Reading',
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
                location: houseApplinceManualLocation,
                reading: houseApplinceManualReading,
                serialNumber: houseApplinceManualSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    houseApplinceManualLocation = location;
                  });
                  _savePreference('houseApplinceManualLocation',
                      location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    houseApplinceManualReading = reading;
                  });
                  _savePreference(
                      'houseApplinceManualReading', reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    houseApplinceManualSerialNumber = serialNumber;
                  });
                  _savePreference('houseApplinceManualSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Kitchen Appliance Manual
              ConditionItem(
                name: "Kitchen Appliance Manual",
                location: kitchenApplinceManualLocation,
                reading: kitchenApplinceManualReading,
                serialNumber: kitchenApplinceManualSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    kitchenApplinceManualLocation = location;
                  });
                  _savePreference('kitchenApplinceManualLocation',
                      location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    kitchenApplinceManualReading = reading;
                  });
                  _savePreference('kitchenApplinceManualReading',
                      reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    kitchenApplinceManualSerialNumber = serialNumber;
                  });
                  _savePreference('kitchenApplinceManualSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Heating Manual
              ConditionItem(
                name: "Heating Manual",
                location: heatingManualLocation,
                reading: heatingManualReading,
                serialNumber: heatingManualSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    heatingManualLocation = location;
                  });
                  _savePreference(
                      'heatingManualLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    heatingManualReading = reading;
                  });
                  _savePreference(
                      'heatingManualReading', reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    heatingManualSerialNumber = serialNumber;
                  });
                  _savePreference('heatingManualSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Landlord Gas Safety Certificate
              ConditionItem(
                name: "Landlord Gas Safety Certificate",
                location: landlordGasSafetyCertificateLocation,
                reading: landlordGasSafetyCertificateReading,
                serialNumber: landlordGasSafetyCertificateSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    landlordGasSafetyCertificateLocation = location;
                  });
                  _savePreference('landlordGasSafetyCertificateLocation',
                      location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    landlordGasSafetyCertificateReading = reading;
                  });
                  _savePreference('landlordGasSafetyCertificateReading',
                      reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    landlordGasSafetyCertificateSerialNumber = serialNumber;
                  });
                  _savePreference('landlordGasSafetyCertificateSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Legionella Risk Assessment
              ConditionItem(
                name: "Legionella Risk Assessment",
                location: legionellaRiskAssessmentLocation,
                reading: legionellaRiskAssessmentReading,
                serialNumber: legionellaRiskAssessmentSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    legionellaRiskAssessmentLocation = location;
                  });
                  _savePreference('legionellaRiskAssessmentLocation',
                      location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    legionellaRiskAssessmentReading = reading;
                  });
                  _savePreference('legionellaRiskAssessmentReading',
                      reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    legionellaRiskAssessmentSerialNumber = serialNumber;
                  });
                  _savePreference('legionellaRiskAssessmentSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Electrical Safety Certificate
              ConditionItem(
                name: "Electrical Safety Certificate",
                location: electricalSafetyCertificateLocation,
                reading: electricalSafetyCertificateReading,
                serialNumber: electricalSafetyCertificateSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    electricalSafetyCertificateLocation = location;
                  });
                  _savePreference('electricalSafetyCertificateLocation',
                      location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    electricalSafetyCertificateReading = reading;
                  });
                  _savePreference('electricalSafetyCertificateReading',
                      reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    electricalSafetyCertificateSerialNumber = serialNumber;
                  });
                  _savePreference('electricalSafetyCertificateSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Energy Performance Certificate
              ConditionItem(
                name: "Energy Performance Certificate",
                location: energyPerformanceCertificateLocation,
                reading: energyPerformanceCertificateReading,
                serialNumber: energyPerformanceCertificateSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    energyPerformanceCertificateLocation = location;
                  });
                  _savePreference('energyPerformanceCertificateLocation',
                      location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    energyPerformanceCertificateReading = reading;
                  });
                  _savePreference('energyPerformanceCertificateReading',
                      reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    energyPerformanceCertificateSerialNumber = serialNumber;
                  });
                  _savePreference('energyPerformanceCertificateSerialNumber',
                      serialNumber); // Save preference
                },
              ),

              // Move In Checklist
              ConditionItem(
                name: "Move In Checklist",
                location: moveInChecklistLocation,
                reading: moveInChecklistReading,
                serialNumber: moveInChecklistSerialNumber,
                onLocationSelected: (location) {
                  setState(() {
                    moveInChecklistLocation = location;
                  });
                  _savePreference(
                      'moveInChecklistLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    moveInChecklistReading = reading;
                  });
                  _savePreference(
                      'moveInChecklistReading', reading); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    moveInChecklistSerialNumber = serialNumber;
                  });
                  _savePreference('moveInChecklistSerialNumber',
                      serialNumber); // Save preference
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
  final String? location;
  final String? reading;
  final String? serialNumber;
  final Function(String?) onLocationSelected;
  final Function(String?) onReadingSelected;
  final Function(String?) onSerialNumberSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
    this.reading,
    this.serialNumber,
    required this.onLocationSelected,
    required this.onReadingSelected,
    required this.onSerialNumberSelected,
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
                    initialCondition: location,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onLocationSelected(result);
              }
            },
            child: Text(
              location?.isNotEmpty == true ? location! : "Location",
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
                    initialCondition: reading,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onReadingSelected(result);
              }
            },
            child: Text(
              reading?.isNotEmpty == true ? reading! : "Reading",
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
                    initialCondition: serialNumber,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onSerialNumberSelected(result);
              }
            },
            child: Text(
              serialNumber?.isNotEmpty == true
                  ? serialNumber!
                  : "Serial Number",
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
