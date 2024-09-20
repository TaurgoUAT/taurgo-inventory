import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/reportPages/ev_charger.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Keys extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const Keys({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Keys> createState() => _KeysState();
}

class _KeysState extends State<Keys> {
  String? yaleLocation;
  String? yaleReading;
  String? morticeLocation;
  String? morticeReading;
  String? windowLockLocation;
  String? windowLockReading;
  String? gasMeterLocation;
  String? gasMeterReading;
  String? carPassLocation;
  String? carPassReading;
  String? remoteLocation;
  String? remoteReading;
  String? otherLocation;
  String? otherReading;
  List<String> yaleImages = [];
  List<String> morticeImages = [];
  List<String> windowLockImages = [];
  List<String> keygasMeterImages = [];
  List<String> carPassImages = [];
  List<String> remoteImages = [];
  List<String> otherImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
  }

  Stream<List<String>> _getImagesFromFirestore(
      String propertyId, String imageType) {
    return FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('keys')
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
              'Keys',
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
                                  builder: (context) => EditReportPage(
                                      propertyId: widget
                                          .propertyId)), // Replace HomePage with your
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
                onTap: () {
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
                                    builder: (context) => EditReportPage(
                                        propertyId: widget
                                            .propertyId)), // Replace HomePage with your
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
                  // Yale
                  StreamBuilder<List<String>>(
                    stream: _getImagesFromFirestore(propertyId, 'yaleImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final yaleImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Yale",
                          condition: yaleLocation,
                          description: yaleLocation,
                          images: yaleImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              yaleLocation = condition;
                            });
                            _savePreference(
                                propertyId, 'yaleLocation', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              yaleLocation = description;
                            });
                            _savePreference(
                                propertyId, 'yaleLocation', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile, propertyId, 'keys', 'yaleImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('keys')
                                  .doc('yaleImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Mortice
                  StreamBuilder<List<String>>(
                    stream:
                        _getImagesFromFirestore(propertyId, 'morticeImages'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading Yale images');
                      }
                      final morticeImages = snapshot.data ?? [];
                      return ConditionItem(
                          name: "Mortice",
                          condition: morticeLocation,
                          description: morticeLocation,
                          images: morticeImages,
                          onConditionSelected: (condition) {
                            setState(() {
                              morticeLocation = condition;
                            });
                            _savePreference(
                                propertyId, 'morticeLocation', condition!);
                          },
                          onDescriptionSelected: (description) {
                            setState(() {
                              morticeLocation = description;
                            });
                            _savePreference(
                                propertyId, 'morticeLocation', description!);
                          },
                          onImageAdded: (imagePath) async {
                            File imageFile = File(imagePath);
                            String? downloadUrl = await uploadImageToFirebase(
                                imageFile, propertyId, 'keys', 'morticeImages');

                            if (downloadUrl != null) {
                              print(
                                  "Adding image URL to Firestore: $downloadUrl");
                              FirebaseFirestore.instance
                                  .collection('properties')
                                  .doc(propertyId)
                                  .collection('keys')
                                  .doc('morticeImages')
                                  .update({
                                'images': FieldValue.arrayUnion([downloadUrl]),
                              });
                            }
                          });
                    },
                  ),

                  // Window Lock
                  StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'windowLockImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final windowLockImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Window Lock",
                        condition: windowLockLocation,
                        description: windowLockLocation,
                        images: windowLockImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          windowLockLocation = condition;
                        });
                        _savePreference(propertyId, 'windowLockLocation', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          windowLockLocation = description;
                        });
                        _savePreference(propertyId, 'windowLockLocation', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'keys', 'windowLockImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('keys')
                                .doc('windowLockImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),


                  // Gas Meter
                  StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'keygasMeterImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final keygasMeterImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Gas Meter",
                        condition: gasMeterLocation,
                        description: gasMeterLocation,
                        images: keygasMeterImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          gasMeterLocation = condition;
                        });
                        _savePreference(propertyId, 'gasMeterLocation', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          gasMeterLocation = description;
                        });
                        _savePreference(propertyId, 'gasMeterLocation', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'keys', 'keygasMeterImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('keys')
                                .doc('keygasMeterImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),


                  // Car Pass
                  StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'carPassImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final carPassImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Car Pass",
                        condition: carPassLocation,
                        description: carPassLocation,
                        images: carPassImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          carPassLocation = condition;
                        });
                        _savePreference(propertyId, 'carPassLocation', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          carPassLocation = description;
                        });
                        _savePreference(propertyId, 'carPassLocation', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'keys', 'carPassImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('keys')
                                .doc('carPassImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),


                  // Remote
                 StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'remoteImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final remoteImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: " Remote",
                        condition: remoteLocation,
                        description: remoteLocation,
                        images: remoteImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          remoteLocation = condition;
                        });
                        _savePreference(propertyId, 'remoteLocation', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          remoteLocation = description;
                        });
                        _savePreference(propertyId, 'remoteLocation', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'keys', 'remoteImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('keys')
                                .doc('remoteImages')
                                .update({
                              'images': FieldValue.arrayUnion([downloadUrl]),
                            });
                          }
                        });
                  },
                ),


                  // Other
                  StreamBuilder<List<String>>(
                  stream: _getImagesFromFirestore(propertyId, 'otherImages'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading Yale images');
                    }
                    final otherImages = snapshot.data ?? [];
                    return ConditionItem(
                        name: "Other",
                        condition: otherLocation,
                        description: otherLocation,
                        images: otherImages,
                        onConditionSelected: (condition) {
                        setState(() {
                          otherLocation = condition;
                        });
                        _savePreference(propertyId, 'otherLocation', condition!);
                      },
                        onDescriptionSelected: (description) {
                        setState(() {
                          otherLocation = description;
                        });
                        _savePreference(propertyId, 'otherLocation', description!);
                      },
                        onImageAdded: (imagePath) async {
                          File imageFile = File(imagePath);
                          String? downloadUrl = await uploadImageToFirebase(
                              imageFile, propertyId,'keys', 'otherImages');

                          if (downloadUrl != null) {
                            print(
                                "Adding image URL to Firestore: $downloadUrl");
                            FirebaseFirestore.instance
                                .collection('properties')
                                .doc(propertyId)
                                .collection('keys')
                                .doc('otherImages')
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
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: reading,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onReadingSelected(result);
          //     }
          //   },
          //   child: Text(
          //     reading?.isNotEmpty == true ? reading! : "Reading",
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
