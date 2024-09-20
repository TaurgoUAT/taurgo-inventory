import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';

import '../../constants/AppColors.dart';

import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart'; // Import shared_preferences
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart';

class ScheduleOfCondition extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const ScheduleOfCondition(
      {super.key, this.capturedImages, required this.propertyId});

  @override
  State<ScheduleOfCondition> createState() => _ScheduleOfConditionState();
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

class _ScheduleOfConditionState extends State<ScheduleOfCondition> {
  late List<File> capturedImages;

  String? overview;
  String? accessoryCleanliness;
  String? windowSill;
  String? carpets;
  String? ceilings;
  String? curtains;
  String? hardFlooring;
  String? kitchenArea;
  String? kitchen;
  String? oven;
  String? mattress;
  String? upholstrey;
  String? wall;
  String? window;
  String? woodwork;
  List<String> overviewImages = [];
  List<String> accessoryCleanlinessImages = [];
  List<String> windowSillImages = [];
  List<String> carpetsImages = [];
  List<String> ceilingsImages = [];
  List<String> curtainsImages = [];
  List<String> hardFlooringImages = [];
  List<String> kitchenAreaImages = [];
  List<String> kitchenImages = [];
  List<String> ovenImages = [];
  List<String> mattressImages = [];
  List<String> upholstreyImages = [];
  List<String> wallImages = [];
  List<String> windowImages = [];
  List<String> woodworkImages = [];

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
  }

  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('ScheduleOfCondition')
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
              'Schedule of Condition',
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
                  // Overview
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'overviewImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final overviewImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Overview",
                          condition: overview,
                          description: overview,
                          images: overviewImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              overview = condition;
                            });
                            _savePreference(propertyId, 'overview', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              overview = description;
                            });
                            _savePreference(
                                propertyId, 'overview', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'overviewImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('overviewImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Accessory Cleanliness
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(
                        propertyId, 'accessoryCleanlinessImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final accessoryCleanlinessImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Accessory Cleanliness",
                          condition: accessoryCleanliness,
                          description: accessoryCleanliness,
                          images: accessoryCleanlinessImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              accessoryCleanliness = condition;
                            });
                            _savePreference(propertyId, ' accessoryCleanliness',
                                condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              accessoryCleanliness = description;
                            });
                            _savePreference(propertyId, 'accessoryCleanliness',
                                description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'accessoryCleanlinessImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('accessoryCleanlinessImages')
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
                        _getImagesFromFirestore(propertyId, 'windowSillImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final windowSillImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Window Sill",
                          condition: windowSill,
                          description: windowSill,
                          images: windowSillImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              windowSill = condition;
                            });
                            _savePreference(
                                propertyId, 'windowSill,', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              windowSill = description;
                            });
                            _savePreference(
                                propertyId, 'windowSill,', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'windowSillImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('windowSillImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Carpets
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'carpetsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final carpetsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Carpets",
                          condition: carpets,
                          description: carpets,
                          images: carpetsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              carpets = condition;
                            });
                            _savePreference(propertyId, 'carpets', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              carpets = description;
                            });
                            _savePreference(
                                propertyId, 'carpets', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'carpetsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('carpetsImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Ceilings
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'ceilingsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final ceilingsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Ceilings",
                          condition: ceilings,
                          description: ceilings,
                          images: ceilingsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              ceilings = condition;
                            });
                            _savePreference(propertyId, 'ceilings', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              ceilings = description;
                            });
                            _savePreference(
                                propertyId, 'ceilings', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'ceilingsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('ceilingsImages')
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
                        _getImagesFromFirestore(propertyId, 'curtainsImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final curtainsImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Curtains",
                          condition: curtains,
                          description: curtains,
                          images: curtainsImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              curtains = condition;
                            });
                            _savePreference(propertyId, 'curtains', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              curtains = description;
                            });
                            _savePreference(
                                propertyId, 'curtains', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'curtainsImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('curtainsImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Hard Flooring
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(
                        propertyId, 'hardFlooringImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final hardFlooringImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Hard Flooring",
                          condition: hardFlooring,
                          description: hardFlooring,
                          images: hardFlooringImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              hardFlooring = condition;
                            });
                            _savePreference(
                                propertyId, 'hardFlooring', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              hardFlooring = description;
                            });
                            _savePreference(
                                propertyId, 'hardFlooring', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'hardFlooringImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('overviewImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Kitchen Area
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(
                        propertyId, 'kitchenAreaImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final kitchenAreaImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Kitchen Area",
                          condition: kitchenArea,
                          description: kitchenArea,
                          images: kitchenAreaImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              kitchenArea = condition;
                            });
                            _savePreference(
                                propertyId, 'kitchenArea', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              kitchenArea = description;
                            });
                            _savePreference(
                                propertyId, 'kitchenArea', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'kitchenAreaImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('kitchenAreaImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                    StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'kitchenImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final kitchenImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Kitchen",
                        condition: kitchen,
                        description: kitchen,
                        images: kitchenImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          kitchen = condition;
                        });
                        _savePreference(propertyId, 'kitchen', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          kitchen = description;
                        });
                        _savePreference(propertyId, 'kitchen', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'ScheduleOfCondition', 'kitchenImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('ScheduleOfCondition')
                                .doc('kitchenImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
                  // Oven
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(propertyId, 'ovenImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final ovenImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Oven",
                          condition: oven,
                          description: oven,
                          images: ovenImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              oven = condition;
                            });
                            _savePreference(propertyId, 'oven', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              oven = description;
                            });
                            _savePreference(propertyId, 'oven', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'ovenImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('ovenImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Mattress
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'mattressImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final mattressImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Mattress",
                          condition: mattress,
                          description: mattress,
                          images: mattressImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              mattress = condition;
                            });
                            _savePreference(propertyId, 'mattress', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              mattress = description;
                            });
                            _savePreference(
                                propertyId, 'mattress', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'mattressImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('mattressImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Upholstrey
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'upholstreyImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final upholstreyImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: " Upholstrey",
                          condition: upholstrey,
                          description: upholstrey,
                          images: upholstreyImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              upholstrey = condition;
                            });
                            _savePreference(
                                propertyId, 'upholstrey', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              upholstrey = description;
                            });
                            _savePreference(
                                propertyId, 'upholstrey', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'upholstreyImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('upholstreyImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Wall
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(propertyId, 'wallImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final wallImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Wall",
                          condition: wall,
                          description: wall,
                          images: wallImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              wall = condition;
                            });
                            _savePreference(propertyId, 'wall', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              wall = description;
                            });
                            _savePreference(propertyId, 'wall', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'wallImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('wallImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),
                  // Window
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(propertyId, 'windowImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final windowImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Window",
                          condition: window,
                          description: window,
                          images: windowImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              window = condition;
                            });
                            _savePreference(propertyId, 'window', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              window = description;
                            });
                            _savePreference(propertyId, 'window', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'windowImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('windowImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Woodwork
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'woodworkImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final woodworkImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Woodwork",
                          condition: woodwork,
                          description: woodwork,
                          images: woodworkImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              woodwork = condition;
                            });
                            _savePreference(propertyId, 'woodwork', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              woodwork = description;
                            });
                            _savePreference(
                                propertyId, 'woodwork', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile,
                                propertyId,
                                'ScheduleOfCondition',
                                'woodworkImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('ScheduleOfCondition')
                                  .doc('woodworkImages')
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
// Import shared_preferences

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
