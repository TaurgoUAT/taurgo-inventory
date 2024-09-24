import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
// import '../../widgets/add_action.dart';  // Not used in this context

class Stairs extends StatefulWidget {
  final List<File>? stairscapturedImages;
  final String propertyId;
  const Stairs(
      {super.key, this.stairscapturedImages, required this.propertyId});

  @override
  State<Stairs> createState() => _StairsState();
}

class _StairsState extends State<Stairs> {
  String? stairsdoorCondition;
  String? stairsdoorDescription;
  String? stairsdoorFrameCondition;
  String? stairsdoorFrameDescription;
  String? stairsceilingCondition;
  String? stairsceilingDescription;
  String? stairslightingCondition;
  String? stairslightingDescription;
  String? stairswallsCondition;
  String? stairswallsDescription;
  String? stairsskirtingCondition;
  String? stairsskirtingDescription;
  String? stairswindowSillCondition;
  String? stairswindowSillDescription;
  String? stairscurtainsCondition;
  String? stairscurtainsDescription;
  String? stairsblindsCondition;
  String? stairsblindsDescription;
  String? stairslightSwitchesCondition;
  String? stairslightSwitchesDescription;
  String? stairssocketsCondition;
  String? stairssocketsDescription;
  String? stairsflooringCondition;
  String? stairsflooringDescription;
  String? stairsadditionalItemsCondition;
  String? stairsadditionalItemsDescription;
  List<String> stairsdoorImages = [];
  List<String> stairsdoorFrameImages = [];
  List<String> stairsceilingImages = [];
  List<String> stairslightingImages = [];
  List<String> stairswallsImages = [];
  List<String> stairsskirtingImages = [];
  List<String> stairswindowSillImages = [];
  List<String> stairscurtainsImages = [];
  List<String> stairsblindsImages = [];
  List<String> stairslightSwitchesImages = [];
  List<String> stairssocketsImages = [];
  List<String> stairsflooringImages = [];
  List<String> stairsadditionalItemsImages = [];


  @override
  void initState() {
    super.initState();
    print("Property Id - SOC${widget.propertyId}");
  }

  // Fetch images from Firestore
  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('stairs')
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

  Future<void> _handleImageAdded(XFile imageFile, String documentId) async {
    String propertyId = widget.propertyId;
    String? downloadUrl = await _uploadImageToFirebase(
        imageFile, propertyId, 'stairs', documentId);

    if (downloadUrl != null) {
      print("Image uploaded and URL saved to Firestore: $downloadUrl");
      setState(() {
        // Update UI if necessary
      });
    }
  }

  Future<String?> _uploadImageToFirebase(XFile imageFile, String propertyId,
      String collectionName, String documentId) async {
    try {
      // Step 1: Upload the image to Firebase Storage
      String fileName =
          '${documentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$propertyId/$collectionName/$documentId/$fileName');

      UploadTask uploadTask = storageReference.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;

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

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Stairs',
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
                // Ceiling
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsdoorImages '),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Door images');
                    }
                    final stairsdoorImages   = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door",
                      condition: stairsdoorCondition,
                      description: stairsdoorDescription,
                      images: stairsdoorImages  ,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsdoorCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairsdoorCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsdoorDescription = description;
                        });
                        _savePreference(
                            propertyId, 'stairsdoorDescription,', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsdoorImages');
                      },
                    );
                  },
                ),
                // Door Frame
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsdoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Door Frame images');
                    }
                    final stairsdoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door Frame",
                      condition: stairsdoorFrameCondition,
                      description: stairsdoorFrameDescription,
                      images: stairsdoorFrameImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsdoorFrameCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairsdoorFrameCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsdoorFrameDescription = description;
                        });
                        _savePreference(propertyId, 'stairsdoorFrameDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsdoorFrameImages');
                      },
                    );
                  },
                ),
                // Ceiling
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsceilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Ceiling images');
                    }
                    final stairsceilingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Ceiling",
                      condition: stairsceilingCondition,
                      description: stairsceilingDescription,
                      images: stairsceilingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsceilingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairsceilingCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsceilingDescription = description;
                        });
                        _savePreference(propertyId, 'stairsceilingDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsceilingImages');
                      },
                    );
                  },
                ),
                // Lighting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairslightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Lighting images');
                    }
                    final stairslightingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Lighting",
                      condition: stairslightingCondition,
                      description: stairslightingDescription,
                      images: stairslightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairslightingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairslightingCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairslightingDescription = description;
                        });
                        _savePreference(propertyId, 'stairslightingDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairslightingImages');
                      },
                    );
                  },
                ),
                // Walls
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairswallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Walls images');
                    }
                    final stairswallsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Walls",
                      condition: stairswallsCondition,
                      description: stairswallsDescription,
                      images: stairswallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairswallsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairswallsCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairswallsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'stairswallsDescription,', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairswallsImages');
                      },
                    );
                  },
                ),
                // Skirting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsskirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Skirting images');
                    }
                    final stairsskirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Skirting",
                      condition: stairsskirtingCondition,
                      description: stairsskirtingDescription,
                      images: stairsskirtingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsskirtingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairsskirtingCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsskirtingDescription = description;
                        });
                        _savePreference(propertyId, 'stairsskirtingDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsskirtingImages');
                      },
                    );
                  },
                ),
                // Window Sill
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairswindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Window Sill images');
                    }
                    final stairswindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Window Sill",
                      condition: stairswindowSillCondition,
                      description: stairswindowSillDescription,
                      images: stairswindowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairswindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'stairswindowSillCondition,',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairswindowSillDescription = description;
                        });
                        _savePreference(propertyId, 'stairswindowSillDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairswindowSillImages');
                      },
                    );
                  },
                ),
                // Curtains
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairscurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Curtains images');
                    }
                    final stairscurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Curtains",
                      condition: stairscurtainsCondition,
                      description: stairscurtainsDescription,
                      images: stairscurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairscurtainsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairscurtainsCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairscurtainsDescription = description;
                        });
                        _savePreference(propertyId, 'stairscurtainsDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairscurtainsImages');
                      },
                    );
                  },
                ),
                // Blinds
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsblindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Blinds images');
                    }
                    final stairsblindsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Blinds",
                      condition: stairsblindsCondition,
                      description: stairsblindsDescription,
                      images: stairsblindsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsblindsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairsblindsCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsblindsDescription = description;
                        });
                        _savePreference(propertyId, 'stairsblindsDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsblindsImages');
                      },
                    );
                  },
                ),
                // Light Switches
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairslightSwitchesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Light Switches images');
                    }
                    final stairslightSwitchesImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Light Switches",
                      condition: stairslightSwitchesCondition,
                      description: stairslightSwitchesDescription,
                      images: stairslightSwitchesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairslightSwitchesCondition = condition;
                        });
                        _savePreference(propertyId, 'stairslightSwitchesCondition,',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairslightSwitchesDescription = description;
                        });
                        _savePreference(propertyId, 'stairslightSwitchesDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairslightSwitchesImages');
                      },
                    );
                  },
                ),
                // Sockets
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairssocketsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Sockets images');
                    }
                    final stairssocketsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Sockets",
                      condition: stairssocketsCondition,
                      description: stairssocketsDescription,
                      images: stairssocketsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairssocketsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairssocketsCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairssocketsDescription = description;
                        });
                        _savePreference(propertyId, 'stairssocketsDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairssocketsImages');
                      },
                    );
                  },
                ),
                // Flooring
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsflooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Flooring images');
                    }
                    final stairsflooringImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Flooring",
                      condition: stairsflooringCondition,
                      description: stairsflooringDescription,
                      images: stairsflooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsflooringCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'stairsflooringCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsflooringDescription = description;
                        });
                        _savePreference(propertyId, 'stairsflooringDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsflooringImages');
                      },
                    );
                  },
                ),
                // Additional Items
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'stairsadditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Additional Items images');
                    }
                    final stairsadditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Additional Items",
                      condition: stairsadditionalItemsCondition,
                      description: stairsadditionalItemsDescription,
                      images: stairsadditionalItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          stairsadditionalItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'stairsadditionalItemsCondition,',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          stairsadditionalItemsDescription = description;
                        });
                        _savePreference(propertyId, 'stairsadditionalItemsDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'stairsadditionalItemsImages');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to show exit dialog
  void _showExitDialog(BuildContext context) {
    // Your existing exit dialog code
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Your existing exit dialog code
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
                      builder: (context) =>
                          EditReportPage(propertyId: widget.propertyId)),
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
  }

  // Method to show save dialog
  void _showSaveDialog(BuildContext context) {
    // Your existing save dialog code
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Your existing save dialog code
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
                      builder: (context) =>
                          EditReportPage(propertyId: widget.propertyId)),
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
  }
}

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

  Future<List<XFile>?> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        imageQuality: 80, // Adjust as needed
      );
      return images;
    } catch (e) {
      print("Error picking images: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ... your existing padding and layout code
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type and Action Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Type Column
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
                      if (selectedImages != null &&
                          selectedImages.isNotEmpty) {
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
          SizedBox(
            height: 12,
          ),
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
          SizedBox(
            height: 12,
          ),
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