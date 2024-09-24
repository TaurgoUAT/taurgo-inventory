import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class EntranceHallway extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const EntranceHallway({super.key, this.capturedImages, required this.propertyId});

  @override
  State<EntranceHallway> createState() => _EntranceHallwayState();
}


  

class _EntranceHallwayState extends State<EntranceHallway> {
  String? entranceDoorCondition;
  String? entranceDoorLocation;
  String? entranceDoorFrameCondition;
  String? entranceDoorFrameLocation;
 String? entranceDoorBellCondition;
  String? entranceCeilingCondition;
  String? entranceCeilingLocation;
  String? entranceLightingCondition;
  String? entranceLightingLocation;
  String? entranceWallsCondition;
  String? entranceWallsLocation;
  String? entranceSkirtingCondition;
  String? entranceSkirtingLocation;
  String? entranceWindowSillCondition;
  String? entranceWindowSillLocation;
  String? entranceCurtainsCondition;
  String? entranceCurtainsLocation;
  String? entranceBlindsCondition;
  String? entranceBlindsLocation;
  String? entranceHeatingCondition;
  String? entranceLightSwitchesCondition;
  String? entranceLightSwitchesLocation;
  String? entranceSocketsCondition;
  String? entranceSocketsLocation;
  String? entranceFlooringCondition;
  String? entranceFlooringLocation;
  String? entranceAdditionalItemsCondition;
  String? entranceAdditionalItemsLocation;
  // String? entranceDoorImagePaths;
  // String? doorFrameImagePaths;
  // String? ceilingImagePaths;
  // String? lightingImagePaths;
  // String? wallsImagePaths;
  // String? skirtingImagePaths;
  // String? windowSillImagePaths;
  // String? curtainsImagePaths;
  // String? blindsImagePaths;
  // String? lightSwitchesImagePaths;
  // String? socketsImagePaths;
  // String? flooringImagePaths;
  // String? additionalItemsImagePaths;

  List<String> entranceDoorImages = [];
  List<String> entranceDoorFrameImages = [];
    List<String> entranceDoorBellImages = [];
  List<String> entranceCeilingImages = [];
  List<String> entranceLightingImages = [];
  List<String> entranceWallsImages = [];
  List<String> entranceSkirtingImages = [];
  List<String> entranceWindowSillImages = [];
  List<String> entranceCurtainsImages = [];
  List<String> entranceBlindsImages = [];
  List<String> entranceLightSwitchesImages = [];
  List<String> entranceSocketsImages = [];
  List<String> entranceFlooringImages = [];
   List<String> entranceHeatingImages = [];
  List<String> entranceAdditionalItemsImages = [];
  late List<File> capturedImages;

   @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<String?> uploadImageToFirebase(XFile imageFile, String propertyId,
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

  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('entranceHallway')
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

  Future<void> _handleImageAdded(XFile imageFile, String documentId) async {
    String propertyId = widget.propertyId;
    String? downloadUrl = await uploadImageToFirebase(
        imageFile, propertyId, 'entranceHallway', documentId);

    if (downloadUrl != null) {
      print("Adding image URL to Firestore: $downloadUrl");
      // The image URL has already been added inside uploadImageToFirebase
    }
  }

  // Function to save a preference
 Future<void> _savePreference(String propertyId, String key, String value)
  async {
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
          'Entrance Hallway',
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
                  stream: _getImagesFromFirestore(propertyId, 'entranceDoorImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceDoorImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Door",
                        condition: entranceDoorCondition,
                        description: entranceDoorCondition,
                        images: entranceDoorImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceDoorCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceDoorCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceDoorCondition = description;
                        });
                        _savePreference(propertyId, 'entranceDoorCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceDoorImages');
                      });
                  },
                ),

              // Door Frame
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceDoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceDoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Door Frame",
                        condition: entranceDoorFrameCondition,
                        description: entranceDoorFrameCondition,
                        images: entranceDoorFrameImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceDoorFrameCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceDoorFrameCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceDoorFrameCondition = description;
                        });
                        _savePreference(propertyId, 'entranceDoorFrameCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceDoorFrameImages');
                      });
                  },
                ),

              // Ceiling
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceCeilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceCeilingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Ceiling",
                        condition: entranceCeilingCondition,
                        description: entranceCeilingCondition,
                        images: entranceCeilingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceCeilingCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceCeilingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceCeilingCondition = description;
                        });
                        _savePreference(propertyId, 'entranceCeilingCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceCeilingImages');
                      });
                  },
                ),


                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceDoorBellImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceDoorBellImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Door Bell",
                        condition: entranceDoorBellCondition,
                        description: entranceDoorBellCondition,
                        images: entranceDoorBellImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceDoorBellCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceDoorBellCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceDoorBellCondition = description;
                        });
                        _savePreference(propertyId, 'entranceDoorBellCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceDoorBellImages');
                      });
                  },
                ),


              // Lighting
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceLightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceLightingImages= snapshot.data ?? [];
                    return ConditionItem(
                        name: "Lighting",
                        condition: entranceLightingCondition,
                        description: entranceLightingCondition,
                        images: entranceLightingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceLightingCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceLightingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceLightingCondition = description;
                        });
                        _savePreference(propertyId, 'entranceLightingCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceLightingImages');
                      });
                  },
                ),

              // Walls
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceWallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceWallsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Walls",
                        condition: entranceWallsCondition,
                        description: entranceWallsCondition,
                        images: entranceWallsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceWallsCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceWallsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceWallsCondition = description;
                        });
                        _savePreference(propertyId, 'entranceWallsCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceWallsImages');
                      });
                  },
                ),

              // Skirting
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceSkirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceSkirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Skirting",
                        condition: entranceSkirtingCondition,
                        description: entranceSkirtingCondition,
                        images: entranceSkirtingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceSkirtingCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceSkirtingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceSkirtingCondition = description;
                        });
                        _savePreference(propertyId, 'entranceSkirtingCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceSkirtingImages');
                      });
                  },
                ),

              // Window Sill
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceWindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceWindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Window Sill",
                        condition: entranceWindowSillCondition,
                        description: entranceWindowSillCondition,
                        images: entranceWindowSillImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceWindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceWindowSillCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceWindowSillCondition = description;
                        });
                        _savePreference(propertyId, 'entranceWindowSillCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceWindowSillImages');
                      });
                  },
                ),

              // Curtains
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceCurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceCurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Curtains",
                        condition: entranceCurtainsCondition,
                        description: entranceCurtainsCondition,
                        images: entranceCurtainsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceCurtainsCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceCurtainsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceCurtainsCondition = description;
                        });
                        _savePreference(propertyId, 'entranceCurtainsCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceCurtainsImages');
                      });
                  },
                ),

              // Blinds
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceBlindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceBlindsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Blinds",
                        condition: entranceBlindsCondition,
                        description: entranceBlindsCondition,
                        images: entranceBlindsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceBlindsCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceBlindsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceBlindsCondition = description;
                        });
                        _savePreference(propertyId, 'entranceBlindsCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceBlindsImages');
                      });
                  },
                ),

              // Light Switches
             StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceLightSwitchesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceLightSwitchesImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Light Switches",
                        condition: entranceLightSwitchesCondition,
                        description: entranceLightSwitchesCondition,
                        images: entranceLightSwitchesImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceLightSwitchesCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceLightSwitchesCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceLightSwitchesCondition = description;
                        });
                        _savePreference(propertyId, 'entranceLightSwitchesCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceLightSwitchesImages');
                      });
                  },
                ),

              // Sockets
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceSocketsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceSocketsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Socket",
                        condition: entranceSocketsCondition,
                        description: entranceSocketsCondition,
                        images: entranceSocketsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceSocketsCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceSocketsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceSocketsCondition = description;
                        });
                        _savePreference(propertyId, 'entranceSocketsCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceSocketsImages');
                      });
                  },
                ),
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceHeatingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceHeatingImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Heating",
                        condition: entranceHeatingCondition,
                        description: entranceHeatingCondition,
                        images: entranceHeatingImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceHeatingCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceHeatingCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceHeatingCondition = description;
                        });
                        _savePreference(propertyId, 'entranceHeatingCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceHeatingImages');
                      });
                  },
                ),
              // Flooring
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceFlooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceFlooringImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Flooring",
                        condition: entranceFlooringCondition,
                        description: entranceFlooringCondition,
                        images: entranceFlooringImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceFlooringCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceFlooringCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceFlooringCondition = description;
                        });
                        _savePreference(propertyId, 'entranceFlooringCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceFlooringImages');
                      });
                  },
                ),

              // Additional Items
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'entranceAdditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final entranceAdditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Additional Items",
                        condition: entranceAdditionalItemsCondition,
                        description: entranceAdditionalItemsCondition,
                        images: entranceAdditionalItemsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          entranceAdditionalItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'entranceAdditionalItemsCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          entranceAdditionalItemsCondition = description;
                        });
                        _savePreference(propertyId, 'entranceAdditionalItemsCondition', description!);
                      },
                        onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'entranceAdditionalItemsImages');
                      });
                  },
                ),
            ],
          ),
        ),
      ),
    ),);
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
        imageQuality: 80, // Adjust the quality as needed
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
          //           initialCondition: location,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onLocationSelected(result);
          //     }
          //   },
          //   child: Text(
          //     location?.isNotEmpty == true ? location! : "Location",
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
