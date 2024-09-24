import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';
import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class MeterReading extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const MeterReading({Key? key, this.capturedImages, required this.propertyId})
      : super(key: key);

  @override
  State<MeterReading> createState() => _MeterReadingState();
}

class _MeterReadingState extends State<MeterReading> {
  String? GasMeterReading;
  String? GasMeterReadingDescription;
  String? electricMeterReading;
  String? electricMeterReadingDescription;
  String? waterMeterReading;
  String? waterMeterReadingDescription;
  String? oilMeterReading;
  String? oilMeterReadingDescription;
  String? otherMeterReading;
  String? otherMeterReadingDescription;
  List<String> gasMeterImages = [];
  List<String> electricMeterImages = [];
  List<String> waterMeterImages = [];
  List<String> oilMeterImages = [];
  List<String> otherMeterImages = [];


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
        .collection('meter_reading')
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
    String? downloadUrl = await uploadImageToFirebase(
        imageFile, propertyId, 'meter_reading', documentId);

    if (downloadUrl != null) {
      print("Adding image URL to Firestore: $downloadUrl");
      // The image URL has already been added inside uploadImageToFirebase
    }
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

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Meter Reading',
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
                  stream: _getImagesFromFirestore(propertyId, 'gasMeterImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Gas Meter Reading images');
                    }
                    final gasMeterImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Gas Meter Reading",
                      condition: GasMeterReading,
                      description: GasMeterReadingDescription,
                      images: gasMeterImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          GasMeterReading = condition;
                        });
                        _savePreference(propertyId, 'GasMeterReading', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          GasMeterReadingDescription = description;
                        });
                        _savePreference(propertyId, 'GasMeterReadingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'gasMeterImages');
                      },
                    );
                  },
                ),
                // Electric Meter Reading
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'electricMeterImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Electric Meter Reading images');
                    }
                    final electricMeterImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Electric Meter Reading",
                      condition: electricMeterReading,
                      description: electricMeterReadingDescription,
                      images: electricMeterImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          electricMeterReading = condition;
                        });
                        _savePreference(propertyId, 'electricMeterReading', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          electricMeterReadingDescription = description;
                        });
                        _savePreference(propertyId, 'electricMeterReadingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'electricMeterImages');
                      },
                    );
                  },
                ),
                // Water Meter Reading
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'waterMeterImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Water Meter Reading images');
                    }
                    final waterMeterImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Water Meter Reading",
                      condition: waterMeterReading,
                      description: waterMeterReadingDescription,
                      images: waterMeterImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          waterMeterReading = condition;
                        });
                        _savePreference(propertyId, 'waterMeterReading', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          waterMeterReadingDescription = description;
                        });
                        _savePreference(propertyId, 'waterMeterReadingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'waterMeterImages');
                      },
                    );
                  },
                ),
                // Oil Meter Reading
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'oilMeterImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Oil Meter Reading images');
                    }
                    final oilMeterImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Oil Meter Reading",
                      condition: oilMeterReading,
                      description: oilMeterReadingDescription,
                      images: oilMeterImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          oilMeterReading = condition;
                        });
                        _savePreference(propertyId, 'oilMeterReading', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          oilMeterReadingDescription = description;
                        });
                        _savePreference(propertyId, 'oilMeterReadingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'oilMeterImages');
                      },
                    );
                  },
                ),
                // Other Meter Reading
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'otherMeterImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Other Meter Reading images');
                    }
                    final otherMeterImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Other Meter Reading",
                      condition: otherMeterReading,
                      description: otherMeterReadingDescription,
                      images: otherMeterImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          otherMeterReading = condition;
                        });
                        _savePreference(propertyId, 'otherMeterReading', condition!);
                      },
                      onDescriptionSelected: (description) {
                        setState(() {
                          otherMeterReadingDescription = description;
                        });
                        _savePreference(propertyId, 'otherMeterReadingDescription', description!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'otherMeterImages');
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
      // ... your existing padding and layout code
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Type and Action Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Key Type Column
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
              description?.isNotEmpty == true
                  ? description!
                  : "Description",
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