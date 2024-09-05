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

  const Keys({super.key, this.capturedImages});

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
    _loadPreferences(); // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      yaleLocation = prefs.getString('yaleLocation');
      yaleReading = prefs.getString('yaleReading');
      morticeLocation = prefs.getString('morticeLocation');
      morticeReading = prefs.getString('morticeReading');
      windowLockLocation = prefs.getString('windowLockLocation');
      windowLockReading = prefs.getString('windowLockReading');
      gasMeterLocation = prefs.getString('gasMeterLocation');
      gasMeterReading = prefs.getString('gasMeterReading');
      carPassLocation = prefs.getString('carPassLocation');
      carPassReading = prefs.getString('carPassReading');
      remoteLocation = prefs.getString('remoteLocation');
      remoteReading = prefs.getString('remoteReading');
      otherLocation = prefs.getString('otherLocation');
      otherReading = prefs.getString('otherReading');

      yaleImages = prefs.getStringList('yaleImages') ?? [];
      morticeImages = prefs.getStringList('morticeImages') ?? [];
      windowLockImages = prefs.getStringList('windowLockImages') ?? [];
      gasMeterImages = prefs.getStringList('gasMeterImages') ?? [];
      carPassImages = prefs.getStringList('carPassImages') ?? [];
      remoteImages = prefs.getStringList('remoteImages') ?? [];
      otherImages = prefs.getStringList('otherImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  Future<void> _savePreferenceList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditReportPage(propertyId: '',),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
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
                  _savePreference('yaleLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    yaleReading = reading;
                  });
                  _savePreference('yaleReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    yaleImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'yaleImages', yaleImages); // Save preference
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
                  _savePreference(
                      'morticeLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    morticeReading = reading;
                  });
                  _savePreference('morticeReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    morticeImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'morticeImages', morticeImages); // Save preference
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
                  _savePreference(
                      'windowLockLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    windowLockReading = reading;
                  });
                  _savePreference(
                      'windowLockReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowLockImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'windowLockImages', windowLockImages); // Save preference
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
                  _savePreference(
                      'gasMeterLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    gasMeterReading = reading;
                  });
                  _savePreference(
                      'gasMeterReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    gasMeterImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'gasMeterImages', gasMeterImages); // Save preference
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
                  _savePreference(
                      'carPassLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    carPassReading = reading;
                  });
                  _savePreference('carPassReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    carPassImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'carPassImages', carPassImages); // Save preference
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
                  _savePreference(
                      'remoteLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    remoteReading = reading;
                  });
                  _savePreference('remoteReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    remoteImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'remoteImages', remoteImages); // Save preference
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
                  _savePreference('otherLocation', location); // Save preference
                },
                onReadingSelected: (reading) {
                  setState(() {
                    otherReading = reading;
                  });
                  _savePreference('otherReading', reading); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    otherImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'otherImages', otherImages); // Save preference
                },
              ),

              // Add more ConditionItem widgets as needed
            ],
          ),
        ),
      ),
    );
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
                  IconButton(
                    icon: Icon(
                      Icons.warning_amber,
                      size: 24,
                      color: kAccentColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAction(),
                        ),
                      );
                    },
                  ),
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
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConditionDetails(
                    initialCondition: reading,
                    type: name,
                  ),
                ),
              );

              if (result != null) {
                onReadingSelected(result);
              }
            },
            child: Text(
              reading?.isNotEmpty == true ? reading! : "Reading",
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