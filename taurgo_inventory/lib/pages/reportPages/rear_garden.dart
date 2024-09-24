import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage

import '../../constants/AppColors.dart';

class RearGarden extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const RearGarden({Key? key, this.capturedImages, required this.propertyId})
      : super(key: key);

  @override
  State<RearGarden> createState() => _RearGardenState();
}

class _RearGardenState extends State<RearGarden> {
  String? rearGardenCondition;
  String? rearGardenDescription;
  String? rearGardenOutsideLightingCondition;
  String? rearGardenOutsideLightingDescription;
  String? rearGardensummerHouseCondition;
  String? rearGardensummerHouseDescription;
  String? rearGardenshedCondition;
  String? rearGardenshedDescription;
  String? rearGardenadditionalInformationCondition;
  String? rearGardenadditionalInformationDescription;
  List<String> reargardenImages = [];
  List<String> rearGardenOutsideLightingImages = [];
  List<String> rearGardensummerHouseImages = [];
  List<String> rearGardenshedImages = [];
  List<String> rearGardenadditionalInformationImages = [];

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
        .collection('rearGarden')
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
        imageFile, propertyId, 'rearGarden', documentId);

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
            'RearGarden',
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
                // House Appliance Manual
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'reargardenDescriptionImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading images');
                    }
                    final reargardenDescriptionImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Rear Garden",
                      condition: rearGardenCondition,
                      description: rearGardenDescription,
                      images: reargardenDescriptionImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          rearGardenCondition = condition;
                        });
                        _savePreference(propertyId, 'rearGardenCondition,',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          rearGardenDescription = description;
                        });
                        _savePreference(propertyId, 'rearGardenDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'reargardenDescriptionImages');
                      },
                    );
                  },
                ),
                // Rear Garden Outside Lighting
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'rearGardenOutsideLightingImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading images');
                    }
                    final rearGardenOutsideLightingImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Rear Garden Outside Lighting",
                      condition: rearGardenOutsideLightingCondition,
                      description: rearGardenOutsideLightingDescription,
                      images: rearGardenOutsideLightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          rearGardenOutsideLightingCondition = condition;
                        });
                        _savePreference(
                            propertyId,
                            'rearGardenOutsideLightingCondition,',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          rearGardenOutsideLightingDescription = description;
                        });
                        _savePreference(
                            propertyId,
                            'rearGardenOutsideLightingDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'rearGardenOutsideLightingImages');
                      },
                    );
                  },
                ),
                // Rear Garden Summer House
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'rearGardensummerHouseImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading images');
                    }
                    final rearGardensummerHouseImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Rear Garden Summer House",
                      condition: rearGardensummerHouseCondition,
                      description: rearGardensummerHouseDescription,
                      images: rearGardensummerHouseImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          rearGardensummerHouseCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'rearGardensummerHouseCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          rearGardensummerHouseDescription = description;
                        });
                        _savePreference(
                            propertyId, 'rearGardensummerHouseDescription,', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'rearGardensummerHouseImages');
                      },
                    );
                  },
                ),
                // Rear Garden Shed
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'rearGardenshedImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading images');
                    }
                    final rearGardenshedImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Rear Garden Shed",
                      condition: rearGardenshedCondition,
                      description: rearGardenshedDescription,
                      images: rearGardenshedImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          rearGardenshedCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'rearGardenshedCondition,', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          rearGardenshedDescription = description;
                        });
                        _savePreference(
                            propertyId, 'rearGardenshedDescription,', description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'rearGardenshedImages');
                      },
                    );
                  },
                ),
                // Rear Garden Additional Information
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'rearGardenadditionalInformationImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading images');
                    }
                    final rearGardenadditionalInformationImages =
                        snapshot.data ?? [];
                    return ConditionItem(
                      name: "Rear Garden Additional Information",
                      condition: rearGardenadditionalInformationCondition,
                      description: rearGardenadditionalInformationDescription,
                      images: rearGardenadditionalInformationImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          rearGardenadditionalInformationCondition = condition;
                        });
                        _savePreference(
                            propertyId,
                            'rearGardenadditionalInformationCondition,',
                            condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          rearGardenadditionalInformationDescription = description;
                        });
                        _savePreference(
                            propertyId,
                            'rearGardenadditionalInformationDescription,',
                            description!);
                      },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'rearGardenadditionalInformationImages');
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