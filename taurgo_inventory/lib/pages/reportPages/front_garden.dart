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

class FrontGarden extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const FrontGarden({super.key, this.capturedImages, required this.propertyId});

  @override
  State<FrontGarden> createState() => _FrontGardenState();
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
class _FrontGardenState extends State<FrontGarden> {
  String? gardenDescription;
  String? driveWayCondition;
  String? driveWayDescription;
  String? outsideLightingCondition;
  String? outsideLightingDescription;
  String? additionalItemsCondition;
  String? additionalItemsDescription;
   List<String> gardenImages = [];
  List<String> driveWayImages = [];
  List<String> outsideLightingImages = [];
  List<String> additionalItemsImages = [];
  late List<File> capturedImages;

   @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    // Load the saved preferences when the state is initialized
  }

 Stream<List<String>> _getImagesFromFirestore(String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('front_garden')
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
          'Front Garden',
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
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'gardenImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final gardenImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Garden",
                        condition: gardenDescription,
                        description: gardenDescription,
                        images: gardenImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          gardenDescription = condition;
                        });
                        _savePreference(propertyId, 'gardenDescription', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          gardenDescription = description;
                        });
                        _savePreference(propertyId, 'gardenDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'front_garden', 'gardenImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('front_garden')
                                .doc('gardenImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),
              // Drive Way
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'driveWayImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final driveWayImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Drive Way",
                        condition: driveWayCondition,
                        description: driveWayDescription,
                        images: driveWayImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          driveWayCondition = condition;
                        });
                        _savePreference(propertyId, 'driveWayCondition', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          driveWayDescription = description;
                        });
                        _savePreference(propertyId, 'driveWayDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'front_garden', 'driveWayImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('front_garden')
                                .doc('driveWayImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Outside Lighting
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'outsideLightingImages '),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final outsideLightingImages  = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Outside Lighting",
                        condition:  outsideLightingDescription,
                        description: outsideLightingDescription,
                        images: outsideLightingImages ,
                        onConditionSelected: (condition) {
                        setState(() {
                          outsideLightingDescription = condition;
                        });
                        _savePreference(propertyId, ' outsideLightingDescription', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          outsideLightingDescription = description;
                        });
                        _savePreference(propertyId, ' outsideLightingDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'front_garden', 'outsideLightingImages ');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('front_garden')
                                .doc('outsideLightingImages ')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),

              // Additional Items
              StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'additionalItemsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final additionalItemsImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Additional Items",
                        condition:    additionalItemsCondition,
                        description:  additionalItemsDescription,
                        images: additionalItemsImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          additionalItemsCondition = condition;
                        });
                        _savePreference(propertyId, 'additionalItemsCondition', condition!);
                      },
                          onDescriptionSelected: (description) {
                        setState(() {
                          additionalItemsDescription = description;
                        });
                        _savePreference(propertyId, 'additionalItemsDescription', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'front_garden', 'additionalItemsImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('front_garden')
                                .doc('additionalItemsImages')
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
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: condition,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onConditionSelected(result);
          //     }
          //   },
          //   child: Text(
          //     condition?.isNotEmpty == true ? condition! : "Condition",
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