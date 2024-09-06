import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';

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
  List<String> gasMeterImages = [];
  List<String> carPassImages = [];
  List<String> remoteImages = [];
  List<String> otherImages = [];
  late List<File> capturedImages;

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      yaleLocation = prefs.getString('yaleLocation_${propertyId}');
      yaleReading = prefs.getString('yaleReading_${propertyId}');
      morticeLocation = prefs.getString('morticeLocation_${propertyId}');
      morticeReading = prefs.getString('morticeReading_${propertyId}');
      windowLockLocation = prefs.getString('windowLockLocation_${propertyId}');
      windowLockReading = prefs.getString('windowLockReading_${propertyId}');
      gasMeterLocation = prefs.getString('gasMeterLocation_${propertyId}');
      gasMeterReading = prefs.getString('gasMeterReading_${propertyId}');
      carPassLocation = prefs.getString('carPassLocation_${propertyId}');
      carPassReading = prefs.getString('carPassReading_${propertyId}');
      remoteLocation = prefs.getString('remoteLocation_${propertyId}');
      remoteReading = prefs.getString('remoteReading_${propertyId}');
      otherLocation = prefs.getString('otherLocation_${propertyId}');
      otherReading = prefs.getString('otherReading_${propertyId}');

      yaleImages = prefs.getStringList('yaleImages_${propertyId}') ?? [];
      morticeImages = prefs.getStringList('morticeImages_${propertyId}') ?? [];
      windowLockImages =
          prefs.getStringList('windowLockImages_${propertyId}') ?? [];
      gasMeterImages =
          prefs.getStringList('gasMeterImages_${propertyId}') ?? [];
      carPassImages = prefs.getStringList('carPassImages_${propertyId}') ?? [];
      remoteImages = prefs.getStringList('remoteImages_${propertyId}') ?? [];
      otherImages = prefs.getStringList('otherImages_${propertyId}') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(
      String propertyId, String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${key}_$propertyId', value);
  }

  Future<void> _savePreferenceList(
      String propertyId, String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('${key}_$propertyId', value);
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
                  // Yale
                  ConditionItem(
                    name: "Yale",
                    location: yaleLocation,
                    reading: yaleReading,
                    images: yaleImages,
                    onLocationSelected: (location) {
                      setState(() {
                        yaleLocation = location;
                      });
                      _savePreference(propertyId, 'yaleLocation', location!); //
                      // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        yaleReading = reading;
                      });
                      _savePreference(propertyId, 'yaleReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        yaleImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'yaleImages',
                          yaleImages); // Save preference
                    },
                  ),

                  // Mortice
                  ConditionItem(
                    name: "Mortice",
                    location: morticeLocation,
                    reading: morticeReading,
                    images: morticeImages,
                    onLocationSelected: (location) {
                      setState(() {
                        morticeLocation = location;
                      });
                      _savePreference(propertyId, 'morticeLocation',
                          location!); // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        morticeReading = reading;
                      });
                      _savePreference(propertyId, 'morticeReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        morticeImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'morticeImages',
                          morticeImages); // Save preference
                    },
                  ),

                  // Window Lock
                  ConditionItem(
                    name: "Window Lock",
                    location: windowLockLocation,
                    reading: windowLockReading,
                    images: windowLockImages,
                    onLocationSelected: (location) {
                      setState(() {
                        windowLockLocation = location;
                      });
                      _savePreference(propertyId, 'windowLockLocation',
                          location!); // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        windowLockReading = reading;
                      });
                      _savePreference(propertyId, 'windowLockReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        windowLockImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'windowLockImages',
                          windowLockImages); // Save preference
                    },
                  ),

                  // Gas Meter
                  ConditionItem(
                    name: "Gas Meter",
                    location: gasMeterLocation,
                    reading: gasMeterReading,
                    images: gasMeterImages,
                    onLocationSelected: (location) {
                      setState(() {
                        gasMeterLocation = location;
                      });
                      _savePreference(propertyId, 'gasMeterLocation',
                          location!); // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        gasMeterReading = reading;
                      });
                      _savePreference(propertyId, 'gasMeterReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        gasMeterImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'gasMeterImages',
                          gasMeterImages); // Save preference
                    },
                  ),

                  // Car Pass
                  ConditionItem(
                    name: "Car Pass",
                    location: carPassLocation,
                    reading: carPassReading,
                    images: carPassImages,
                    onLocationSelected: (location) {
                      setState(() {
                        carPassLocation = location;
                      });
                      _savePreference(propertyId, 'carPassLocation',
                          location!); // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        carPassReading = reading;
                      });
                      _savePreference(propertyId, 'carPassReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        carPassImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'carPassImages',
                          carPassImages); // Save preference
                    },
                  ),

                  // Remote
                  ConditionItem(
                    name: "Remote",
                    location: remoteLocation,
                    reading: remoteReading,
                    images: remoteImages,
                    onLocationSelected: (location) {
                      setState(() {
                        remoteLocation = location;
                      });
                      _savePreference(propertyId, 'remoteLocation',
                          location!); // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        remoteReading = reading;
                      });
                      _savePreference(propertyId, 'remoteReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        remoteImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'remoteImages',
                          remoteImages); // Save preference
                    },
                  ),

                  // Other
                  ConditionItem(
                    name: "Other",
                    location: otherLocation,
                    reading: otherReading,
                    images: otherImages,
                    onLocationSelected: (location) {
                      setState(() {
                        otherLocation = location;
                      });
                      _savePreference(propertyId, 'otherLocation',
                          location!); // Save preference
                    },
                    onReadingSelected: (reading) {
                      setState(() {
                        otherReading = reading;
                      });
                      _savePreference(propertyId, 'otherReading',
                          reading!); // Save preference
                    },
                    onImageAdded: (imagePath) {
                      setState(() {
                        otherImages.add(imagePath);
                      });
                      _savePreferenceList(propertyId, 'otherImages',
                          otherImages); // Save preference
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
  final String? location;
  final String? reading;
  final List<String> images;
  final Function(String?) onLocationSelected;
  final Function(String?) onReadingSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    this.location,
    this.reading,
    required this.images,
    required this.onLocationSelected,
    required this.onReadingSelected,
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
                  children: images.map((imagePath) {
                    return Image.file(
                      File(imagePath),
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
