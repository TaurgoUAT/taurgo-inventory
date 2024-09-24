import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class UtilityRoom extends StatefulWidget {
  final List<File>? utilityCapturedImages;
  final String propertyId;

  const UtilityRoom({
    Key? key,
    this.utilityCapturedImages,
    required this.propertyId,
  }) : super(key: key);

  @override
  State<UtilityRoom> createState() => _UtilityRoomState();
}

class _UtilityRoomState extends State<UtilityRoom> {
  // Variables for Door
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

  List<String> utilityDoorImages = [];

  late List<File> utilityCapturedImages;

  @override
  void initState() {
    super.initState();
    utilityCapturedImages = widget.utilityCapturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Optionally, load saved preferences here
  }

  // Fetch images from Firestore
  Stream<List<String>> _getImagesFromFirestore(String propertyId, String imageType) {
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

  // Function to save a preference
  Future<void> _savePreference(String propertyId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${key}_$propertyId', value);
  }

  // Handle Image Added
  Future<void> _handleImageAdded(XFile imageFile, String documentId) async {
    String propertyId = widget.propertyId;
    String? downloadUrl = await uploadImageToFirebase(
      imageFile,
      propertyId,
      'utility_room',
      documentId,
    );

    if (downloadUrl != null) {
      print("Image uploaded and URL added to Firestore: $downloadUrl");
      // The image URL is already added to Firestore within uploadImageToFirebase
      // No need to manually update the images list here
      setState(() {
        // Trigger UI update if necessary
      });
    }
  }

  // Upload Image to Firebase
  Future<String?> uploadImageToFirebase(
    XFile imageFile,
    String propertyId,
    String collectionName,
    String documentId,
  ) async {
    try {
      // Step 1: Upload the image to Firebase Storage
      String fileName = '${documentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$propertyId/$collectionName/$documentId/$fileName');

      UploadTask uploadTask = storageReference.putFile(File(imageFile.path));
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

  // Dialogs for Exit and Save
  void _showExitDialog(BuildContext context) {
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
            'You may lose your data if you exit the process without saving',
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
                    builder: (context) => EditReportPage(propertyId: widget.propertyId),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }

  void _showSaveDialog(BuildContext context) {
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
            'Please make sure you have added all the necessary information',
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
                    builder: (context) => EditReportPage(propertyId: widget.propertyId),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;

    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
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
              _showExitDialog(context);
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
                _showSaveDialog(context);
              },
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14,
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
                // Door Condition Item
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitydoorImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Door images');
                    }
                    final utilityDoorImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door",
                      condition: utilityDoorCondition,
                      description: utilityDoorDescription,
                      images: utilityDoorImages,
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
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitydoorImages');
                      },
                    );
                  },
                ),
                // Door Frame 
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitydoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Door Frame images');
                    }
                    final utilityDoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door Frame",
                      condition: utilityDoorFrameCondition,
                      description: utilityDoorFrameDescription,
                      images: utilityDoorFrameImages,
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
                        _savePreference(
                            propertyId, 'utilityDoorFrameDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitydoorFrameImages');
                      },
                    );
                  },
                ),
                // Ceiling
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityceilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Ceiling images');
                    }
                    final utilityCeilingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Ceiling",
                      condition: utilityCeilingCondition,
                      description: utilityCeilingDescription,
                      images: utilityCeilingImages,
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
                        _savePreference(
                            propertyId, 'utilityCeilingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilityceilingImages');
                      },
                    );
                  },
                ),
                // Lighting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitylightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Lighting images');
                    }
                    final utilityLightingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Lighting",
                      condition: utilityLightingCondition,
                      description: utilitylightingDescription,
                      images: utilityLightingImages,
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
                        _savePreference(
                            propertyId, 'utilitylightingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitylightingImages');
                      },
                    );
                  },
                ),
                // Walls
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitywallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Walls images');
                    }
                    final utilityWallsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Walls",
                      condition: utilitywallsCondition,
                      description: utilitywallsDescription,
                      images: utilityWallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          utilitywallsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'utilitywallsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          utilitywallsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'utilitywallsDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitywallsImages');
                      },
                    );
                  },
                ),
                // Skirting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityskirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Skirting images');
                    }
                    final utilitySkirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Skirting",
                      condition: utilityskirtingCondition,
                      description: utilityskirtingDescription,
                      images: utilitySkirtingImages,
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
                            propertyId, 'utilityskirtingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilityskirtingImages');
                      },
                    );
                  },
                ),
                // Window Sill
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitywindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Window Sill images');
                    }
                    final utilityWindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Window Sill",
                      condition: utilitywindowSillCondition,
                      description: utilitywindowSillDescription,
                      images: utilityWindowSillImages,
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
                            propertyId, 'utilitywindowSillDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitywindowSillImages');
                      },
                    );
                  },
                ),
                // Curtains
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitycurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Curtains images');
                    }
                    final utilityCurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Curtains",
                      condition: utilitycurtainsCondition,
                      description: utilitycurtainsDescription,
                      images: utilityCurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          utilitycurtainsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'utilitycurtainsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          utilitycurtainsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'utilitycurtainsDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitycurtainsImages');
                      },
                    );
                  },
                ),
                // Blinds
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityblindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Blinds images');
                    }
                    final utilityBlindsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Blinds",
                      condition: utilityblindsCondition,
                      description: utilityblindsDescription,
                      images: utilityBlindsImages,
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
                            propertyId, 'utilityblindsDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilityblindsImages');
                      },
                    );
                  },
                ),
                // Light Switches
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitylightSwitchesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Light Switches images');
                    }
                    final utilityLightSwitchesImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Light Switches",
                      condition: utilitylightSwitchesCondition,
                      description: utilitylightSwitchesDescription,
                      images: utilityLightSwitchesImages,
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
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitylightSwitchesImages');
                      },
                    );
                  },
                ),
                // Sockets
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilitysocketsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Sockets images');
                    }
                    final utilitySocketsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Sockets",
                      condition: utilitysocketsCondition,
                      description: utilitysocketsDescription,
                      images: utilitySocketsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          utilitysocketsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'utilitysocketsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          utilitysocketsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'utilitysocketsDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilitysocketsImages');
                      },
                    );
                  },
                ),
                // Flooring
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityflooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Flooring images');
                    }
                    final utilityFlooringImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Flooring",
                      condition: utilityflooringCondition,
                      description: utilityflooringDescription,
                      images: utilityFlooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          utilityflooringCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'utilityflooringCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          utilityflooringDescription = description;
                        });
                        _savePreference(
                            propertyId, 'utilityflooringDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilityflooringImages');
                      },
                    );
                  },
                ),
                // Additional Items
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'utilityadditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Additional Items images');
                    }
                    final utilityAdditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Additional Items",
                      condition: utilityadditionalItemsCondition,
                      description: utilityadditionalItemsDescription,
                      images: utilityAdditionalItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          utilityadditionalItemsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'utilityadditionalItemsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          utilityadditionalItemsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'utilityadditionalItemsDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'utilityadditionalItemsImages');
                      },
                    );
                  },
                ),

                // Add more ConditionItem widgets as needed for other utility room components
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Refactored ConditionItem Widget
class ConditionItem extends StatelessWidget {
  final String name;
  final String? condition;
  final String? description;
  final List<String> images;
  final Function(String?) onConditionSelected;
  final Function(String?) onDescriptionSelected;
  final Function(XFile) onImageAdded;

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

  // Function to pick images from the gallery
  Future<List<XFile>?> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage(
        imageQuality: 80, // Adjust the quality as needed
      );
      return selectedImages;
    } catch (e) {
      print("Error picking images: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component Type and Action Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Component Type Column
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
              // Action Icons Row
              Row(
                children: [
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
                                onImageAdded(XFile(imagePath));
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.photo_library_outlined,
                      size: 24,
                      color: kSecondaryTextColourTwo,
                    ),
                    onPressed: () async {
                      final List<XFile>? selectedImages = await _pickImages();
                      if (selectedImages != null && selectedImages.isNotEmpty) {
                        for (var image in selectedImages) {
                          onImageAdded(image);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          // Condition Section
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
          SizedBox(height: 12),
          // Description Section
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
          SizedBox(height: 12),
          // Images Section
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