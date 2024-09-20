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

class Landing extends StatefulWidget {
  final List<File>? landingcapturedImages;
  final String propertyId;
  const Landing(
      {super.key, this.landingcapturedImages, required this.propertyId});

  @override
  State<Landing> createState() => _LandingState();
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
class _LandingState extends State<Landing> {
  String? landingnewdoor;
  String? landingdoorCondition;
  String? landingdoorDescription;
  String? landingdoorFrameCondition;
  String? landingdoorFrameDescription;
  String? landingceilingCondition;
  String? landingceilingDescription;
  String? landinglightingCondition;
  String? landinglightingDescription;
  String? landingwallsCondition;
  String? landingwallsDescription;
  String? landingskirtingCondition;
  String? landingskirtingDescription;
  String? landingwindowSillCondition;
  String? landingwindowSillDescription;
  String? landingcurtainsCondition;
  String? landingcurtainsDescription;
  String? landingblindsCondition;
  String? landingblindsDescription;
  String? landinglightSwitchesCondition;
  String? landinglightSwitchesDescription;
  String? landingsocketsCondition;
  String? landingsocketsDescription;
  String? landingflooringCondition;
  String? landingflooringDescription;
  String? landingadditionalItemsCondition;
  String? landingadditionalItemsDescription;
  List<String> landingdoorImages = [];
  List<String> landingdoorFrameImages = [];
  List<String> landingceilingImages = [];
  List<String> landinglightingImages = [];
  List<String> ladingwallsImages = [];
  List<String> landingskirtingImages = [];
  List<String> landingwindowSillImages = [];
  List<String> landingcurtainsImages = [];
  List<String> landingblindsImages = [];
  List<String> landinglightSwitchesImages = [];
  List<String> landingsocketsImages = [];
  List<String> landingflooringImages = [];
  List<String> landingadditionalItemsImages = [];
  late List<File> landingcapturedImages;

  @override
  void initState() {
    super.initState();
    landingcapturedImages = widget.landingcapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

 
   Stream<List<String>> _getImagesFromFirestore(String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('landing')
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
          'Landing',
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
              // 
              // // Door Frame
              

              // Ceiling
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingceilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingceilingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Ceiling",
                        condition: landingceilingCondition,
                        description: landingceilingDescription,
                        images: landingceilingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingceilingCondition = condition;
                        });
                        _savePreference(propertyId, 'landingceilingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingceilingDescription = description;
                        });
                        _savePreference(propertyId, 'landingceilingDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingceilingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingceilingImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Lighting
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landinglightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landinglightingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Lighting",
                        condition: landinglightingCondition,
                        description: landinglightingDescription,
                        images: landinglightingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landinglightingCondition = condition;
                        });
                        _savePreference(propertyId, 'landinglightingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landinglightingDescription = description;
                        });
                        _savePreference(propertyId, 'landinglightingDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landinglightingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landinglightingImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
              // Walls
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'ladingwallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final ladingwallsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Walls",
                        condition: landingwallsCondition,
                        description: landingwallsDescription,
                        images: ladingwallsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingwallsCondition = condition;
                        });
                        _savePreference(propertyId, 'landingwallsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingwallsDescription = description;
                        });
                        _savePreference(propertyId, 'landingwallsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'ladingwallsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('ladingwallsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Skirting
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingskirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingskirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Skirting",
                        condition: landingskirtingCondition,
                        description: landingskirtingDescription,
                        images: landingskirtingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingskirtingCondition = condition;
                        });
                        _savePreference(propertyId, 'landingskirtingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingskirtingDescription = description;
                        });
                        _savePreference(propertyId, 'landingskirtingDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingskirtingImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingskirtingImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Window Sill
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingwindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingwindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Window Sill",
                        condition: landingwindowSillCondition,
                        description: landingwindowSillDescription,
                        images: landingwindowSillImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingwindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'landingwindowSillCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingwindowSillDescription = description;
                        });
                        _savePreference(propertyId, 'landingwindowSillDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingwindowSillImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingwindowSillImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Curtains
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingcurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingcurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Curtains",
                        condition: landingcurtainsCondition,
                        description: landingcurtainsDescription,
                        images: landingcurtainsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingcurtainsCondition = condition;
                        });
                        _savePreference(propertyId, 'landingcurtainsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingcurtainsDescription = description;
                        });
                        _savePreference(propertyId, 'landingcurtainsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingcurtainsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingcurtainsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Blinds
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingblindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingblindsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Blinds",
                        condition: landingblindsCondition,
                        description: landingblindsDescription,
                        images: landingblindsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingblindsCondition = condition;
                        });
                        _savePreference(propertyId, 'landingblindsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingblindsDescription = description;
                        });
                        _savePreference(propertyId, 'landingblindsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingblindsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingblindsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
              // Light Switches
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landinglightSwitchesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landinglightSwitchesImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Light Switches",
                        condition: landinglightSwitchesCondition,
                        description: landinglightSwitchesDescription,
                        images: landinglightSwitchesImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landinglightSwitchesCondition = condition;
                        });
                        _savePreference(propertyId, 'landinglightSwitchesCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landinglightSwitchesDescription = description;
                        });
                        _savePreference(propertyId, 'landinglightSwitchesDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landinglightSwitchesImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landinglightSwitchesImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Sockets
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingsocketsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingsocketsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Sockets",
                        condition: landingsocketsCondition,
                        description: landingsocketsDescription,
                        images: landingsocketsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingsocketsCondition = condition;
                        });
                        _savePreference(propertyId, 'landingsocketsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingsocketsDescription = description;
                        });
                        _savePreference(propertyId, 'landingsocketsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingsocketsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingsocketsImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Flooring
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingflooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingflooringImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Flooring",
                        condition: landingflooringCondition,
                        description: landingflooringDescription,
                        images: landingflooringImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingflooringCondition = condition;
                        });
                        _savePreference(propertyId, 'landingflooringCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingflooringDescription = description;
                        });
                        _savePreference(propertyId, 'landingflooringDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingflooringImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingflooringImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Additional Items
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'landingadditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final landingadditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Additional Items",
                        condition: landingadditionalItemsCondition,
                        description: landingadditionalItemsDescription,
                        images: landingadditionalItemsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          landingadditionalItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'landingadditionalItemsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          landingadditionalItemsDescription = description;
                        });
                        _savePreference(propertyId, 'landingadditionalItemsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'landing', 'landingadditionalItemsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('landing')
                                .doc('landingadditionalItemsImages')
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
