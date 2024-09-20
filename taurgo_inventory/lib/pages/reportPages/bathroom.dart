import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart'
as reportPages;
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart';
import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Bathroom extends StatefulWidget {
  final List<File>? bathroomcapturedImages;
  final String propertyId;
  const Bathroom(
      {super.key, this.bathroomcapturedImages, required this.propertyId});

  @override
  State<Bathroom> createState() => _BathroomState();
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

Stream<List<String>> _getImagesFromFirestore(String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('bathroom')
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

class _BathroomState extends State<Bathroom> {
  String? bathroomdoorCondition;
  String? bathroomdoorDescription;
  String? bathroomdoorFrameCondition;
  String? bathroomdoorFrameDescription;
  String? bathroomceilingCondition;
  String? bathroomceilingDescription;
  String? bathroomextractorFanCondition;
  String? bathroomextractorFanDescription;
  String? bathroomlightingCondition;
  String? bathroomlightingDescription;
  String? bathroomwallsCondition;
  String? bathroomwallsDescription;
  String? bathroomskirtingCondition;
  String? bathroomskirtingDescription;
  String? bathroomwindowSillCondition;
  String? bathroomwindowSillDescription;
  String? bathroomcurtainsCondition;
  String? bathroomcurtainsDescription;
  String? bathroomblindsCondition;
  String? bathroomblindsDescription;
  String? bathroomtoiletCondition;
  String? bathroomtoiletDescription;
  String? bathroombasinCondition;
  String? bathroombasinDescription;
  String? bathroomshowerCubicleCondition;
  String? bathroomshowerCubicleDescription;
  String? bathroombathCondition;
  String? bathroombathDescription;
  String? bathroomswitchBoardCondition;
  String? bathroomswitchBoardDescription;
  String? bathroomsocketCondition;
  String? bathroomsocketDescription;
  String? bathroomheatingCondition;
  String? bathroomheatingDescription;
  String? bathroomaccessoriesCondition;
  String? bathroomaccessoriesDescription;
  String? bathroomflooringCondition;
  String? bathroomflooringDescription;
  String? bathroomadditionItemsCondition;
  String? bathroomadditionItemsDescription;
  String? doorImagePath;
  String? doorFrameImagePath;
  String? ceilingImagePath;
  String? extractorFanImagePath;
  String? lightingImagePath;
  String? wallsImagePath;
  String? skirtingImagePath;
  String? windowSillImagePath;
  String? curtainsImagePath;
  String? blindsImagePath;
  String? toiletImagePath;
  String? basinImagePath;
  String? showerCubicleImagePath;
  String? bathImagePath;
  String? switchBoardImagePath;
  String? socketImagePath;
  String? heatingImagePath;
  String? accessoriesImagePath;
  String? flooringImagePath;
  String? additionItemsImagePath;
  List<String> bathroomdoorImages = [];
  List<String> bathroomdoorFrameImages = [];
  List<String> bathroomceilingImages = [];
  List<String> bathroomextractorFanImages = [];
  List<String> bathroomlightingImages = [];
  List<String> bathroomwallsImages = [];
  List<String> bathroomskirtingImages = [];
  List<String> bathroomwindowSillImages = [];
  List<String> bathroomcurtainsImages = [];
  List<String> bathroomblindsImages = [];
  List<String> bathroomtoiletImages = [];
  List<String> bathroombasinImages = [];
  List<String> bathroomshowerCubicleImages = [];
  List<String> bathroombathImages = [];
  List<String> bathroomswitchBoardImages = [];
  List<String> bathroomsocketImages = [];
  List<String> bathroom = [];
  List<String> bathroomheatingImages = [];
  List<String> bathroomaccessoriesImages = [];
  List<String> bathroomflooringImages = [];
  List<String> bathroomadditionItemsImages = [];
  late List<File> bathroomcapturedImages;

  @override
  void initState() {
    super.initState();
    bathroomcapturedImages = widget.bathroomcapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

  
  

  // Save preferences when a condition or description is selected
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
          'Bath Room',
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomdoorImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomdoorImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door",
                      condition: bathroomdoorCondition,
                      description: bathroomdoorDescription,
                      images: bathroomdoorImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomdoorCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomdoorCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomdoorDescription = description;
                        });
                        _savePreference(propertyId, 'bathroomdoorDescription', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomdoorImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomdoorImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Door Frame
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomdoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomdoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door Frame",
                      condition:  bathroomdoorFrameCondition,
                      description: bathroomdoorFrameCondition,
                      images: bathroomdoorFrameImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomdoorFrameCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomdoorFrameCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomdoorFrameCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomdoorFrameCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomdoorFrameImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomdoorFrameImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomceilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomceilingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Ceiling",
                      condition: bathroomceilingCondition,
                      description: bathroomceilingCondition,
                      images: bathroomceilingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomceilingCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomceilingCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomceilingCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomceilingCondition,', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomceilingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomceilingImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Extractor Fan
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomextractorFanImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomextractorFanImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Extractor Fan",
                      condition: bathroomextractorFanCondition,
                      description: bathroomextractorFanCondition,
                      images: bathroomextractorFanImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomextractorFanCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomextractorFanCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomextractorFanCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomextractorFanCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomextractorFanImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomextractorFanImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomlightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomlightingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Lighting",
                      condition: bathroomlightingCondition,
                      description: bathroomlightingCondition,
                      images: bathroomlightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomlightingCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomlightingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomlightingCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomlightingCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomlightingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomlightingImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomwallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomwallsImages= snapshot.data ?? [];
                    return ConditionItem(
                      name: "Walls",
                      condition: bathroomwallsCondition,
                      description: bathroomwallsCondition,
                      images: bathroomwallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomwallsCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomwallsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomwallsCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomwallsCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomwallsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomwallsImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomskirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomskirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Skirting",
                      condition: bathroomskirtingCondition,
                      description: bathroomskirtingCondition,
                      images: bathroomskirtingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomskirtingCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomskirtingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomskirtingCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomskirtingCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomskirtingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomskirtingImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomwindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomwindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Window Sill",
                      condition: bathroomwindowSillCondition,
                      description: bathroomwindowSillCondition,
                      images: bathroomwindowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomwindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomwindowSillCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomwindowSillCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomwindowSillCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomwindowSillImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomwindowSillImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomcurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomcurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Curtains",
                      condition: bathroomcurtainsCondition,
                      description: bathroomcurtainsCondition,
                      images: bathroomcurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomcurtainsCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomcurtainsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomcurtainsCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomcurtainsCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomcurtainsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomcurtainsImages')
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
                  stream: _getImagesFromFirestore(propertyId, 'bathroomblindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomblindsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Blinds",
                      condition: bathroomblindsCondition,
                      description: bathroomblindsCondition,
                      images: bathroomblindsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomblindsCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomblindsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomblindsCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomblindsCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomblindsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomblindsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Toilet
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomtoiletImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomtoiletImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Toilet",
                      condition: bathroomtoiletCondition,
                      description: bathroomtoiletCondition,
                      images: bathroomtoiletImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomtoiletCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomtoiletCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomtoiletCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomtoiletCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomtoiletImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomtoiletImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Basin
             StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroombasinImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroombasinImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Basin",
                      condition: bathroombasinCondition,
                      description: bathroombasinCondition,
                      images: bathroombasinImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroombasinCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroombasinCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroombasinCondition = description;
                        });
                        _savePreference(propertyId, 'bathroombasinCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroombasinImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroombasinImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Shower Cubicle
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomshowerCubicleImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomshowerCubicleImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Shower Cubicle",
                      condition: bathroomshowerCubicleCondition,
                      description: bathroomshowerCubicleCondition,
                      images: bathroomshowerCubicleImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomshowerCubicleCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomshowerCubicleCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomshowerCubicleCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomshowerCubicleCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomshowerCubicleImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomshowerCubicleImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Bath
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroombathImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroombathImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Bath",
                      condition: bathroombathCondition,
                      description: bathroombathCondition,
                      images: bathroombathImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroombathCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroombathCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroombathCondition = description;
                        });
                        _savePreference(propertyId, 'bathroombathCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroombathImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroombathImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Switch Board
             StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomswitchBoardImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomswitchBoardImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Switch Board",
                      condition: bathroomswitchBoardCondition,
                      description: bathroomswitchBoardCondition,
                      images: bathroomswitchBoardImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomswitchBoardCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomswitchBoardCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomswitchBoardCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomswitchBoardCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomswitchBoardImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomswitchBoardImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Socket
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomsocketImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomsocketImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Socket",
                      condition: bathroomsocketCondition,
                      description: bathroomsocketCondition,
                      images: bathroomsocketImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomsocketCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomsocketCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomsocketCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomsocketCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomsocketImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomsocketImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),
              // Heating
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomheatingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomheatingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Heating",
                      condition:bathroomheatingCondition ,
                      description: bathroomheatingCondition,
                      images: bathroomheatingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomheatingCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomheatingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomheatingCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomheatingCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomheatingImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomheatingImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),

              // Accessories
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomaccessoriesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomaccessoriesImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Accessories",
                      condition: bathroomaccessoriesCondition,
                      description: bathroomaccessoriesCondition,
                      images: bathroomaccessoriesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomaccessoriesCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomaccessoriesCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomaccessoriesCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomaccessoriesCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomaccessoriesImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomaccessoriesImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),
              // Flooring
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomflooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomflooringImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Flooring",
                      condition: bathroomflooringCondition,
                      description: bathroomflooringCondition,
                      images: bathroomflooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomflooringCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomflooringCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomflooringCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomflooringCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomflooringImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomflooringImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
                  },
                ),
              // Addition Items
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bathroomadditionItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other images');
                    }
                    final bathroomadditionItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Additional Items",
                      condition: bathroomadditionItemsCondition,
                      description: bathroomadditionItemsCondition,
                      images: bathroomadditionItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bathroomadditionItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'bathroomadditionItemsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bathroomadditionItemsCondition = description;
                        });
                        _savePreference(propertyId, 'bathroomadditionItemsCondition', description!);
                      },
                      onImageAdded: (imagePath) async {
                        File imageFile = File(imagePath);
                        String? downloadUrl = await uploadImageToFirebase(
                            imageFile, propertyId,'bathroom', 'bathroomadditionItemsImages');

                        if (downloadUrl != null) {
                          print("Adding image URL to Firestore: $downloadUrl");
                          FirebaseFirestore.instance
                              .collection('properties')
                              .doc(propertyId)
                              .collection('bathroom')
                              .doc('bathroomadditionItemsImages')
                              .update({
                            'images': FieldValue.arrayUnion([downloadUrl]),
                          });
                        }
                      },
                    );
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
                            builder: (context) => reportPages.CameraPreviewPage(
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
