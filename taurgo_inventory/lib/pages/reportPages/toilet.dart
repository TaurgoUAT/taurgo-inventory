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

class Toilet extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Toilet({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Toilet> createState() => _ToiletState();
}

Future<String?> uploadImageToFirebase(File imageFile, String propertyId,
    String collectionName, String documentId) async {
  try {
    // Step 1: Upload the image to Firebase Storage
    String fileName =
        '${documentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
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

class _ToiletState extends State<Toilet> {
  String? toiletDoorCondition;
  String? toiletDoorDescription;
  String? toiletDoorFrameCondition;
  String? toiletDoorFrameDescription;
  String? toiletCeilingCondition;
  String? toiletCeilingDescription;
  String? toiletExtractorFanCondition;
  String? toiletExtractorFanDescription;
  String? toiletLightingCondition;
  String? toiletLightingDescription;
  String? toiletWallsCondition;
  String? toiletWallsDescription;
  String? toiletSkirtingCondition;
  String? toiletSkirtingDescription;
  String? toiletWindowSillCondition;
  String? toiletwWindowSillDescription;
  String? toiletCurtainsCondition;
  String? toiletCurtainsDescription;
  String? toiletBlindsCondition;
  String? toiletBlindsDescription;
  String? toiletToiletCondition;
  String? toiletToiletDescription;
  String? toiletBasinCondition;
  String? toiletBasinDescription;
  String? toiletShowerCubicleCondition;
  String? toiletShowerCubicleDescription;
  String? toiletBathCondition;
  String? toiletBathDescription;
  String? toiletSwitchBoardCondition;
  String? toiletSwitchBoardDescription;
  String? toiletSocketCondition;
  String? toiletSocketDescription;
  String? toiletHeatingCondition;
  String? toiletHeatingDescription;
  String? toiletAccessoriesCondition;
  String? toiletAccessoriesDescription;
  String? toiletFlooringCondition;
  String? toiletFlooringDescription;
  String? toiletAdditionalItemsCondition;
  String? toiletAdditionalItemsDescription;

 
  List<String> toiletDoorImages = [];
  List<String> toiletDoorFrameImages = [];
  List<String> toiletCeilingImages = [];
  List<String> toiletExtractorFanImages = [];
  List<String> toiletlLightingImages = [];
  List<String> toiletWallsImages = [];
  List<String> toiletSkirtingImages = [];
  List<String> toiletWindowSillImages = [];
  List<String> toiletCurtainsImages = [];
  List<String> toiletBlindsImages = [];
  List<String> toiletToiletImages = [];
  List<String> toiletBasinImages = [];
  List<String> toiletShowerCubicleImages = [];
  List<String> toiletBathImages = [];
  List<String> toiletSwitchBoardImages = [];
  List<String> toiletSocketImages = [];
  List<String> toiletHeatingImages = [];
  List<String> toiletAccessoriesImages = [];
  List<String> toileFflooringImages = [];
  List<String> toiletAdditionalItemsImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('toilet')
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

  // Function to save a preference
  Future<void> _savePreference(
      String propertyId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${key}_$propertyId', value);
  }

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Toilet',
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
                        child: Text(
                          'Cancel',
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
                                builder: (context) => EditReportPage(
                                    propertyId: widget
                                        .propertyId)), // Replace HomePage with your
                            // home page
                            // widget
                          );
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              onTap: () {
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
                          child: Text(
                            'Cancel',
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
                                  builder: (context) => EditReportPage(
                                      propertyId: widget
                                          .propertyId)), // Replace HomePage with your
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
                      _getImagesFromFirestore(propertyId, 'toiletDoorImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletDoorImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Door",
                        condition: toiletDoorCondition,
                        description: toiletDoorCondition,
                        images: toiletDoorImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletDoorCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletDoorCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletDoorCondition = description;
                          });
                          _savePreference(
                              propertyId, 'toiletDoorCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletDoorImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletDoorImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Door Frame
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletDoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletDoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Door Frame",
                        condition: toiletDoorFrameCondition,
                        description: toiletDoorFrameCondition,
                        images: toiletDoorFrameImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletDoorFrameCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletDoorFrameCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletDoorFrameCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletDoorFrameCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletDoorFrameImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletDoorFrameImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Ceiling
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletCeilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletCeilingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Ceiling",
                        condition: toiletCeilingCondition,
                        description: toiletCeilingCondition,
                        images: toiletCeilingImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletCeilingCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletCeilingCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletCeilingCondition = description;
                          });
                          _savePreference(propertyId, 'toiletCeilingCondition',
                              description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletCeilingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletCeilingImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Extractor Fan
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletExtractorFanImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletExtractorFanImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Extractor Fan",
                        condition: toiletExtractorFanCondition,
                        description: toiletExtractorFanCondition,
                        images: toiletExtractorFanImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletExtractorFanCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletExtractorFanCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletExtractorFanCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletExtractorFanCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletExtractorFanImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletExtractorFanImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Lighting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletlLightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletlLightingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Lighting",
                        condition: toiletLightingCondition,
                        description: toiletLightingCondition,
                        images: toiletlLightingImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletLightingCondition = condition;
                          });
                          _savePreference(propertyId, 'toiletLightingCondition',
                              condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletLightingCondition = description;
                          });
                          _savePreference(propertyId, 'toiletLightingCondition',
                              description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletlLightingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletlLightingImages')
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
                      _getImagesFromFirestore(propertyId, 'toiletWallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletWallsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Walls",
                        condition: toiletWallsCondition,
                        description: toiletWallsCondition,
                        images: toiletWallsImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletWallsCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletWallsCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletWallsCondition = description;
                          });
                          _savePreference(
                              propertyId, 'toiletWallsCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletWallsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletWallsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Skirting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletSkirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletSkirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Skirting",
                        condition: toiletSkirtingCondition,
                        description: toiletSkirtingCondition,
                        images: toiletSkirtingImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletSkirtingCondition = condition;
                          });
                          _savePreference(propertyId, 'toiletSkirtingCondition',
                              condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletSkirtingCondition = description;
                          });
                          _savePreference(propertyId, 'toiletSkirtingCondition',
                              description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletSkirtingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletSkirtingImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Window Sill
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletWindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletWindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Window Sill",
                        condition: toiletWindowSillCondition,
                        description: toiletWindowSillCondition,
                        images: toiletWindowSillImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletWindowSillCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletWindowSillCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletWindowSillCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletWindowSillCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletWindowSillImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletWindowSillImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Curtains
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletCurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletCurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Curtains",
                        condition: toiletCurtainsCondition,
                        description: toiletCurtainsCondition,
                        images: toiletCurtainsImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletCurtainsCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletCurtainsCondition,', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletCurtainsCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletCurtainsCondition,', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletCurtainsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletCurtainsImages')
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
                      _getImagesFromFirestore(propertyId, 'toiletBlindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletBlindsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Blinds",
                        condition: toiletBlindsCondition,
                        description: toiletBlindsCondition,
                        images: toiletBlindsImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletBlindsCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletBlindsCondition,', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletBlindsCondition = description;
                          });
                          _savePreference(propertyId, 'toiletBlindsCondition,',
                              description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletBlindsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletBlindsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Toilet
                // ConditionItem(
                //   name: "Toilet",
                //   condition: toiletToiletCondition,
                //   description: toiletToiletDescription,
                //   images: toiletToiletImages,
                //   onConditionSelected: (condition) {
                //     setState(() {
                //       toiletToiletCondition = condition;
                //     });
                //     _savePreference(propertyId, 'toiletCondition',
                //         condition!); // Save preference
                //   },
                //   onDescriptionSelected: (description) {
                //     setState(() {
                //       toiletToiletDescription = description;
                //     });
                //     _savePreference(propertyId, 'toiletDescription',
                //         description!); // Save preference
                //   },
                //   onImageAdded: (imagePath) {
                //     setState(() {
                //       toiletToiletImages.add(imagePath);
                //     });
                //     _savePreferenceList(propertyId, 'toiletImages',
                //         toiletToiletImages); // Save preference
                //   },
                // ),

                // Basin
                StreamBuilder<List<String>>(
                  stream:
                      _getImagesFromFirestore(propertyId, 'toiletBasinImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletBasinImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Basin",
                        condition: toiletBasinCondition,
                        description: toiletBasinCondition,
                        images: toiletBasinImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletBasinCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletBasinCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletBasinCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletBasinCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletBasinImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletBasinImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Shower Cubicle
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletShowerCubicleImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletShowerCubicleImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Shower Cubicle",
                        condition: toiletShowerCubicleCondition,
                        description: toiletShowerCubicleCondition,
                        images: toiletShowerCubicleImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletShowerCubicleCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletShowerCubicleCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletShowerCubicleCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletShowerCubicleCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletShowerCubicleImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletShowerCubicleImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Bath
                StreamBuilder<List<String>>(
                  stream:
                      _getImagesFromFirestore(propertyId, 'toiletBathImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletBathImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Bath",
                        condition: toiletBathCondition,
                        description: toiletBathCondition,
                        images: toiletBathImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletBathCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletBathCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletBathCondition = description;
                          });
                          _savePreference(
                              propertyId, 'toiletBathCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletBathImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletBathImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Switch Board
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletSwitchBoardImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletSwitchBoardImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Switch Board",
                        condition: toiletSwitchBoardCondition,
                        description: toiletSwitchBoardCondition,
                        images: toiletSwitchBoardImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletSwitchBoardCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletSwitchBoardCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletSwitchBoardCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletSwitchBoardCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletSwitchBoardImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletSwitchBoardImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Socket
                StreamBuilder<List<String>>(
                  stream:
                      _getImagesFromFirestore(propertyId, 'toiletSocketImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletSocketImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Socket",
                        condition: toiletSocketCondition,
                        description: toiletSocketCondition,
                        images: toiletSocketImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletSocketCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletSocketCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletSocketCondition = description;
                          });
                          _savePreference(propertyId, 'toiletSocketCondition',
                              description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletSocketImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletSocketImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Heating
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletHeatingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletHeatingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Heating",
                        condition: toiletHeatingCondition,
                        description: toiletHeatingCondition,
                        images: toiletHeatingImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletHeatingCondition = condition;
                          });
                          _savePreference(
                              propertyId, 'toiletHeatingCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletHeatingCondition = description;
                          });
                          _savePreference(propertyId, 'toiletHeatingCondition',
                              description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletHeatingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletHeatingImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Accessories
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletAccessoriesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletAccessoriesImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Accessories",
                        condition: toiletAccessoriesCondition,
                        description: toiletAccessoriesCondition,
                        images: toiletAccessoriesImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletAccessoriesCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletAccessoriesCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletAccessoriesCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletAccessoriesCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletAccessoriesImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletAccessoriesImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
                // Flooring
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletFlooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletFlooringImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Flooring",
                        condition: toiletFlooringCondition,
                        description: toiletFlooringCondition,
                        images: toiletFlooringImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletFlooringCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletFlooringCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletFlooringCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletFlooringCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletFlooringImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletFlooringImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

                // Additional Items
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletAdditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final toiletAdditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Additional Items",
                        condition: toiletAdditionalItemsCondition,
                        description: toiletAdditionalItemsCondition,
                        images: toiletAdditionalItemsImages,
                        onConditionSelected: (condition) {
                          setState(() {
                            toiletAdditionalItemsCondition = condition;
                          });
                          _savePreference(propertyId,
                              'toiletAdditionalItemsCondition', condition!);
                        },
                        onDescriptionSelected: (description) {
                          setState(() {
                            toiletAdditionalItemsCondition = description;
                          });
                          _savePreference(propertyId,
                              'toiletAdditionalItemsCondition', description!);
                        },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile,
                              propertyId,
                              'toilet',
                              'toiletAdditionalItemsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('toilet')
                                .doc('toiletAdditionalItemsImages')
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
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: description,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onDescriptionSelected(result);
          //     }
          //   },
          //   child: Text(
          //     description?.isNotEmpty == true ? description! : "Description",
          //     style: TextStyle(
          //       fontSize: 12.0,
          //       fontWeight: FontWeight.w700,
          //       color: kPrimaryTextColourTwo,
          //       fontStyle: FontStyle.italic,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 12,
          // ),
          images.isNotEmpty
              ? Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: images.map((imageUrl) {
                    return Image.network(
                      imageUrl,
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
