import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Receripts extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const Receripts({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Receripts> createState() => _ReceriptsState();
}
Future<String?> uploadImageToFirebase(File imageFile, String propertyId, String collectionName, String documentId) async {
  try {
    // Step 1: Upload the image to Firebase Storage
    String fileName = '${documentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$propertyId/$collectionName/$documentId/$fileName');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

    // Step 2: Get the download URL of the uploaded image
    String downloadURL = await snapshot.ref.getDownloadURL();
    print("Uploaded to Firebase: $downloadURL");

    // Step 3: Save the download URL to Firestore
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection(collectionName)
        .doc(documentId)
        .set({
          'images': FieldValue.arrayUnion([downloadURL])
        }, SetOptions(merge: true));

    return downloadURL;
  } catch (e) {
    print("Error uploading image: $e");
    return null;
  }
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
      houseApplinceManualCondition = prefs.getString('houseApplinceManualCondition_${propertyId}');
      houseApplinceManualDescription = prefs.getString('houseApplinceManualDescription_${propertyId}');
      kitchenApplinceManualCondition = prefs.getString('kitchenApplinceManualCondition_${propertyId}');
      kitchenApplinceManualDescription = prefs.getString('kitchenApplinceManualDescription_${propertyId}');
      heatingManualCondition = prefs.getString('heatingManualCondition_${propertyId}');
      heatingManualDescription = prefs.getString('heatingManualDescription_${propertyId}');
      landlordGasSafetyCertificateCondition = prefs.getString('landlordGasSafetyCertificateCondition_${propertyId}');
      landlordGasSafetyCertificateDescription = prefs.getString('landlordGasSafetyCertificateDescription_${propertyId}');
      legionellaRiskAssessmentCondition = prefs.getString('legionellaRiskAssessmentCondition_${propertyId}');
      legionellaRiskAssessmentDescription = prefs.getString('legionellaRiskAssessmentDescription_${propertyId}');
      electricalSafetyCertificateCondition = prefs.getString('electricalSafetyCertificateCondition_${propertyId}');
      electricalSafetyCertificateDescription = prefs.getString('electricalSafetyCertificateDescription_${propertyId}');
      energyPerformanceCertificateCondition = prefs.getString('energyPerformanceCertificateCondition_${propertyId}');
      energyPerformanceCertificateDescription = prefs.getString('energyPerformanceCertificateDescription_${propertyId}');
      moveInChecklistCondition = prefs.getString('moveInChecklistCondition_${propertyId}');
      moveInChecklistDescription = prefs.getString('moveInChecklistDescription_${propertyId}');

      houseApplinceManualImages = prefs.getStringList('houseApplinceManualImages_${propertyId}') ?? [];
      kitchenApplinceManualImages = prefs.getStringList('kitchenApplinceManualImages_${propertyId}') ?? [];
      heatingManualImages = prefs.getStringList('heatingManualImages_${propertyId}') ?? [];
      landlordGasSafetyCertificateImages = prefs.getStringList('landlordGasSafetyCertificateImages_${propertyId}') ?? [];
      legionellaRiskAssessmentImages = prefs.getStringList('legionellaRiskAssessmentImages_${propertyId}') ?? [];
      electricalSafetyCertificateImages = prefs.getStringList('electricalSafetyCertificateImages_${propertyId}') ?? [];
      energyPerformanceCertificateImages = prefs.getStringList('energyPerformanceCertificateImages_${propertyId}') ?? [];
      moveInChecklistImages = prefs.getStringList('moveInChecklistImages_${propertyId}') ?? [];
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
                condition: houseApplinceManualCondition,
                description: houseApplinceManualDescription,
                images: houseApplinceManualImages,
                onConditionSelected: (condition) {
                  setState(() {
                    houseApplinceManualCondition = condition;
                  });
                  _savePreference(propertyId,'houseApplinceManualCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    houseApplinceManualDescription = description;
                  });
                  _savePreference(propertyId,'houseApplinceManualDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    houseApplinceManualImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'houseApplinceManualImages', houseApplinceManualImages); // Save preference
                },
              ),

              // Kitchen Appliance Manual
              ConditionItem(
                name: "Kitchen Appliance Manual",
                condition: kitchenApplinceManualCondition,
                description: kitchenApplinceManualDescription,
                images: kitchenApplinceManualImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenApplinceManualCondition = condition;
                  });
                  _savePreference(propertyId,'kitchenApplinceManualCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenApplinceManualDescription = description;
                  });
                  _savePreference(propertyId,'kitchenApplinceManualDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenApplinceManualImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'kitchenApplinceManualImages', kitchenApplinceManualImages); // Save preference
                },
              ),

              // Heating Manual
              ConditionItem(
                name: "Heating Manual",
                condition: heatingManualCondition,
                description: heatingManualDescription,
                images: heatingManualImages,
                onConditionSelected: (condition) {
                  setState(() {
                    heatingManualCondition = condition;
                  });
                  _savePreference(propertyId,'heatingManualCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    heatingManualDescription = description;
                  });
                  _savePreference(propertyId,'heatingManualDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    heatingManualImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'heatingManualImages', heatingManualImages); // Save preference
                },
              ),

              // Landlord Gas Safety Certificate
              ConditionItem(
                name: "Landlord Gas Safety Certificate",
                condition: landlordGasSafetyCertificateCondition,
                description: landlordGasSafetyCertificateDescription,
                images: landlordGasSafetyCertificateImages,
                onConditionSelected: (condition) {
                  setState(() {
                    landlordGasSafetyCertificateCondition = condition;
                  });
                  _savePreference(propertyId,'landlordGasSafetyCertificateCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    landlordGasSafetyCertificateDescription = description;
                  });
                  _savePreference(propertyId,'landlordGasSafetyCertificateDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    landlordGasSafetyCertificateImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'landlordGasSafetyCertificateImages', landlordGasSafetyCertificateImages); // Save preference
                },
              ),

              // Legionella Risk Assessment
              ConditionItem(
                name: "Legionella Risk Assessment",
                condition: legionellaRiskAssessmentCondition,
                description: legionellaRiskAssessmentDescription,
                images: legionellaRiskAssessmentImages,
                onConditionSelected: (condition) {
                  setState(() {
                    legionellaRiskAssessmentCondition = condition;
                  });
                  _savePreference(propertyId,'legionellaRiskAssessmentCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    legionellaRiskAssessmentDescription = description;
                  });
                  _savePreference(propertyId,'legionellaRiskAssessmentDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    legionellaRiskAssessmentImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'legionellaRiskAssessmentImages', legionellaRiskAssessmentImages); // Save preference
                },
              ),

              // Electrical Safety Certificate
              ConditionItem(
                name: "Electrical Safety Certificate",
                condition: electricalSafetyCertificateCondition,
                description: electricalSafetyCertificateDescription,
                images: electricalSafetyCertificateImages,
                onConditionSelected: (condition) {
                  setState(() {
                    electricalSafetyCertificateCondition = condition;
                  });
                  _savePreference(propertyId,'electricalSafetyCertificateCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    electricalSafetyCertificateDescription = description;
                  });
                  _savePreference(propertyId,'electricalSafetyCertificateDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    electricalSafetyCertificateImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'electricalSafetyCertificateImages', electricalSafetyCertificateImages); // Save preference
                },
              ),

              // Energy Performance Certificate
              ConditionItem(
                name: "Energy Performance Certificate",
                condition: energyPerformanceCertificateCondition,
                description: energyPerformanceCertificateDescription,
                images: energyPerformanceCertificateImages,
                onConditionSelected: (condition) {
                  setState(() {
                    energyPerformanceCertificateCondition = condition;
                  });
                  _savePreference(propertyId,'energyPerformanceCertificateCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    energyPerformanceCertificateDescription = description;
                  });
                  _savePreference(propertyId,'energyPerformanceCertificateDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    energyPerformanceCertificateImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'energyPerformanceCertificateImages', energyPerformanceCertificateImages); // Save preference
                },
              ),

              // Move In Checklist
              ConditionItem(
                name: "Move In Checklist",
                condition: moveInChecklistCondition,
                description: moveInChecklistDescription,
                images: moveInChecklistImages,
                onConditionSelected: (condition) {
                  setState(() {
                    moveInChecklistCondition = condition;
                  });
                  _savePreference(propertyId,'moveInChecklistCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    moveInChecklistDescription = description;
                  });
                  _savePreference(propertyId,'moveInChecklistDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    moveInChecklistImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'moveInChecklistImages', moveInChecklistImages); // Save preference
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