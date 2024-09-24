import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

import '../../constants/AppColors.dart';

class Toilet extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Toilet({Key? key, this.capturedImages, required this.propertyId})
      : super(key: key);

  @override
  State<Toilet> createState() => _ToiletState();
}

class _ToiletState extends State<Toilet> {
  String? doorCondition;
  String? doorDescription;
  String? toiletDoorCondition;
  String? toiletDoorDescription;
  String? toiletDoorFrameCondition;
  String? toiletDoorFrameDescription;
  String? toiletCeilingCondition;
  String? toiletCeilingDescription;
  String? toiletExtractorFanCondition;
  String? toiletExtractorFanDescription;
  String? toiletLightingCondition;
  String? toiletLightingDescription;
  String? toiletWallsCondition;
  String? toiletWallsDescription;
  String? toiletSkirtingCondition;
  String? toiletSkirtingDescription;
  String? toiletWindowSillCondition;
  String? toiletwWindowSillDescription;
  String? toiletCurtainsCondition;
  String? toiletCurtainsDescription;
  String? toiletBlindsCondition;
  String? toiletBlindsDescription;
  String? toiletToiletCondition;
  String? toiletToiletDescription;
  String? toiletBasinCondition;
  String? toiletBasinDescription;
  String? toiletShowerCubicleCondition;
  String? toiletShowerCubicleDescription;
  String? toiletBathCondition;
  String? toiletBathDescription;
  String? toiletSwitchBoardCondition;
  String? toiletSwitchBoardDescription;
  String? toiletSocketCondition;
  String? toiletSocketDescription;
  String? toiletHeatingCondition;
  String? toiletHeatingDescription;
  String? toiletAccessoriesCondition;
  String? toiletAccessoriesDescription;
  String? toiletFlooringCondition;
  String? toiletFlooringDescription;
  String? toiletAdditionalItemsCondition;
  String? toiletAdditionalItemsDescription;
  List<String> toiletDoorImages = [];
  List<String> toiletDoorFrameImages = [];
  List<String> toiletCeilingImages = [];
  List<String> toiletExtractorFanImages = [];
  List<String> toiletlLightingImages = [];
  List<String> toiletWallsImages = [];
  List<String> toiletSkirtingImages = [];
  List<String> toiletWindowSillImages = [];
  List<String> toiletCurtainsImages = [];
  List<String> toiletBlindsImages = [];
  List<String> toiletToiletImages = [];
  List<String> toiletBasinImages = [];
  List<String> toiletShowerCubicleImages = [];
  List<String> toiletBathImages = [];
  List<String> toiletSwitchBoardImages = [];
  List<String> toiletSocketImages = [];
  List<String> toiletHeatingImages = [];
  List<String> toiletAccessoriesImages = [];
  List<String> toiletFlooringImages = [];
  List<String> toiletAdditionalItemsImages = [];

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
        .collection('toilet')
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
        imageFile, propertyId, 'toilet', documentId);

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
            'Toilet',
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
                // Door
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletDoorImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Door images');
                    }
                    final toiletDoorImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door",
                      condition: toiletDoorCondition,
                      description: toiletDoorDescription,
                      images: toiletDoorImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletDoorCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'toiletDoorCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletDoorDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletDoorDescription,', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletDoorImages');
                      },
                    );
                  },
                ),
                // Door Frame
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletDoorFrameImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Door Frame images');
                    }
                    final toiletDoorFrameImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Door Frame",
                      condition: toiletDoorFrameCondition,
                      description: toiletDoorFrameDescription,
                      images: toiletDoorFrameImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletDoorFrameCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletDoorFrameCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletDoorFrameDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletDoorFrameDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletDoorFrameImages');
                      },
                    );
                  },
                ),
                // Ceiling
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletCeilingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Ceiling images');
                    }
                    final toiletCeilingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Ceiling",
                      condition: toiletCeilingCondition,
                      description: toiletCeilingDescription,
                      images: toiletCeilingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletCeilingCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletCeilingCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletCeilingDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletCeilingDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletCeilingImages');
                      },
                    );
                  },
                ),
                // Extractor Fan
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletExtractorFanImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Extractor Fan images');
                    }
                    final toiletExtractorFanImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Extractor Fan",
                      condition: toiletExtractorFanCondition,
                      description: toiletExtractorFanDescription,
                      images: toiletExtractorFanImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletExtractorFanCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletExtractorFanCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletExtractorFanDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletExtractorFanDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletExtractorFanImages');
                      },
                    );
                  },
                ),
                // Lighting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletLightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Lighting images');
                    }
                    final toiletlLightingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Lighting",
                      condition: toiletLightingCondition,
                      description: toiletLightingDescription,
                      images: toiletlLightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletLightingCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletLightingCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletLightingDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletLightingDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletLightingImages');
                      },
                    );
                  },
                ),
                // Walls
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletWallsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Walls images');
                    }
                    final toiletWallsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Walls",
                      condition: toiletWallsCondition,
                      description: toiletWallsDescription,
                      images: toiletWallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletWallsCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletWallsCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletWallsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletWallsDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletWallsImages');
                      },
                    );
                  },
                ),
                // Skirting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletSkirtingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Skirting images');
                    }
                    final toiletSkirtingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Skirting",
                      condition: toiletSkirtingCondition,
                      description: toiletSkirtingDescription,
                      images: toiletSkirtingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletSkirtingCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletSkirtingCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletSkirtingDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletSkirtingDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletSkirtingImages');
                      },
                    );
                  },
                ),
                // Window Sill
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletWindowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Window Sill images');
                    }
                    final toiletWindowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Window Sill",
                      condition: toiletWindowSillCondition,
                      description: toiletwWindowSillDescription,
                      images: toiletWindowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletWindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletWindowSillCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletwWindowSillDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletWindowSillDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletWindowSillImages');
                      },
                    );
                  },
                ),
                // Curtains
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletCurtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Curtains images');
                    }
                    final toiletCurtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Curtains",
                      condition: toiletCurtainsCondition,
                      description: toiletCurtainsDescription,
                      images: toiletCurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletCurtainsCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletCurtainsCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletCurtainsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletCurtainsDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletCurtainsImages');
                      },
                    );
                  },
                ),
                // Blinds
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletBlindsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Blinds images');
                    }
                    final toiletBlindsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Blinds",
                      condition: toiletBlindsCondition,
                      description: toiletBlindsDescription,
                      images: toiletBlindsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletBlindsCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletBlindsCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletBlindsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletBlindsDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletBlindsImages');
                      },
                    );
                  },
                ),
                // Toilet
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletToiletImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Toilet images');
                    }
                    final toiletToiletImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Toilet",
                      condition: toiletToiletCondition,
                      description: toiletToiletDescription,
                      images: toiletToiletImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletToiletCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletToiletCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletToiletDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletToiletDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletToiletImages');
                      },
                    );
                  },
                ),
                // Basin
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletBasinImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Basin images');
                    }
                    final toiletBasinImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Basin",
                      condition: toiletBasinCondition,
                      description: toiletBasinDescription,
                      images: toiletBasinImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletBasinCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletBasinCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletBasinDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletBasinDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletBasinImages');
                      },
                    );
                  },
                ),
                // Shower Cubicle
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletShowerCubicleImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Shower Cubicle images');
                    }
                    final toiletShowerCubicleImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Shower Cubicle",
                      condition: toiletShowerCubicleCondition,
                      description: toiletShowerCubicleDescription,
                      images: toiletShowerCubicleImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletShowerCubicleCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletShowerCubicleCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletShowerCubicleDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletShowerCubicleDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletShowerCubicleImages');
                      },
                    );
                  },
                ),
                // Socket
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletSocketImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Socket images');
                    }
                    final toiletSocketImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Socket",
                      condition: toiletSocketCondition,
                      description: toiletSocketDescription,
                      images: toiletSocketImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletSocketCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletSocketCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletSocketDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletSocketDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletSocketImages');
                      },
                    );
                  },
                ),
                // Heating
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletHeatingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Heating images');
                    }
                    final toiletHeatingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Heating",
                      condition: toiletHeatingCondition,
                      description: toiletHeatingDescription,
                      images: toiletHeatingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletHeatingCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletHeatingCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletHeatingDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletHeatingDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletHeatingImages');
                      },
                    );
                  },
                ),
                // Accessories
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletAccessoriesImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Accessories images');
                    }
                    final toiletAccessoriesImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Accessories",
                      condition: toiletAccessoriesCondition,
                      description: toiletAccessoriesDescription,
                      images: toiletAccessoriesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletAccessoriesCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletAccessoriesCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletAccessoriesDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletAccessoriesDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletAccessoriesImages');
                      },
                    );
                  },
                ),
                // Flooring
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletFlooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Flooring images');
                    }
                    final toiletFlooringImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Flooring",
                      condition: toiletFlooringCondition,
                      description: toiletFlooringDescription,
                      images: toiletFlooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletFlooringCondition = condition;
                        });
                        _savePreference(propertyId, 'toiletFlooringCondition',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletFlooringDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletFlooringDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletFlooringImages');
                      },
                    );
                  },
                ),
                // Additional Items
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'toiletAdditionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Additional Items images');
                    }
                    final toiletAdditionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Additional Items",
                      condition: toiletAdditionalItemsCondition,
                      description: toiletAdditionalItemsDescription,
                      images: toiletAdditionalItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          toiletAdditionalItemsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'toiletAdditionalItemsCondition', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          toiletAdditionalItemsDescription = description;
                        });
                        _savePreference(
                            propertyId, 'toiletAdditionalItemsDescription', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'toiletAdditionalItemsImages');
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditReportPage(propertyId: widget.propertyId),
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

  // Method to show save dialog
  void _showSaveDialog(BuildContext context) {
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditReportPage(propertyId: widget.propertyId)),
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