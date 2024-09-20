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

class Garage extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Garage({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  String? newdoor;
  String? garageDoorCondition;
  String? garageDoorDescription;
  String? garageDoorFrameCondition;
  String? garageDoorFrameDescription;
  String? garageceilingCondition;
  String? garageceilingDescription;
  String? garagelightingCondition;
  String? garagelightingDescription;
  String? garagewallsCondition;
  String? garagewallsDescription;
  String? garageskirtingCondition;
  String? garageskirtingDescription;
  String? garagewindowSillCondition;
  String? garagewindowSillDescription;
  String? garagecurtainsCondition;
  String? garagecurtainsDescription;
  String? garageblindsCondition;
  String? garageblindsDescription;
  String? garagelightSwitchesCondition;
  String? garagelightSwitchesDescription;
  String? garagesocketsCondition;
  String? garagesocketsDescription;
  String? garageflooringCondition;
  String? garageflooringDescription;
  String? garageadditionalItemsCondition;
  String? garageadditionalItemsDescription;
  String? garagedoorImagePath;
  String? garagedoorFrameImagePath;
  String? garageceilingImagePath;
  String? garagelightingImagePath;
  String? garagewallsImagePath;
  String? garageskirtingImagePath;
  String? garagewindowSillImagePath;
  String? garagecurtainsImagePath;
  String? garageblindsImagePath;
  String? garagelightSwitchesImagePath;
  String? garagesocketsImagePath;
  String? garageflooringImagePath;
  String? garageadditionalItemsImagePath;
  List<String> garagedoorImages = [];
  List<String> garagedoorFrameImages = [];
  List<String> garageceilingImages = [];
  List<String> garagelightingImages = [];
  List<String> garagewallsImages = [];
  List<String> garageskirtingImages = [];
  List<String> garagewindowSillImages = [];
  List<String> garagecurtainsImages = [];
  List<String> garageblindsImages = [];
  List<String> garagelightSwitchesImages = [];
  List<String> garagesocketsImages = [];
  List<String> garageflooringImages = [];
  List<String> garageadditionalItemsImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
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

  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('garage')
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
              'Garage',
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
                    stream: _getImagesFromFirestore(propertyId, 'garagedoorImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagedoorImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Door",
                          condition: garageDoorCondition,
                          description: garageDoorCondition,
                          images: garagedoorImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageDoorCondition = condition;
                            });
                            _savePreference(
                                propertyId, 'garageDoorCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageDoorCondition = description;
                            });
                            _savePreference(propertyId, 'garageDoorCondition',
                                description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile, propertyId, 'garage', 'garagedoorImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagedoorImages')
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
                        propertyId, 'garagedoorFrameImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagedoorFrameImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Door Frame",
                          condition: garageDoorFrameCondition,
                          description: garageDoorFrameCondition,
                          images: garagedoorFrameImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageDoorFrameCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garageDoorFrameCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageDoorFrameCondition = description;
                            });
                            _savePreference(propertyId,
                                'garageDoorFrameCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagedoorFrameImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagedoorFrameImages')
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
                        propertyId, 'garageceilingImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garageceilingImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Ceiling",
                          condition: garageceilingCondition,
                          description: garageceilingCondition,
                          images: garageceilingImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageceilingCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garageceilingCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageceilingCondition = description;
                            });
                            _savePreference(propertyId,
                                'garageceilingCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garageceilingImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garageceilingImages')
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
                        propertyId, 'garagelightingImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagelightingImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Lighting",
                          condition: garagelightingCondition,
                          description: garagelightingCondition,
                          images: garagelightingImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garagelightingCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garagelightingCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garagelightingCondition = description;
                            });
                            _savePreference(propertyId,
                                'garagelightingCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagelightingImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagelightingImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Walls
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(
                        propertyId, 'garagewallsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagewallsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Walls",
                          condition: garagewallsCondition,
                          description: garagewallsCondition,
                          images: garagewallsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garagewallsCondition = condition;
                            });
                            _savePreference(
                                propertyId, 'garagewallsCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garagewallsCondition = description;
                            });
                            _savePreference(propertyId, 'garagewallsCondition',
                                description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagewallsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagewallsImages')
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
                        propertyId, 'garageskirtingImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garageskirtingImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Skirting",
                          condition: garageskirtingCondition,
                          description: garageskirtingCondition,
                          images: garageskirtingImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageskirtingCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garageskirtingCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageskirtingCondition = description;
                            });
                            _savePreference(propertyId,
                                'garageskirtingCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garageskirtingImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garageskirtingImages')
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
                        propertyId, 'garagewindowSillImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagewindowSillImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Window Sill",
                          condition: garagewindowSillCondition,
                          description: garagewindowSillCondition,
                          images: garagewindowSillImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garagewindowSillCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garagewindowSillCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garagewindowSillCondition = description;
                            });
                            _savePreference(propertyId,
                                'garagewindowSillCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagewindowSillImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagewindowSillImages')
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
                        propertyId, 'garagecurtainsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagecurtainsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Curtains",
                          condition: garagecurtainsCondition,
                          description: garagecurtainsCondition,
                          images: garagecurtainsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garagecurtainsCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garagecurtainsCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garagecurtainsCondition = description;
                            });
                            _savePreference(propertyId,
                                'garagecurtainsCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagecurtainsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagecurtainsImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Blinds
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(
                        propertyId, 'garageblindsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garageblindsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Blinds",
                          condition: garageblindsCondition,
                          description: garageblindsCondition,
                          images: garageblindsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageblindsCondition = condition;
                            });
                            _savePreference(propertyId, 'garageblindsCondition',
                                condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageblindsCondition = description;
                            });
                            _savePreference(propertyId, 'garageblindsCondition',
                                description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garageblindsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garageblindsImages')
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
                        propertyId, 'garagelightSwitchesImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagelightSwitchesImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Light Switches",
                          condition: garagelightSwitchesCondition,
                          description: garagelightSwitchesCondition,
                          images: garagelightSwitchesImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garagelightSwitchesCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garagelightSwitchesCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garagelightSwitchesCondition = description;
                            });
                            _savePreference(propertyId,
                                'garagelightSwitchesCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagelightSwitchesImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagelightSwitchesImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Sockets
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(
                        propertyId, 'garagesocketsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garagesocketsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Sockets",
                          condition: garagesocketsCondition,
                          description: garagesocketsCondition,
                          images: garagesocketsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garagesocketsCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garagesocketsCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garagesocketsCondition = description;
                            });
                            _savePreference(propertyId,
                                'garagesocketsCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garagesocketsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garagesocketsImages')
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
                        propertyId, 'garageflooringImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garageflooringImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Flooring",
                          condition: garageflooringCondition,
                          description: garageflooringCondition,
                          images: garageflooringImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageflooringCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garageflooringCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageflooringCondition = description;
                            });
                            _savePreference(propertyId,
                                'garageflooringCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garageflooringImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garageflooringImages')
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
                        propertyId, 'garageadditionalItemsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final garageadditionalItemsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Additional Items",
                          condition: garageadditionalItemsCondition,
                          description: garageadditionalItemsCondition,
                          images: garageadditionalItemsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              garageadditionalItemsCondition = condition;
                            });
                            _savePreference(propertyId,
                                'garageadditionalItemsCondition', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              garageadditionalItemsCondition = description;
                            });
                            _savePreference(propertyId,
                                'garageadditionalItemsCondition', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'garage',
                                'garageadditionalItemsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('garage')
                                  .doc('garageadditionalItemsImages')
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
        ));
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
          // SizedBox(
          //   height: 12,
          // ),
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
