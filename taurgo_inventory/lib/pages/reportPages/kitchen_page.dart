import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
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
  String? kitchenLightSwitchesCondition;
  String? kitchenLightSwitchesDescription;
  String? kitchenWallsCondition;
  String? kitchenWallsDescription;
  String? kitchenSkirtingCondition;
  String? kitchenSkirtingDescription;
  String? kitchenWindowSillCondition;
  String? kitchenWindowSillDescription;
  String? kitchenCurtainsCondition;
  String? kitchenCurtainsDescription;
  String? kitchenCuboardsCondition;
  String? kitchenCuboardsDescription;
  String? kitchenHobCondition;
  String? kitchenHobDescription;
  String? kitchenTapCondition;
  String? kitchenTapDescription;
  String? kitchenBlindsCondition;
  String? kitchenBlindsDescription;
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
  String? kichenKitchenUnitsCondition;
  String? kitchenKitchenUnitsDescription;
  String? kitchenExtractorHoodCondition;
  String? kitchenExtractorHoodDescription;
  String? kitchenCookerCondition;
  String? kitchenCookerDescription;
  String? kitchenFridgeFreezerCondition;
  String? kitchenFridgeFreezerDescription;
  String? kitchenWashingMachineCondition;
  String? kitchenWashingMachineDescription;
  String? kitchenDishwasherCondition;
  String? kitchenDishwasherDescription;
  String? kitchenTumbleDryerCondition;
  String? kitchenTumbleDryerDescription;
  String? kitchenMicrowaveCondition;
  String? kitchenMicrowaveDescription;
  String? kitchenKettleCondition;
  String? kitchenKettleDescription;
  String? kitchenToasterCondition;
  String? kitchenToasterDescription;
  String? kitchenVacuumCleanerCondition;
  String? kitchenVacuumCleanerDescription;
  String? kitchenBroomCondition;
  String? kitchenBroomDescription;
  String? kitchenMopBucketCondition;
  String? kitchenMopBucketDescription;
  String? kitchenSinkCondition;
  String? kitchenSinkDescription;
  String? kitchenWorktopCondition;
  String? kitchenWorktopDescription;
  String? kitchenOvenCondition;
  String? kitchenOvenDescription;
  String? kitchenAdditionItemsCondition;
  String? kitchenAdditionItemsDescription;
  List<String> kitchenDoorImages = [];
  List<String> kitchenDoorFrameImages = [];
  List<String> kitchenCeilingImages = [];
  List<String> kitchenExtractorFanImages = [];
  List<String> kitchenLightingImages = [];
  List<String> kitchenLightSwitchesImages = [];
  List<String> kitchenWallsImages = [];
  List<String> kitchenSkirtingImages = [];
  List<String> kitchenWindowSillImages = [];
  List<String> ktichenCurtainsImages = [];
  List<String> kitchenCuboardsImages = [];
  List<String> kitchenHobImages = [];
  List<String> kitchenTapImages = [];
  List<String> kitchenBlindsImages = [];
  List<String> kitchenBathImages = [];
  List<String> kitchenSwitchBoardImages = [];
  List<String> kitchenSocketImages = [];
  List<String> kitchenHeatingImages = [];
  List<String> kitchenAccessoriesImages = [];
  List<String> kitchenFlooringImages = [];
  List<String> kitchenKitchenUnitsImages = [];
  List<String> kitchenExtractorHoodImages = [];
  List<String> kitchenCookerImages = [];
  List<String> kitchenFridgeFreezerImages = [];
  List<String> kitchenWashingMachineImages = [];
  List<String> kitchenDishwasherImages = [];
  List<String> kitchenMicrowaveImages = [];
  List<String> kitchenKettleImages = [];
  List<String> kitchenToasterImages = [];
  List<String> kitchenVacuumCleanerImages = [];
  List<String> kitchenBroomImages = [];
  List<String> kitchenMopBucketImages = [];
  List<String> kitchenSinkImages = [];
  List<String> kitchenWorktopImages = [];
  List<String> kitchenOvenImages = [];
  List<String> kitchenAdditionItemsImages = [];
  late List<File> kitchenCapturedImages;

  @override
  void initState() {
    super.initState();
    kitchenCapturedImages = widget.kitchenCapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");

    // Load the saved preferences when the state is initialized
  }

  // Fetch images from Firestore
  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('kitchen')
        .doc(imageType)
        .snapshots()
        .map((snapshot) {
      print("Firestore snapshot data for $imageType: ${snapshot.data()}");
      if (snapshot.exists && snapshot.data() != null) {
        return List<String>.from(snapshot.data()!['images'] ?? []);
      }
      return [];
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
          onTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      Icon(Icons.info_outline, color: kPrimaryColor),
                      SizedBox(width: 10),
                      Text(
                        'Exit',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'You may lost your data if you exit the process '
                        'without saving',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        print("SOC -> EP ${widget.propertyId}");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditReportPage(propertyId: widget.propertyId)), // Replace HomePage with your
                          // home page
                          // widget
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(Icons.info_outline, color: kPrimaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Continue Saving',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Please Make Sure You Have Added All the Necessary '
                          'Information',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          print("SOC -> EP ${widget.propertyId}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditReportPage(propertyId: widget.propertyId)), // Replace HomePage with your
                            // home page
                            // widget
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Save', // Replace with the actual location
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 14, // Adjust the font size
                  fontFamily: "Inter",
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Door
             StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenDoorImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door images');
                  }
                  final kitchenDoorImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Door",
                      condition: kitchenDoorCondition,
                      description: kitchenDoorDescription,
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
                          kitchenDoorDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenDoorDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenDoorImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenDoorImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Door Frame
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenDoorFrameImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door Frame images');
                  }
                  final kitchenDoorFrameImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenDoorFrameImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenDoorFrameImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Ceiling
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenCeilingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Ceiling images');
                  }
                  final kitchenCeilingImages= snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenCeilingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenCeilingImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
         
              // Lighting
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenLightingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Lighting images');
                  }
                  final kitchenLightingImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenLightingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenLightingImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Light Switches
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenLightSwitchesImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Light Switches images');
                  }
                  final kitchenLightSwitchesImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Light Switches",
                      condition: kitchenLightSwitchesCondition,
                      description: kitchenLightSwitchesDescription,
                      images: kitchenLightSwitchesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenLightSwitchesCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenLightSwitchesCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenLightSwitchesDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenLightSwitchesDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenLightSwitchesImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenLightSwitchesImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Walls
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenWallsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Walls images');
                  }
                  final kitchenWallsImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenWallsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenWallsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Skirting
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenSkirtingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Skirting images');
                  }
                  final kitchenSkirtingImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenSkirtingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenSkirtingImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Window Sill
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenWindowSillImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Window Sill images');
                  }
                  final kitchenWindowSillImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenWindowSillImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenWindowSillImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Curtains
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenCurtainsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Curtains images');
                  }
                  final kitchenCurtainsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Curtains",
                      condition: kitchenCurtainsCondition,
                      description: kitchenCurtainsDescription,
                      images: kitchenCurtainsImages,
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenCurtainsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenCurtainsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Cuboards
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenCuboardsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Cuboards images');
                  }
                  final kitchenCuboardsImages= snapshot.data ?? [];
                  return ConditionItem(
                      name: "Cuboards",
                      condition: kitchenCuboardsCondition,
                      description: kitchenCuboardsDescription,
                      images: kitchenCuboardsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenCuboardsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenCuboardsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenCuboardsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenCuboardsDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenCuboardsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenCuboardsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Hob
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenHobImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Hob images');
                  }
                  final kitchenHobImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Hob",
                      condition: kitchenHobCondition,
                      description: kitchenHobDescription,
                      images: kitchenHobImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenHobCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenHobCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenHobDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenHobDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenHobImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenHobImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
             
              
              // Blinds
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenBlindsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Blinds images');
                  }
                  final kitchenBlindsImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenBlindsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenBlindsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
             
              // Sink
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenSinkImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Sink images');
                  }
                  final kitchenSinkImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Sink",
                      condition: kitchenSinkCondition,
                      description: kitchenSinkDescription,
                      images: kitchenSinkImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenSinkCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenSinkCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenSinkDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenSinkDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenSinkImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenSinkImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
             
              //Tap
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenTapImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Tap images');
                  }
                  final kitchenTapImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Tap",
                      condition: kitchenTapCondition,
                      description: kitchenTapDescription,
                      images: kitchenTapImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenTapCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenTapCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenTapDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenTapDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenTapImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenTapImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Kitchen Accessories
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenAccessoriesImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Kitchen Accessories images');
                  }
                  final kitchenAccessoriesImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Kitchen Accessories",
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
                        _savePreference(
                            propertyId, 'kitchenAccessoriesDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenAccessoriesImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenAccessoriesImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Kitchen Units
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenKitchenUnits'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Kitchen Units images');
                  }
                  final kitchenKitchenUnits = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Kitchen Units",
                      condition: kichenKitchenUnitsCondition,
                      description: kitchenKitchenUnitsDescription,
                      images: kitchenKitchenUnits,
                      onConditionSelected: (condition) {
                        setState(() {
                          kichenKitchenUnitsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kichenKitchenUnitsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenKitchenUnitsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenKitchenUnitsDescription,', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenKitchenUnits');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenKitchenUnits')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
                   // Extractor Fan
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenExtractorFanImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Extractor Fan images');
                  }
                  final kitchenExtractorFanImages = snapshot.data ?? [];
                  return ConditionItem(
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
                        _savePreference(
                            propertyId, 'kitchenExtractorFanDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenExtractorFanImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenExtractorFanImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Extarctor Hood
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenExtractorHoodImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Extractor Hood images');
                  }
                  final kitchenExtractorHoodImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Extractor Hood",
                      condition: kitchenExtractorHoodCondition,
                      description: kitchenExtractorHoodDescription,
                      images: kitchenExtractorHoodImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenExtractorHoodCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenExtractorHoodCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenExtractorHoodDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenExtractorHoodDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenExtractorHoodImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenExtractorHoodImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Cooker
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenCookerImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Cooker images');
                  }
                  final kitchenCookerImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Cooker",
                      condition: kitchenCookerCondition,
                      description: kitchenCookerDescription,
                      images: kitchenCookerImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenCookerCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenCookerCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenCookerDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenCookerDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenCookerImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenCookerImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Fridge/Freezer
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenFridgeFreezerImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Fridge images');
                  }
                  final kitchenFridgeFreezerImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Fridge",
                      condition: kitchenFridgeFreezerCondition,
                      description: kitchenFridgeFreezerDescription,
                      images: kitchenFridgeFreezerImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenFridgeFreezerCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenFridgeFreezerCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenFridgeFreezerDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenFridgeFreezerDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenFridgeFreezerImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenFridgeFreezerImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Microwave
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenMicrowaveImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Microwave images');
                  }
                  final kitchenMicrowaveImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Microwave",
                      condition: kitchenMicrowaveCondition,
                      description: kitchenMicrowaveDescription,
                      images: kitchenMicrowaveImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenMicrowaveCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenMicrowaveCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenMicrowaveDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenMicrowaveDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenMicrowaveImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenMicrowaveImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Oven
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenOvenImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Oven images');
                  }
                  final kitchenOvenImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Oven",
                      condition: kitchenOvenCondition,
                      description: kitchenOvenDescription,
                      images: kitchenOvenImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenOvenCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenOvenCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenOvenDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenOvenDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenOvenImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenOvenImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Dishwasher
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenDishwasherImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Dishwasher images');
                  }
                  final kitchenDishwasherImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Dishwasher",
                      condition: kitchenDishwasherCondition,
                      description: kitchenDishwasherDescription,
                      images: kitchenDishwasherImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenDishwasherCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenDishwasherCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenDishwasherDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenDishwasherDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenDishwasherImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenDishwasherImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Kettle
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenKettleImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Kettle images');
                  }
                  final kitchenKettleImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Kettle",
                      condition: kitchenKettleCondition,
                      description: kitchenKettleDescription,
                      images: kitchenKettleImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenKettleCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenKettleCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenKettleDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenKettleDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenKettleImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenKettleImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Toaster
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenToasterImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Toaster images');
                  }
                  final kitchenToasterImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Toaster",
                      condition: kitchenToasterCondition,
                      description: kitchenToasterDescription,
                      images: kitchenToasterImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenToasterCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenToasterCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenToasterDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenToasterDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenToasterImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenToasterImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Vacuum Cleaner
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenVacuumCleanerImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Vacuum Cleaner images');
                  }
                  final kitchenVacuumCleanerImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Vacuum Cleaner",
                      condition: kitchenVacuumCleanerCondition,
                      description: kitchenVacuumCleanerDescription,
                      images: kitchenVacuumCleanerImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenVacuumCleanerCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenVacuumCleanerCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenVacuumCleanerDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenVacuumCleanerDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenVacuumCleanerImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenVacuumCleanerImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Mop and Bucket
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenMopAndBucketImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Mop and Bucket images');
                  }
                  final kitchenMopAndBucketImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Mop and Bucket",
                      condition: kitchenMopBucketCondition,
                      description: kitchenMopBucketDescription,
                      images: kitchenMopAndBucketImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenMopBucketCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenMopBucketCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenMopBucketDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenMopBucketDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenMopAndBucketImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenMopAndBucketImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Worktops
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenWorktopsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Worktops images');
                  }
                  final kitchenWorktopsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Worktops",
                      condition: kitchenWorktopCondition,
                      description: kitchenWorktopDescription,
                      images: kitchenWorktopsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenWorktopCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'kitchenWorktopCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          kitchenWorktopDescription = description;
                        });
                        _savePreference(
                            propertyId, 'kitchenWorktopDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenWorktopsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchen_worktops_images')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Floring
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenFlooringImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Flooring images');
                  }
                  final kitchenFlooringImages = snapshot.data ?? [];
                  return ConditionItem(
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
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenFlooringImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenFlooringImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              //Addition Items
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'kitchenAdditionalItemsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Additional Items images');
                  }
                  final kitchenAdditionalItemsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Additional Items",
                      condition: kitchenAdditionItemsCondition,
                      description: kitchenAdditionItemsDescription,
                      images: kitchenAdditionalItemsImages,
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
                        _savePreference(
                            propertyId, 'kitchenAdditionItemsDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'kitchen',
                            'kitchenAdditionalItemsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('kitchen')
                              .doc('kitchenAdditionalItemsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
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
