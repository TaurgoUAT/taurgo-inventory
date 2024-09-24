import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart'; 

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Ensuite extends StatefulWidget {
  final String propertyId;
  final List<File>? ensuitecapturedImages;

  const Ensuite({super.key, this.ensuitecapturedImages, required this.propertyId});

  @override
  State<Ensuite> createState() => _EnsuiteState();
}




class _EnsuiteState extends State<Ensuite> {
String? ensuitdoorCondition;
  String? ensuitdoorLocation;
  String? ensuitdoorFrameCondition;
  String? ensuitedoorFrameLocation;
  String? ensuiteceilingCondition;
  String? ensuitceilingLocation;
  String? ensuitlightingCondition;
  String? ensuitelightingLocation;
  String? ensuitewallsCondition;
  String? ensuitewallsLocation;
  String? ensuiteskirtingCondition;
  String? ensuiteskirtingLocation;
  String? ensuitewindowSillCondition;
  String? ensuitewindowSillLocation;
  String? ensuitecurtainsCondition;
  String? ensuitecurtainsLocation;
  String? ensuiteblindsCondition;
  String? ensuiteblindsLocation;
  String? ensuitelightSwitchesCondition;
  String? ensuitelightSwitchesLocation;
  String? ensuiteToiletCondition;
  String? ensuiteToiletLocation;
  String? ensuiteBasinCondition;
  String? ensuiteBasinLocation;
  String? ensuiteShowerCubicleCondition;
  String? ensuiteShowerCubicleLocation;
  String? ensuiteSwitchCondition;
  String? ensuiteSwitchLocation;
  String? ensuiteSocketCondition;
  String? ensuiteSocketLocation;
  String? ensuiteHeatingCondition;
  String? ensuiteHeatingLocation;
  String? ensuiteAccessoriesCondition;
  String? ensuiteAccessoriesLocation;
  String? ensuiteFlooringCondition;
  String? ensuiteFlooringLocation;
  String? ensuiteAdditionItemsCondition;
  String? ensuiteAdditionItemsLocation;
  String? ensuiteShowerCondition;
  String? ensuiteShowerLocation;
  List<String> ensuitedoorImages = [];
  List<String> ensuitedoorFrameImages = [];
  List<String> ensuiteceilingImages = [];
  List<String> ensuitelightingImages = [];
  List<String> ensuitewallsImages = [];
  List<String> ensuiteskirtingImages = [];
  List<String> ensuitewindowSillImages = [];
  List<String> ensuitecurtainsImages = [];
  List<String> ensuiteToiletImages = [];
  List<String> ensuiteBasinImages = [];
  List<String> ensuiteShowerCubicleImages = [];
  List<String> ensuiteShowerImages = [];
  List<String> ensuiteSwitchImages = [];
  List<String> ensuiteSocketImages = [];
  List<String> ensuiteHeatingImages = [];
  List<String> ensuiteAccessoriesImages = [];
  List<String> ensuiteblindsImages = [];
  List<String> ensuitelightSwitchesImages = [];
  List<String> ensuiteflooringImages = [];
  List<String> ensuiteadditionalItemsImages = [];
  late List<File> ensuitecapturedImages;

  @override
  void initState() {
    super.initState();
    ensuitecapturedImages = widget.ensuitecapturedImages ?? [];
    
  }

 // Fetch images from Firestore
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
        .collection('ensuite')
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
        imageFile, propertyId, 'ensuite', documentId);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ensuite',
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
                stream:
                    _getImagesFromFirestore(propertyId, 'ensuitedoorImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door images');
                  }
                  final ensuitedoorImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Door",
                      condition: ensuitdoorCondition,
                      location: ensuitdoorLocation,
                      images: ensuitedoorImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitdoorCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'ensuitdoorCondition', condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitdoorLocation = location;
                        });
                        _savePreference(
                            propertyId, 'ensuitdoorLocation', location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitedoorImages');
                      });
                },
              ),
              // Door Frame
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuitedoorFrameImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Door Frame images');
                  }
                  final ensuitedoorFrameImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Door Frame",
                      condition: ensuitdoorFrameCondition,
                      location: ensuitedoorFrameLocation,
                      images: ensuitedoorFrameImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitdoorFrameCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuitdoorFrameCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitedoorFrameLocation = location;
                        });
                        _savePreference(propertyId, 'ensuitedoorFrameLocation',
                            location!);
                      },
                     onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitedoorFrameImages');
                      });
                },
              ),
              // Ceiling
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteceilingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Ceiling images');
                  }
                  final ensuiteceilingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Ceiling",
                      condition: ensuiteceilingCondition,
                      location: ensuitceilingLocation,
                      images: ensuiteceilingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteceilingCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteceilingCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitceilingLocation = location;
                        });
                        _savePreference(propertyId, 'ensuitceilingLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteceilingImages');
                      });
                },
              ),
              // Lighting
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuitelightingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Lighting images');
                  }
                  final ensuitelightingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Lighting",
                      condition: ensuitlightingCondition,
                      location: ensuitelightingLocation,
                      images: ensuitelightingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitlightingCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'ensuitlightingCondition', condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitelightingLocation = location;
                        });
                        _savePreference(
                            propertyId, 'ensuitelightingLocation', location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitelightingImages');
                      });
                },
              ),
              // Walls
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuitewallsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Walls images');
                  }
                  final ensuitewallsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Walls",
                      condition: ensuitewallsCondition,
                      location: ensuitewallsLocation,
                      images: ensuitewallsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitewallsCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuitewallsCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitewallsLocation = location;
                        });
                        _savePreference(propertyId, 'ensuitewallsLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitewallsImages');
                      });
                },
              ),
              // Skirting
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteskirtingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Skirting images');
                  }
                  final ensuiteskirtingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Skirting",
                      condition: ensuiteskirtingCondition,
                      location: ensuiteskirtingLocation,
                      images: ensuiteskirtingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteskirtingCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteskirtingCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteskirtingLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteskirtingLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteskirtingImages');
                      });
                },
              ),
              // Window Sill
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuitewindowSillImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Window Sill images');
                  }
                  final ensuitewindowSillImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Window Sill",
                      condition: ensuitewindowSillCondition,
                      location: ensuitewindowSillLocation,
                      images: ensuitewindowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitewindowSillCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuitewindowSillCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitewindowSillLocation = location;
                        });
                        _savePreference(propertyId, 'ensuitewindowSillLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitewindowSillImages');
                      });
                },
              ),
              // Curtains
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuitecurtainsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Curtains images');
                  }
                  final ensuitecurtainsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Curtains",
                      condition: ensuitecurtainsCondition,
                      location: ensuitecurtainsLocation,
                      images: ensuitecurtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitecurtainsCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuitecurtainsCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitecurtainsLocation = location;
                        });
                        _savePreference(propertyId, 'ensuitecurtainsLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitecurtainsImages');
                      });
                },
              ),
              // Blinds
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteblindsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Blinds images');
                  }
                  final ensuiteblindsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Blinds",
                      condition: ensuiteblindsCondition,
                      location: ensuiteblindsLocation,
                      images: ensuiteblindsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteblindsCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteblindsCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteblindsLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteblindsLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteblindsImages');
                      });
                },
              ),
              // Light Switches
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuitelightSwitchesImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Light Switches images');
                  }
                  final ensuitelightSwitchesImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Light Switches",
                      condition: ensuitelightSwitchesCondition,
                      location: ensuitelightSwitchesLocation,
                      images: ensuitelightSwitchesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuitelightSwitchesCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'ensuitelightSwitchesCondition', condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuitelightSwitchesLocation = location;
                        });
                        _savePreference(
                            propertyId, 'ensuitelightSwitchesLocation', location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuitelightSwitchesImages');
                      });
                },
              ),
              // Toilet
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteToiletImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Toilet images');
                  }
                  final ensuiteToiletImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Toilet",
                      condition: ensuiteToiletCondition,
                      location: ensuiteToiletLocation,
                      images: ensuiteToiletImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteToiletCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteToiletCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteToiletLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteToiletLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteToiletImages');
                      });
                },
              ),
              // Basin
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteBasinImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Basin images');
                  }
                  final ensuiteBasinImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Basin",
                      condition: ensuiteBasinCondition,
                      location: ensuiteBasinLocation,
                      images: ensuiteBasinImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteBasinCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteBasinCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteBasinLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteBasinLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteBasinImages');
                      });
                },
              ),
              // Shower Cubicle
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteShowerImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Shower Cubicle images');
                  }
                  final ensuiteShowerImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Shower Cubicle",
                      condition: ensuiteShowerCondition,
                      location: ensuiteShowerLocation,
                      images: ensuiteShowerImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteShowerCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteShowerCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteShowerLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteShowerLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteShowerImages');
                      });
                },
              ),
              // Switch
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteSwitchImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Switch images');
                  }
                  final ensuiteSwitchImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Switch",
                      condition: ensuiteSwitchCondition,
                      location: ensuiteSwitchLocation,
                      images: ensuiteSwitchImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteSwitchCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteSwitchCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteSwitchLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteSwitchLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteSwitchImages');
                      });
                },
              ),
              // Socket
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteSocketImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Socket images');
                  }
                  final ensuiteSocketImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Socket",
                      condition: ensuiteSocketCondition,
                      location: ensuiteSocketLocation,
                      images: ensuiteSocketImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteSocketCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteSocketCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteSocketLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteSocketLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteSocketImages');
                      });
                },
              ),
              // Heating
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteHeatingImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Heating images');
                  }
                  final ensuiteHeatingImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Heating",
                      condition: ensuiteHeatingCondition,
                      location: ensuiteHeatingLocation,
                      images: ensuiteHeatingImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteHeatingCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteHeatingCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteHeatingLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteHeatingLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteHeatingImages');
                      });
                },
              ),
              // Accessories
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteAccessoriesImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Accessories images');
                  }
                  final ensuiteAccessoriesImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Accessories",
                      condition: ensuiteAccessoriesCondition,
                      location: ensuiteAccessoriesLocation,
                      images: ensuiteAccessoriesImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteAccessoriesCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteAccessoriesCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteAccessoriesLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteAccessoriesLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteAccessoriesImages');
                      });
                },
              ),
              //Flooring
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteflooringImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Flooring images');
                  }
                  final ensuiteflooringImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Flooring",
                      condition: ensuiteFlooringCondition,
                      location: ensuiteFlooringLocation,
                      images: ensuiteflooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteFlooringCondition = condition;
                        });
                        _savePreference(propertyId, 'ensuiteFlooringCondition',
                            condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteFlooringLocation = location;
                        });
                        _savePreference(propertyId, 'ensuiteFlooringLocation',
                            location!);
                      },
                      onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteflooringImages');
                      });
                },
              ),
              // Additional Items
              StreamBuilder<List<String>>(
                stream: _getImagesFromFirestore(
                    propertyId, 'ensuiteadditionalItemsImages'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading Additional Items images');
                  }
                  final ensuiteadditionalItemsImages = snapshot.data ?? [];
                  return ConditionItem(
                      name: "Additional Items",
                      condition: ensuiteAdditionItemsCondition,
                      location: ensuiteAdditionItemsLocation,
                      images: ensuiteadditionalItemsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ensuiteAdditionItemsCondition = condition;
                        });
                        _savePreference(
                            propertyId, 'ensuiteAdditionItemsCondition', condition!);
                      },
                      onLocationSelected: (location) {
                        setState(() {
                          ensuiteAdditionItemsLocation = location;
                        });
                        _savePreference(
                            propertyId, 'ensuiteAdditionItemsLocation', location!);
                      },
                     onImageAdded: (XFile image) async {
                        await _handleImageAdded(image, 'ensuiteadditionalItemsImages');
                      });
                },
              ),
             
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
  final String? location;
  final List<String> images;
  final Function(String?) onConditionSelected;
  final Function(String?) onLocationSelected;
  final Function(XFile) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.location,
    required this.images,
    required this.onConditionSelected,
    required this.onLocationSelected,
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
                      // Initialize the camera when the button is pressed
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
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionDetails(
                    initialCondition: location,
                    type: name,
                  ),
                ),
              );
              if (result != null) {
                onLocationSelected(result);
              }
            },
            child: Text(
              location?.isNotEmpty == true ? location! : "Location",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryTextColourTwo,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: 12),
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
