import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class UtilityRoom extends StatefulWidget {
  final List<File>? utilitycapturedImages;
  final String propertyId;
  const UtilityRoom(
      {super.key, this.utilitycapturedImages, required this.propertyId});

  @override
  State<UtilityRoom> createState() => _UtilityRoomState();
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


class _UtilityRoomState extends State<UtilityRoom> {
  String? utilityNewdoor;
  String? utilityDoorCondition;
  String? utilityDoorDescription;
  String? utilityDoorFrameCondition;
  String? utilityDoorFrameDescription;
  String? utilityCeilingCondition;
  String? utilityCeilingDescription;
  String? utilityLightingCondition;
  String? utilitylightingDescription;
  String? utilitywallsCondition;
  String? utilitywallsDescription;
  String? utilityskirtingCondition;
  String? utilityskirtingDescription;
  String? utilitywindowSillCondition;
  String? utilitywindowSillDescription;
  String? utilitycurtainsCondition;
  String? utilitycurtainsDescription;
  String? utilityblindsCondition;
  String? utilityblindsDescription;
  String? utilitylightSwitchesCondition;
  String? utilitylightSwitchesDescription;
  String? utilitysocketsCondition;
  String? utilitysocketsDescription;
  String? utilityflooringCondition;
  String? utilityflooringDescription;
  String? utilityadditionalItemsCondition;
  String? utilityadditionalItemsDescription;
  List<String> utilitydoorImages = [];
  List<String> utilitydoorFrameImages = [];
  List<String> utilityceilingImages = [];
  List<String> utilitylightingImages = [];
  List<String> utilitywallsImages = [];
  List<String> utilityskirtingImages = [];
  List<String> utilitywindowSillImages = [];
  List<String> utilitycurtainsImages = [];
  List<String> utilityblindsImages = [];
  List<String> utilitylightSwitchesImages = [];
  List<String> utilitysocketsImages = [];
  List<String> utilityflooringImages = [];
  List<String> utilityadditionalItemsImages = [];
  late List<File> utilitycapturedImages;

  @override
  void initState() {
    super.initState();
    utilitycapturedImages = widget.utilitycapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

  // Fetch images from Firestore
  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('utility_room')
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

  //
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
          'Utility Room',
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
                stream:
                    _getImagesFromFirestore(propertyId, 'utilitydoorImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door images');
                  }
                  final utilitydoorImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Door",
                      condition: utilityDoorCondition,
                      description: utilityDoorDescription,
                      images: utilitydoorImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          utilityDoorCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'utilityDoorCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          utilityDoorDescription = description;
                        });
                        _savePreference(
                            propertyId, 'utilityDoorDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile,
                            propertyId,
                            'utility_room',
                            'utilitydoorImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('utility_room')
                              .doc('utilitydoorImages')
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
                    propertyId, 'utilitydoorFrameImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door Frame images');
                  }
                  final utilitydoorFrameImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Door Frame",
                    condition: utilityDoorFrameCondition,
                    description: utilityDoorFrameDescription,
                    images: utilitydoorFrameImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilityDoorFrameCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilityDoorFrameCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilityDoorFrameDescription = description;
                      });
                      _savePreference(propertyId, 'utilityDoorFrameDescription',
                          description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'utility_room',
                          'utilitydoorFrameImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('ulitity_room')
                            .doc('utilitydoorFrameImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),

              // Ceiling
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'utilityceilingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Celling images');
                  }
                  final utilityceilingImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Ceiling",
                    condition: utilityCeilingCondition,
                    description: utilityCeilingDescription,
                    images: utilityceilingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilityCeilingCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilityCeilingCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilityCeilingDescription = description;
                      });
                      _savePreference(propertyId, 'utilityCeilingDescription',
                          description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'utility_room',
                          'utilityceilingImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('uliity_room')
                            .doc('utilityceilingImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),

              // Lighting
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'utilitylightingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Lighting images');
                  }
                  final utilitylightingImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: " Lighting",
                    condition: utilityLightingCondition,
                    description: utilitylightingDescription,
                    images: utilitylightingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilityLightingCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilityLightingCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilitylightingDescription = description;
                      });
                      _savePreference(propertyId, 'utilitylightingDescription',
                          description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'utility_room',
                          'utilitylightingImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('utility_room')
                            .doc('utilitylightingImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
              // Walls
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(propertyId, 'utilitywallsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Mortice images');
                  }
                  final utilitywallsImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Walls",
                    condition: utilitywallsCondition,
                    description: utilitywallsDescription,
                    images: utilitywallsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilitywallsCondition= condition;
                      });
                      _savePreference(propertyId, 'utilitywallsCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilitywallsDescription = description;
                      });
                      _savePreference(propertyId, 'utilitywallsDescription', description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'ultility_room',
                          'utilitywallsImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('utility_room')
                            .doc('utilitywallsImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
              // Skirting
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(propertyId, 'utilityskirtingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Skirting images');
                  }
                  final utilityskirtingImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Skirting",
                    condition: utilityskirtingCondition,
                    description: utilityskirtingDescription,
                    images: utilityskirtingImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilityskirtingCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilityskirtingCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilityskirtingDescription = description;
                      });
                      _savePreference(
                          propertyId, 'utilityskirtingDescription,', description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'ultility_room',
                          'utilityskirtingImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('ultility_room')
                            .doc('utilityskirtingImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
           // Window Sill
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(propertyId, 'utilitywindowSillImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Window Sill images');
                  }
                  final utilitywindowSillImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Window Sill",
                    condition: utilitywindowSillCondition,
                    description: utilitywindowSillDescription,
                    images: utilitywindowSillImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilitywindowSillCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilitywindowSillCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilitywindowSillDescription = description;
                      });
                      _savePreference(
                          propertyId, 'utilitywindowSillDescription,', description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'keys_handover',
                          'utilitywindowSillImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('keys_handover')
                            .doc('utilitywindowSillImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
            // Curtains
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(propertyId, 'utilitycurtainsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Curtains images');
                  }
                  final utilitycurtainsImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Curtains",
                    condition: utilitycurtainsCondition,
                    description: utilitycurtainsDescription,
                    images: utilitycurtainsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilitycurtainsCondition= condition;
                      });
                      _savePreference(
                          propertyId, 'utilitycurtainsCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilitycurtainsDescription= description;
                      });
                      _savePreference(
                          propertyId, 'utilitycurtainsDescription', description!);
                    },
                   onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'keys_handover',
                          'utilitycurtainsImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('utiliy_room')
                            .doc('utilitycurtainsImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
              // Blinds
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(propertyId, 'utilityblindsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Blinds images');
                  }
                  final utilityblindsImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Blinds",
                    condition: utilityblindsCondition,
                    description: utilityblindsDescription,
                    images: utilityblindsImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilityblindsCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilityblindsCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilityblindsDescription = description;
                      });
                      _savePreference(
                          propertyId, 'utilityblindsDescription,', description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'ultility_room',
                          'utilityblindsImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('ultility_room')
                            .doc('utilityblindsImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
             // Light Switches
              StreamBuilder<List<String>>(
                stream:
                    _getImagesFromFirestore(propertyId, 'utilitylightSwitchesImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Light Switches images');
                  }
                  final utilitylightSwitchesImages = snapshot.data ?? [];
                  return ConditionItem(
                    name: "Light Switches",
                    condition: utilitylightSwitchesCondition,
                    description: utilitylightSwitchesDescription,
                    images: utilitylightSwitchesImages,
                    onConditionSelected: (condition) {
                      setState(() {
                        utilitylightSwitchesCondition = condition;
                      });
                      _savePreference(
                          propertyId, 'utilitylightSwitchesCondition', condition!);
                    },
                    onDescriptionSelected: (description) {
                      setState(() {
                        utilitylightSwitchesDescription = description;
                      });
                      _savePreference(
                          propertyId, 'utilitylightSwitchesDescription', description!);
                    },
                    onImageAdded: (imagePath) async {
                      File imageFile = File(imagePath);
                      String? downloadUrl = await uploadImageToFirebase(
                          imageFile,
                          propertyId,
                          'ulitity_room',
                          'utilitylightSwitchesImages');

                      if (downloadUrl != null) {
                        print("Adding image URL to Firestore: $downloadUrl");
                        FirebaseFirestore.instance
                            .collection('properties')
                            .doc(propertyId)
                            .collection('ulitity_room')
                            .doc('utilitylightSwitchesImages')
                            .update({
                          'images': FieldValue.arrayUnion([downloadUrl]),
                        });
                      }
                    },
                  );
                },
              ),
              // Sockets
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitysocketsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final utilitysocketsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Sockets",
                        condition: utilitysocketsCondition,
                        description: utilitysocketsDescription,
                        images: utilitysocketsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          utilitysocketsCondition = condition;
                        });
                        _savePreference(propertyId, 'utilitysocketsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          utilitysocketsDescription = description;
                        });
                        _savePreference(propertyId, 'utilitysocketsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'utility_room', 'utilitysocketsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('utility_room')
                                .doc('utilitysocketsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
              // Flooring
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityflooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final utilityflooringImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Flooring",
                        condition: utilityflooringCondition,
                        description: utilityflooringDescription,
                        images: utilityflooringImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          utilityflooringCondition = condition;
                        });
                        _savePreference(propertyId, 'utilityflooringCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          utilityflooringDescription = description;
                        });
                        _savePreference(propertyId, 'utilityflooringDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'utility_room', 'utilityflooringImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('utility_room')
                                .doc('utilityflooringImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
              // Additional Items
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityadditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final utilityadditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Additional Items",
                        condition: utilityadditionalItemsCondition,
                        description: utilityadditionalItemsDescription,
                        images: utilityadditionalItemsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          utilityadditionalItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'utilityadditionalItemsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          utilityadditionalItemsDescription = description;
                        });
                        _savePreference(propertyId, 'utilityadditionalItemsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'utility_room', 'utilityadditionalItemsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('utility_room')
                                .doc('utilityadditionalItemsImages')
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
