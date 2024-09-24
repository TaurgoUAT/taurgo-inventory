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

class ScheduleOfCondition extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const ScheduleOfCondition(
      {Key? key, this.capturedImages, required this.propertyId})
      : super(key: key);

  @override
  State<ScheduleOfCondition> createState() => _ScheduleOfConditionState();
}

class _ScheduleOfConditionState extends State<ScheduleOfCondition> {
  String? overview;
  String? accessoryCleanliness;
  String? windowSill;
  String? carpets;
  String? ceilings;
  String? curtains;
  String? hardFlooring;
  String? kitchenArea;
  String? kitchen;
  String? oven;
  String? mattress;
  String? upholstrey;
  String? wall;
  String? window;
  String? woodwork;
  List<String> overviewImages = [];
  List<String> accessoryCleanlinessImages = [];
  List<String> windowSillImages = [];
  List<String> carpetsImages = [];
  List<String> ceilingsImages = [];
  List<String> curtainsImages = [];
  List<String> hardFlooringImages = [];
  List<String> kitchenAreaImages = [];
  List<String> kitchenImages = [];
  List<String> ovenImages = [];
  List<String> mattressImages = [];
  List<String> upholstreyImages = [];
  List<String> wallImages = [];
  List<String> windowImages = [];
  List<String> woodworkImages = [];
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
        .collection('ScheduleOfCondition')
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
        imageFile, propertyId, 'ScheduleOfCondition', documentId);

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
            'Schedule of Condition',
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
                // Overview
                StreamBuilder<List<String>>(
                  stream:
                      _getImagesFromFirestore(propertyId, 'overviewImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Overview images');
                    }
                    final overviewImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Overview",
                      condition: overview,
                
                      images: overviewImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          overview = condition;
                        });
                        _savePreference(
                            propertyId, 'overview,', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     overviewDescription = description;
                      //   });
                      //   _savePreference(
                      //       propertyId, 'overviewDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'overviewImages');
                      },
                    );
                  },
                ),
                // Accessory Cleanliness
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(
                      propertyId, 'accessoryCleanlinessImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Accessory Cleanliness images');
                    }
                    final accessoryCleanlinessImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Accessory Cleanliness",
                      condition: accessoryCleanliness,
                      images: accessoryCleanlinessImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          accessoryCleanliness = condition;
                        });
                        _savePreference(
                            propertyId, 'accessoryCleanliness', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     accessoryCleanlinessDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'accessoryCleanlinessDescription',
                      //       description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(
                            imageFile, 'accessoryCleanlinessImages');
                      },
                    );
                  },
                ),
                // Window Sill
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'windowSillImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Window Sill images');
                    }
                    final windowSillImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Window Sill",
                      condition: windowSill,
                      images: windowSillImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          windowSill = condition;
                        });
                        _savePreference(propertyId, 'windowSill', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     windowSillDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'windowSillDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'windowSillImages');
                      },
                    );
                  },
                ),
                // Carpets
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'carpetsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Carpets images');
                    }
                    final carpetsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Carpets",
                      condition: carpets,
                      images: carpetsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          carpets = condition;
                        });
                        _savePreference(propertyId, 'carpets', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     carpetsDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'carpetsDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'carpetsImages');
                      },
                    );
                  },
                ),
                // Ceilings
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'ceilingsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Ceilings images');
                    }
                    final ceilingsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Ceilings",
                      condition: ceilings,
                      images: ceilingsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          ceilings = condition;
                        });
                        _savePreference(propertyId, 'ceilings', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     ceilingsDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'ceilingsDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'ceilingsImages');
                      },
                    );
                  },
                ),
                // Curtains
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'curtainsImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Curtains images');
                    }
                    final curtainsImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Curtains",
                      condition: curtains,
                      images: curtainsImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          curtains = condition;
                        });
                        _savePreference(propertyId, 'curtains', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     curtainsDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'curtainsDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'curtainsImages');
                      },
                    );
                  },
                ),
                // Kitchen Area
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'kitchenAreaImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Kitchen Area images');
                    }
                    final kitchenAreaImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Kitchen Area",
                      condition: kitchenArea,
                      images: kitchenAreaImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchenArea = condition;
                        });
                        _savePreference(propertyId, 'kitchenArea', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     kitchenAreaDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'kitchenAreaDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'kitchenAreaImages');
                      },
                    );
                  },
                ),
                // Kitchen
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'kitchenImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Kitchen images');
                    }
                    final kitchenImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Kitchen",
                      condition: kitchen,
                      images: kitchenImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          kitchen = condition;
                        });
                        _savePreference(propertyId, 'kitchen', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     kitchenDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'kitchenDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'kitchenImages');
                      },
                    );
                  },
                ),
                // Oven
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'ovenImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Oven images');
                    }
                    final ovenImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Oven",
                      condition: oven,
                      images: ovenImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          oven = condition;
                        });
                        _savePreference(propertyId, 'oven', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     ovenDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'ovenDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'ovenImages');
                      },
                    );
                  },
                ),
                // Mattress
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'mattressImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Mattress images');
                    }
                    final mattressImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Mattress",
                      condition: mattress,
                      images: mattressImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          mattress = condition;
                        });
                        _savePreference(propertyId, 'mattress', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     mattressDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'mattressDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'mattressImages');
                      },
                    );
                  },
                ),
                // Upholstery
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'upholsteryImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Upholstery images');
                    }
                    final upholstreyImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Upholstery",
                      condition: upholstrey,
                      images: upholstreyImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          upholstrey = condition;
                        });
                        _savePreference(propertyId, 'upholstery', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     upholstreyDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'upholsteryDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'upholsteryImages');
                      },
                    );
                  },
                ),
                // Wall
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'wallImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Wall images');
                    }
                    final wallImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Wall",
                      condition: wall,
                      images: wallImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          wall = condition;
                        });
                        _savePreference(propertyId, 'wall', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     wallDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'wallDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'wallImages');
                      },
                    );
                  },
                ),
                // Window
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'windowImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Window images');
                    }
                    final windowImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Window",
                      condition: window,
                      images: windowImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          window = condition;
                        });
                        _savePreference(propertyId, 'window', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     windowDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'windowDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'windowImages');
                      },
                    );
                  },
                ),
                // Woodwork
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'woodworkImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Woodwork images');
                    }
                    final woodworkImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Woodwork",
                      condition: woodwork,
                      images: woodworkImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          woodwork = condition;
                        });
                        _savePreference(propertyId, 'woodwork', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     woodworkDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'woodworkDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'woodworkImages');
                      },
                    );
                  },
                ),
                // Hard Flooring
                StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'hardFlooringImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Hard Flooring images');
                    }
                    final hardFlooringImages = snapshot.data ?? [];
                    return ConditionItem(
                      name: "Hard Flooring",
                      condition: hardFlooring,
                      images: hardFlooringImages,
                      onConditionSelected: (condition) {
                        setState(() {
                          hardFlooring = condition;
                        });
                        _savePreference(propertyId, 'hardFlooring', condition!);
                      },
                      // onDescriptionSelected: (description) {
                      //   setState(() {
                      //     hardFlooringDescription = description;
                      //   });
                      //   _savePreference(propertyId, 'hardFloorgDescription', description!);
                      // },
                      onImageAdded: (XFile imageFile) async {
                        await _handleImageAdded(imageFile, 'hardFlooringImages');
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
  // final Function(String?) onDescriptionSelected;
  final Function(XFile) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.description,
    required this.images,
    required this.onConditionSelected,
    // required this.onDescriptionSelected,
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

              // if (result != null) {
              //   onDescriptionSelected(result);
              // }
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