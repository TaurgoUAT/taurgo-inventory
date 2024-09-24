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

class Bedroom extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Bedroom({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Bedroom> createState() => _BedroomState();
}

class _BedroomState extends State<Bedroom> {
  String? bedRoomDoorLocation;
  String? bedRoomDoorCondition;
  String? bedRoomDoorFrameLocation;
  String? bedRoomDoorFrameCondition;
  String? bedRoomCeilingLocation;
  String? bedRoomCeilingCondition;
  String? bedRoomLightingLocation;
  String? bedRoomLightingCondition;
  String? bedRoomWallsLocation;
  String? bedRoomWallsCondition;
  String? bedRoomSkirtingLocation;
  String? bedRoomsSkirtingCondition;
  String? bedRoomWindowSillLocation;
  String? bedRoomWindowSillCondition;
  String? bedRoomCurtainsLocation;
  String? bedRoomCurtainsCondition;
  String? bedRoomBlindsLocation;
  String? bedRoomBlindsCondition;
  String? bedRoomLightSwitchesLocation;
  String? bedRoomLightSwitchesCondition;
  String? bedRoomSocketsLocation;
  String? bedRoomSocketsCondition;
  String? bedRoomFlooringLocation;
  String? bedRoomFlooringCondition;
  String? bedRoomAdditionalItemsLocation;
  String? bedRoomAdditionalItemsCondition;

 
  List<String> bedRoomDoorImages = [];
  List<String> bedRoomDoorFrameImages = [];
  List<String> bedRoomCeilingImages = [];
  List<String> bedRoomlLightingImages = [];
  List<String> bedRoomwWallsImages = [];
  List<String> bedRoomSkirtingImages = [];
  List<String> bedRoomWindowSillImages = [];
  List<String> bedRoomCurtainsImages = [];
  List<String> bedRoomBlindsImages = [];
  List<String> bedRoomLightSwitchesImages = [];
  List<String> bedRoomSocketsImages = [];
  List<String> bedRoomFlooringImages = [];
  List<String> bedRoomAdditionalItemsImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

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
        .collection('bedroom')
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
        imageFile, propertyId, 'bedroom', documentId);

    if (downloadUrl != null) {
      print("Adding image URL to Firestore: $downloadUrl");
      // The image URL has already been added inside uploadImageToFirebase
    }
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
            'Bed Room',
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
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomDoorImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomDoorImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door",
                      condition: bedRoomDoorCondition,
                      description: bedRoomDoorLocation,
                      images: bedRoomDoorImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomDoorCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomDoorCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomDoorLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomDoorLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomDoorImages');
                      }
                    );
                  },
                ),

                // Door Frame
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomDoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomDoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door Frame",
                      condition: bedRoomDoorFrameCondition,
                      description: bedRoomDoorFrameLocation,
                      images: bedRoomDoorFrameImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomDoorFrameCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomDoorFrameCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomDoorFrameLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomDoorFrameLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomDoorFrameImages');
                      }
                    );
                  },
                ),

                // Ceiling
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomCeilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomCeilingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Ceiling",
                      condition: bedRoomCeilingCondition,
                      description: bedRoomCeilingLocation,
                      images: bedRoomCeilingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomCeilingCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomCeilingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomCeilingLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomCeilingLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomCeilingImages');
                      }
                    );
                  },
                ),

                // Lighting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomlLightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomlLightingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Lighting",
                      condition: bedRoomLightingCondition,
                      description: bedRoomLightingLocation,
                      images: bedRoomlLightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomLightingCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomLightingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomLightingLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomLightingLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomlLightingImages');
                      }
                    );
                  },
                ),

                // Walls
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomwWallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomwWallsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Walls",
                      condition: bedRoomWallsCondition,
                      description: bedRoomWallsLocation,
                      images: bedRoomwWallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomWallsCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomWallsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomWallsLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomWallsLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomwWallsImages');
                      }
                    );
                  },
                ),

                // Skirting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomSkirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomSkirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Skirting",
                      condition: bedRoomsSkirtingCondition,
                      description: bedRoomSkirtingLocation,
                      images: bedRoomSkirtingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomsSkirtingCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomsSkirtingCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomSkirtingLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomSkirtingLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomSkirtingImages');
                      }
                    );
                  },
                ),

                // Window Sill
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomWindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomWindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Window Sill",
                      condition: bedRoomWindowSillCondition,
                      description: bedRoomWindowSillLocation,
                      images: bedRoomWindowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomWindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomWindowSillCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomWindowSillLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomWindowSillLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomWindowSillImages');
                      }
                    );
                  },
                ),

                // Curtains
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomCurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomCurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Curtains",
                      condition: bedRoomCurtainsCondition,
                      description: bedRoomCurtainsLocation,
                      images: bedRoomCurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomCurtainsCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomCurtainsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomCurtainsLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomCurtainsLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomCurtainsImages');
                      }
                    );
                  },
                ),

                // Blinds
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomBlindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomBlindsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Blinds",
                      condition: bedRoomBlindsCondition,
                      description: bedRoomBlindsLocation,
                      images: bedRoomBlindsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomBlindsCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomBlindsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomBlindsLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomBlindsLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomBlindsImages');
                      }
                    );
                  },
                ),

                // Light Switches
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomLightSwitchesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomLightSwitchesImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Light Switches",
                      condition: bedRoomLightSwitchesCondition,
                      description: bedRoomLightSwitchesLocation,
                      images: bedRoomLightSwitchesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomLightSwitchesCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomLightSwitchesCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomLightSwitchesLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomLightSwitchesLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomLightSwitchesImages');
                      }
                    );
                  },
                ),

                // Sockets
               StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomSocketsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomSocketsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Sockets",
                      condition: bedRoomSocketsCondition,
                      description: bedRoomSocketsLocation,
                      images: bedRoomSocketsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomSocketsCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomSocketsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomSocketsLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomSocketsLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomSocketsImages');
                      }
                    );
                  },
                ),
                // Flooring
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomFlooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomFlooringImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Flooring",
                      condition: bedRoomFlooringCondition,
                      description: bedRoomFlooringLocation,
                      images: bedRoomFlooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomFlooringCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomFlooringCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomFlooringLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomFlooringLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomFlooringImages');
                      }
                    );
                  },
                ),

                // Additional Items
               StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'bedRoomAdditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mortice images');
                    }
                    final bedRoomAdditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: " Additional Items",
                      condition: bedRoomAdditionalItemsCondition,
                      description: bedRoomAdditionalItemsLocation,
                      images: bedRoomAdditionalItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          bedRoomAdditionalItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'bedRoomAdditionalItemsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          bedRoomAdditionalItemsLocation = description;
                        });
                        _savePreference(propertyId, 'bedRoomAdditionalItemsLocation', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'bedRoomAdditionalItemsImages');
                      }
                    );
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
  final String? location;
  final String? condition;
  final String? description;
  final List<String> images;
 
  final Function(String?) onConditionSelected;
  final Function(String?) onDescriptionSelected;
  final Function(XFile) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
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
          // SizedBox(
          //   height: 12,
          // ),
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
          //       onlocationSelected(result);
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
