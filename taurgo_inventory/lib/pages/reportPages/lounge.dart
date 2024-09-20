import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Lounge extends StatefulWidget {
  final List<File>? loungecapturedImages;
  final String propertyId;
  const Lounge(
      {super.key, this.loungecapturedImages, required this.propertyId});

  @override
  State<Lounge> createState() => _LoungeState();
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

class _LoungeState extends State<Lounge> {
  String? lougeDoorCondition;
  String? loungedoorDescription;
  String? loungedoorFrameCondition;
  String? loungedoorFrameDescription;
  String? loungeceilingCondition;
  String? loungeceilingDescription;
  String? loungelightingCondition;
  String? loungelightingDescription;
  String? loungewallsCondition;
  String? loungewallsDescription;
  String? loungeskirtingCondition;
  String? loungeskirtingDescription;
  String? loungewindowSillCondition;
  String? loungewindowSillDescription;
  String? loungecurtainsCondition;
  String? loungecurtainsDescription;
  String? loungeblindsCondition;
  String? loungeblindsDescription;
  String? loungelightSwitchesCondition;
  String? loungelightSwitchesDescription;
  String? loungesocketsCondition;
  String? loungesocketsDescription;
  String? loungeflooringCondition;
  String? loungeflooringDescription;
  String? loungeadditionalItemsCondition;
  String? loungeadditionalItemsDescription;
  List<String> loungedoorImages = [];
  List<String> loungedoorFrameImages = [];
  List<String> loungeceilingImages = [];
  List<String> loungelightingImages = [];
  List<String> loungewallsImages = [];
  List<String> loungeskirtingImages = [];
  List<String> loungewindowSillImages = [];
  List<String> loungecurtainsImages = [];
  List<String> loungeblindsImages = [];
  List<String> loungelightSwitchesImages = [];
  List<String> loungesocketsImages = [];
  List<String> loungeflooringImages = [];
  List<String> loungeadditionalItemsImages = [];
  late List<File> loungecapturedImages;

  @override
  void initState() {
    super.initState();
    loungecapturedImages = widget.loungecapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");

    // Load the saved preferences when the state is initialized
  }

  // Fetch images from Firestore
  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('lounge')
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lounge',
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                stream: _getImagesFromFirestore(propertyId, 'loungedoorImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door images');
                  }
                  final loungedoorImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Door",
                      condition: lougeDoorCondition,
                      description: loungedoorDescription,
                      images: loungedoorImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          lougeDoorCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'lougeDoorCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungedoorDescription = description;
                        });
                        _savePreference(
                            propertyId, 'loungedoorDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungedoorImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungedoorImages')
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
                    propertyId, 'loungedoorFrameImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door Frame images');
                  }
                  final loungedoorFrameImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Door Frame",
                      condition: loungedoorFrameCondition,
                      description: loungedoorFrameDescription,
                      images: loungedoorFrameImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungedoorFrameCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungedoorFrameCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungedoorFrameDescription = description;
                        });
                        _savePreference(propertyId,
                            'loungedoorFrameDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungedoorFrameImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungedoorFrameImages')
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
                    _getImagesFromFirestore(propertyId, 'loungeceilingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Ceiling images');
                  }
                  final loungeceilingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Ceiling",
                      condition: loungeceilingCondition,
                      description: loungeceilingDescription,
                      images: loungeceilingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungeceilingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungeceilingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungeceilingDescription = description;
                        });
                        _savePreference(propertyId, 'loungeceilingDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungeceilingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungeceilingImages')
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
                    _getImagesFromFirestore(propertyId, 'loungelightingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Lighting images');
                  }
                  final loungelightingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Lighting",
                      condition: loungelightingCondition,
                      description: loungelightingDescription,
                      images: loungelightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungelightingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungelightingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungelightingDescription = description;
                        });
                        _savePreference(propertyId, 'loungelightingDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungelightingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungelightingImages')
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
                    _getImagesFromFirestore(propertyId, 'loungewallsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Walls images');
                  }
                  final loungewallsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Walls",
                      condition: loungewallsCondition,
                      description: loungewallsDescription,
                      images: loungewallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungewallsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungewallsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungewallsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'loungewallsDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungewallsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungewallsImages')
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
                    _getImagesFromFirestore(propertyId, 'loungeskirtingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Skirting images');
                  }
                  final loungeskirtingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Skirting",
                      condition: loungeskirtingCondition,
                      description: loungeskirtingDescription,
                      images: loungeskirtingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungeskirtingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungeskirtingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungeskirtingDescription = description;
                        });
                        _savePreference(propertyId, 'loungeskirtingDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungeskirtingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungeskirtingImages')
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
                    propertyId, 'loungewindowSillImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Window Sill images');
                  }
                  final loungewindowSillImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Window Sill",
                      condition: loungewindowSillCondition,
                      description: loungewindowSillDescription,
                      images: loungewindowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungewindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'loungewindowSillCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungewindowSillDescription = description;
                        });
                        _savePreference(propertyId,
                            'loungewindowSillDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungewindowSillImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungewindowSillImages')
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
                    _getImagesFromFirestore(propertyId, 'loungecurtainsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Curtains images');
                  }
                  final loungecurtainsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Curtains",
                      condition: loungecurtainsCondition,
                      description: loungecurtainsDescription,
                      images: loungecurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungecurtainsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungecurtainsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungecurtainsDescription = description;
                        });
                        _savePreference(propertyId, 'loungecurtainsDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungecurtainsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungecurtainsImages')
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
                    _getImagesFromFirestore(propertyId, 'loungeblindsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Blinds images');
                  }
                  final loungeblindsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Blinds",
                      condition: loungeblindsCondition,
                      description: loungeblindsDescription,
                      images: loungeblindsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungeblindsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungeblindsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungeblindsDescription = description;
                        });
                        _savePreference(propertyId, 'loungeblindsDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungeblindsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungeblindsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Light Switches
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'loungelightSwitchesImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Light Switches images');
                  }
                  final loungelightSwitchesImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Light Switches",
                      condition: loungelightSwitchesCondition,
                      description: loungelightSwitchesDescription,
                      images: loungelightSwitchesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungelightSwitchesCondition = condition;
                        });
                        _savePreference(propertyId,
                            'loungelightSwitchesCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungelightSwitchesDescription = description;
                        });
                        _savePreference(propertyId,
                            'loungelightSwitchesDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungelightSwitchesImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungelightSwitchesImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Sockets
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'loungesocketsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Sockets images');
                  }
                  final loungesocketsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Sockets",
                      condition: loungesocketsCondition,
                      description: loungesocketsDescription,
                      images: loungesocketsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungesocketsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungesocketsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungesocketsDescription = description;
                        });
                        _savePreference(propertyId, 'loungesocketsDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungesocketsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungesocketsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      });
                },
              ),
              // Flooring
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'loungeflooringImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Flooring images');
                  }
                  final loungeflooringImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Flooring",
                      condition: loungeflooringCondition,
                      description: loungeflooringDescription,
                      images: loungeflooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungeflooringCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'loungeflooringCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungeflooringDescription = description;
                        });
                        _savePreference(propertyId, 'loungeflooringDescription',
                            description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungeflooringImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungeflooringImages')
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
                    propertyId, 'loungeadditionalItemsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Additional Items images');
                  }
                  final loungeadditionalItemsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Additional Items",
                      condition: loungeadditionalItemsCondition,
                      description: loungeadditionalItemsDescription,
                      images: loungeadditionalItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          loungeadditionalItemsCondition = condition;
                        });
                        _savePreference(propertyId,
                            'loungeadditionalItemsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          loungeadditionalItemsDescription = description;
                        });
                        _savePreference(propertyId,
                            'loungeadditionalItemsDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'lounge',
                            'loungeadditionalItemsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('lounge')
                              .doc('loungeadditionalItemsImages')
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
