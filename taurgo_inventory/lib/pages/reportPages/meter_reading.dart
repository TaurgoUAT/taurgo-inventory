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

class MeterReading extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const MeterReading({super.key, this.capturedImages, required this.propertyId});

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
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      houseApplinceManualLocation =
          prefs.getString('houseApplinceManualLocation_${propertyId}');
      houseApplinceManualReading =
          prefs.getString('houseApplinceManualReading_${propertyId}');
      houseApplinceManualSerialNumber =
          prefs.getString('houseApplinceManualSerialNumber_${propertyId}');
      kitchenApplinceManualLocation =
          prefs.getString('kitchenApplinceManualLocation_${propertyId}');
      kitchenApplinceManualReading =
          prefs.getString('kitchenApplinceManualReading_${propertyId}');
      kitchenApplinceManualSerialNumber =
          prefs.getString('kitchenApplinceManualSerialNumber_${propertyId}');
      heatingManualLocation = prefs.getString('heatingManualLocation_${propertyId}');
      heatingManualReading = prefs.getString('heatingManualReading_${propertyId}');
      heatingManualSerialNumber = prefs.getString('heatingManualSerialNumber_${propertyId}');
      landlordGasSafetyCertificateLocation =
          prefs.getString('landlordGasSafetyCertificateLocation_${propertyId}');
      landlordGasSafetyCertificateReading =
          prefs.getString('landlordGasSafetyCertificateReading_${propertyId}');
      landlordGasSafetyCertificateSerialNumber =
          prefs.getString('landlordGasSafetyCertificateSerialNumber_${propertyId}');
      legionellaRiskAssessmentLocation =
          prefs.getString('legionellaRiskAssessmentLocation_${propertyId}');
      legionellaRiskAssessmentReading =
          prefs.getString('legionellaRiskAssessmentReading_${propertyId}');
      legionellaRiskAssessmentSerialNumber =
          prefs.getString('legionellaRiskAssessmentSerialNumber_${propertyId}');
      electricalSafetyCertificateLocation =
          prefs.getString('electricalSafetyCertificateLocation_${propertyId}');
      electricalSafetyCertificateReading =
          prefs.getString('electricalSafetyCertificateReading_${propertyId}');
      electricalSafetyCertificateSerialNumber =
          prefs.getString('electricalSafetyCertificateSerialNumber_${propertyId}');
      energyPerformanceCertificateLocation =
          prefs.getString('energyPerformanceCertificateLocation_${propertyId}');
      energyPerformanceCertificateReading =
          prefs.getString('energyPerformanceCertificateReading_${propertyId}');
      energyPerformanceCertificateSerialNumber =
          prefs.getString('energyPerformanceCertificateSerialNumber_${propertyId}');
      moveInChecklistLocation = prefs.getString('moveInChecklistLocation_${propertyId}');
      moveInChecklistReading = prefs.getString('moveInChecklistReading_${propertyId}');
      moveInChecklistSerialNumber =
          prefs.getString('moveInChecklistSerialNumber_${propertyId}');

      houseApplinceManualImages =
          prefs.getStringList('houseApplinceManualImages_${propertyId}') ?? [];
      kitchenApplinceManualImages =
          prefs.getStringList('kitchenApplinceManualImages_${propertyId}') ?? [];
      heatingManualImages = prefs.getStringList('heatingManualImages_${propertyId}') ?? [];
      landlordGasSafetyCertificateImages =
          prefs.getStringList('landlordGasSafetyCertificateImages_${propertyId}') ?? [];
      legionellaRiskAssessmentImages =
          prefs.getStringList('legionellaRiskAssessmentImages_${propertyId}') ?? [];
      electricalSafetyCertificateImages =
          prefs.getStringList('electricalSafetyCertificateImages_${propertyId}') ?? [];
      energyPerformanceCertificateImages =
          prefs.getStringList('energyPerformanceCertificateImages_${propertyId}') ?? [];
      moveInChecklistImages =
          prefs.getStringList('moveInChecklistImages_${propertyId}') ?? [];
    });
  }

  // Function to save a preference
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
              // House Appliance Manual
              ConditionItem(
                name: "House Appliance Manual",
                location: houseApplinceManualLocation,
                reading: houseApplinceManualReading,
                serialNumber: houseApplinceManualSerialNumber,
                images: houseApplinceManualImages,
                onLocationSelected: (location) {
                  setState(() {
                    houseApplinceManualLocation = location;
                  });
                  _savePreference(propertyId,'houseApplinceManualLocation',
                      location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    houseApplinceManualReading = reading;
                  });
                  _savePreference(propertyId,
                      'houseApplinceManualReading', reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    houseApplinceManualSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'houseApplinceManualSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    houseApplinceManualImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'houseApplinceManualImages', houseApplinceManualImages);
                },
              ),

              // Kitchen Appliance Manual
              ConditionItem(
                name: "Kitchen Appliance Manual",
                location: kitchenApplinceManualLocation,
                reading: kitchenApplinceManualReading,
                serialNumber: kitchenApplinceManualSerialNumber,
                images: kitchenApplinceManualImages,
                onLocationSelected: (location) {
                  setState(() {
                    kitchenApplinceManualLocation = location;
                  });
                  _savePreference(propertyId,'kitchenApplinceManualLocation',
                      location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    kitchenApplinceManualReading = reading;
                  });
                  _savePreference(propertyId,'kitchenApplinceManualReading',
                      reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    kitchenApplinceManualSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'kitchenApplinceManualSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenApplinceManualImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'kitchenApplinceManualImages',
                      kitchenApplinceManualImages);
                },
              ),

              // Heating Manual
              ConditionItem(
                name: "Heating Manual",
                location: heatingManualLocation,
                reading: heatingManualReading,
                serialNumber: heatingManualSerialNumber,
                images: heatingManualImages,
                onLocationSelected: (location) {
                  setState(() {
                    heatingManualLocation = location;
                  });
                  _savePreference(propertyId,
                      'heatingManualLocation', location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    heatingManualReading = reading;
                  });
                  _savePreference(propertyId,
                      'heatingManualReading', reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    heatingManualSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'heatingManualSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    heatingManualImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'heatingManualImages', heatingManualImages);
                },
              ),

              // Landlord Gas Safety Certificate
              ConditionItem(
                name: "Landlord Gas Safety Certificate",
                location: landlordGasSafetyCertificateLocation,
                reading: landlordGasSafetyCertificateReading,
                serialNumber: landlordGasSafetyCertificateSerialNumber,
                images: landlordGasSafetyCertificateImages,
                onLocationSelected: (location) {
                  setState(() {
                    landlordGasSafetyCertificateLocation = location;
                  });
                  _savePreference(propertyId,'landlordGasSafetyCertificateLocation',
                      location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    landlordGasSafetyCertificateReading = reading;
                  });
                  _savePreference(propertyId,'landlordGasSafetyCertificateReading',
                      reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    landlordGasSafetyCertificateSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'landlordGasSafetyCertificateSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landlordGasSafetyCertificateImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'landlordGasSafetyCertificateImages',
                      landlordGasSafetyCertificateImages);
                },
              ),

              // Legionella Risk Assessment
              ConditionItem(
                name: "Legionella Risk Assessment",
                location: legionellaRiskAssessmentLocation,
                reading: legionellaRiskAssessmentReading,
                serialNumber: legionellaRiskAssessmentSerialNumber,
                images: legionellaRiskAssessmentImages,
                onLocationSelected: (location) {
                  setState(() {
                    legionellaRiskAssessmentLocation = location;
                  });
                  _savePreference(propertyId,'legionellaRiskAssessmentLocation',
                      location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    legionellaRiskAssessmentReading = reading;
                  });
                  _savePreference(propertyId,'legionellaRiskAssessmentReading',
                      reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    legionellaRiskAssessmentSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'legionellaRiskAssessmentSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    legionellaRiskAssessmentImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'legionellaRiskAssessmentImages',
                      legionellaRiskAssessmentImages);
                },
              ),

              // Electrical Safety Certificate
              ConditionItem(
                name: "Electrical Safety Certificate",
                location: electricalSafetyCertificateLocation,
                reading: electricalSafetyCertificateReading,
                serialNumber: electricalSafetyCertificateSerialNumber,
                images: electricalSafetyCertificateImages,
                onLocationSelected: (location) {
                  setState(() {
                    electricalSafetyCertificateLocation = location;
                  });
                  _savePreference(propertyId,'electricalSafetyCertificateLocation',
                      location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    electricalSafetyCertificateReading = reading;
                  });
                  _savePreference(propertyId,'electricalSafetyCertificateReading',
                      reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    electricalSafetyCertificateSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'electricalSafetyCertificateSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    electricalSafetyCertificateImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'electricalSafetyCertificateImages',
                      electricalSafetyCertificateImages);
                },
              ),
              // Energy Performance Certificate
              ConditionItem(
                name: "Energy Performance Certificate",
                location: energyPerformanceCertificateLocation,
                reading: energyPerformanceCertificateReading,
                serialNumber: energyPerformanceCertificateSerialNumber,
                images: energyPerformanceCertificateImages,
                onLocationSelected: (location) {
                  setState(() {
                    energyPerformanceCertificateLocation = location;
                  });
                  _savePreference(propertyId,'energyPerformanceCertificateLocation',
                      location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    energyPerformanceCertificateReading = reading;
                  });
                  _savePreference(propertyId,'energyPerformanceCertificateReading',
                      reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    energyPerformanceCertificateSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'energyPerformanceCertificateSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    energyPerformanceCertificateImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'energyPerformanceCertificateImages',
                      energyPerformanceCertificateImages);
                },
              ),

              // Move In Checklist
              ConditionItem(
                name: "Move In Checklist",
                location: moveInChecklistLocation,
                reading: moveInChecklistReading,
                serialNumber: moveInChecklistSerialNumber,
                images: moveInChecklistImages,
                onLocationSelected: (location) {
                  setState(() {
                    moveInChecklistLocation = location;
                  });
                  _savePreference(propertyId,
                      'moveInChecklistLocation', location!); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    moveInChecklistReading = reading;
                  });
                  _savePreference(propertyId,
                      'moveInChecklistReading', reading!); // Save preference
                },
                onSerialNumberSelected: (serialNumber) {
                  setState(() {
                    moveInChecklistSerialNumber = serialNumber;
                  });
                  _savePreference(propertyId,'moveInChecklistSerialNumber',
                      serialNumber!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    moveInChecklistImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'moveInChecklistImages', moveInChecklistImages);
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
  final List<String> images;
  final Function(String?) onLocationSelected;
  final Function(String?) onReadingSelected;
  final Function(String?) onSerialNumberSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
    this.reading,
    this.serialNumber,
    required this.images,
    required this.onLocationSelected,
    required this.onReadingSelected,
    required this.onSerialNumberSelected,
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
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.warning_amber,
                  //     size: 24,
                  //     color: kAccentColor,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => AddAction(),
                  //       ),
                  //     );
                  //   },
                  // ),
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