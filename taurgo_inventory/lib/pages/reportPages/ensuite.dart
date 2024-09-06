import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';

import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';

class Ensuite extends StatefulWidget {
  final List<File>? ensuitecapturedImages;

  const Ensuite({super.key, this.ensuitecapturedImages});

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
  String? ensuitesocketsCondition;
  String? ensuitesocketsLocation;
  String? ensuiteflooringCondition;
  String? ensuiteflooringLocation;
  String? ensuiteadditionalItemsCondition;
  String? ensuiteadditionalItemsLocation;
  List<String> ensuitedoorImages = [];
  List<String> ensuitedoorFrameImages = [];
  List<String> ensuiteceilingImages = [];
  List<String> ensuitelightingImages = [];
  List<String> ensuitewallsImages = [];
  List<String> ensuiteskirtingImages = [];
  List<String> ensuitewindowSillImages = [];
  List<String> ensuitecurtainsImages = [];
  List<String> ensuiteblindsImages = [];
  List<String> ensuitelightSwitchesImages = [];
  List<String> ensuitesocketsImages = [];
  List<String> ensuiteflooringImages = [];
  List<String> ensuiteadditionalItemsImages = [];
  late List<File> ensuitecapturedImages;

  @override
  void initState() {
    super.initState();
    ensuitecapturedImages = widget.ensuitecapturedImages ?? [];
    _loadPreferences(); // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ensuitdoorCondition = prefs.getString('ensuitdoorCondition');
      ensuitdoorLocation = prefs.getString('ensuitdoorLocation');
      ensuitdoorFrameCondition = prefs.getString('ensuitdoorFrameCondition');
      ensuitedoorFrameLocation = prefs.getString('ensuitedoorFrameLocation');
      ensuiteceilingCondition = prefs.getString('ensuiteceilingCondition');
      ensuitceilingLocation = prefs.getString('ensuitceilingLocation');
      ensuitlightingCondition = prefs.getString('ensuitlightingCondition');
      ensuitelightingLocation = prefs.getString('ensuitelightingLocation');
      ensuitewallsCondition = prefs.getString('ensuitewallsCondition');
      ensuitewallsLocation = prefs.getString('ensuitewallsLocation');
      ensuiteskirtingCondition = prefs.getString('ensuiteskirtingCondition');
      ensuiteskirtingLocation = prefs.getString('ensuiteskirtingLocation');
      ensuitewindowSillCondition =
          prefs.getString('ensuitewindowSillCondition');
      ensuitewindowSillLocation = prefs.getString('ensuitewindowSillLocation');
      ensuitecurtainsCondition = prefs.getString('ensuitecurtainsCondition');
      ensuitecurtainsLocation = prefs.getString('ensuitecurtainsLocation');
      ensuiteblindsCondition = prefs.getString('ensuiteblindsCondition');
      ensuiteblindsLocation = prefs.getString('ensuiteblindsLocation');
      ensuitelightSwitchesCondition =
          prefs.getString('ensuitelightSwitchesCondition');
      ensuitelightSwitchesLocation =
          prefs.getString('ensuitelightSwitchesLocation');
      ensuitesocketsCondition = prefs.getString('ensuitesocketsCondition');
      ensuitesocketsLocation = prefs.getString('ensuitesocketsLocation');
      ensuiteflooringCondition = prefs.getString('ensuiteflooringCondition');
      ensuiteflooringLocation = prefs.getString('ensuiteflooringLocation');
      ensuiteadditionalItemsCondition =
          prefs.getString('ensuiteadditionalItemsCondition');
      ensuiteadditionalItemsLocation =
          prefs.getString('ensuiteadditionalItemsLocation');

      ensuitedoorImages = prefs.getStringList('ensuitedoorImages') ?? [];
      ensuitedoorFrameImages =
          prefs.getStringList('ensuitedoorFrameImages') ?? [];
      ensuiteceilingImages = prefs.getStringList('ensuiteceilingImages') ?? [];
      ensuitelightingImages =
          prefs.getStringList('ensuitelightingImages') ?? [];
      ensuitewallsImages = prefs.getStringList('ensuitewallsImages') ?? [];
      ensuiteskirtingImages =
          prefs.getStringList('ensuiteskirtingImages') ?? [];
      ensuitewindowSillImages =
          prefs.getStringList('ensuitewindowSillImages') ?? [];
      ensuitecurtainsImages =
          prefs.getStringList('ensuitecurtainsImages') ?? [];
      ensuiteblindsImages = prefs.getStringList('ensuiteblindsImages') ?? [];
      ensuitelightSwitchesImages =
          prefs.getStringList('ensuitelightSwitchesImages') ?? [];
      ensuitesocketsImages = prefs.getStringList('ensuitesocketsImages') ?? [];
      ensuiteflooringImages =
          prefs.getStringList('ensuiteflooringImages') ?? [];
      ensuiteadditionalItemsImages =
          prefs.getStringList('ensuiteadditionalItemsImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditReportPage(
                  propertyId: '',
                ),
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
              // Door
              ConditionItem(
                name: "Door",
                condition: ensuitdoorCondition,
                location: ensuitdoorLocation,
                images: ensuitedoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitdoorCondition = condition;
                  });
                  _savePreference('ensuitdoorCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitdoorLocation = location;
                  });
                  _savePreference('ensuitdoorLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitedoorImages.add(imagePath);
                  });
                  _savePreferenceList('ensuitedoorImages', ensuitedoorImages);
                },
              ),

              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: ensuitdoorFrameCondition,
                location: ensuitedoorFrameLocation,
                images: ensuitedoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitdoorFrameCondition = condition;
                  });
                  _savePreference('ensuitdoorFrameCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitedoorFrameLocation = location;
                  });
                  _savePreference('ensuitedoorFrameLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitedoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuitedoorFrameImages', ensuitedoorFrameImages);
                },
              ),

              // Ceiling
              ConditionItem(
                name: "Ceiling",
                condition: ensuiteceilingCondition,
                location: ensuitceilingLocation,
                images: ensuiteceilingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuiteceilingCondition = condition;
                  });
                  _savePreference('ensuiteceilingCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitceilingLocation = location;
                  });
                  _savePreference('ensuitceilingLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuiteceilingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuiteceilingImages', ensuiteceilingImages);
                },
              ),

              // Lighting
              ConditionItem(
                name: "Lighting",
                condition: ensuitlightingCondition,
                location: ensuitelightingLocation,
                images: ensuitelightingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitlightingCondition = condition;
                  });
                  _savePreference('ensuitlightingCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitelightingLocation = location;
                  });
                  _savePreference('ensuitelightingLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitelightingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuitelightingImages', ensuitelightingImages);
                },
              ),

              // Walls
              ConditionItem(
                name: "Walls",
                condition: ensuitewallsCondition,
                location: ensuitewallsLocation,
                images: ensuitewallsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitewallsCondition = condition;
                  });
                  _savePreference('ensuitewallsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitewallsLocation = location;
                  });
                  _savePreference('ensuitewallsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitewallsImages.add(imagePath);
                  });
                  _savePreferenceList('ensuitewallsImages', ensuitewallsImages);
                },
              ),

              // Skirting
              ConditionItem(
                name: "Skirting",
                condition: ensuiteskirtingCondition,
                location: ensuiteskirtingLocation,
                images: ensuiteskirtingImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuiteskirtingCondition = condition;
                  });
                  _savePreference('ensuiteskirtingCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuiteskirtingLocation = location;
                  });
                  _savePreference('ensuiteskirtingLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuiteskirtingImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuiteskirtingImages', ensuiteskirtingImages);
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: ensuitewindowSillCondition,
                location: ensuitewindowSillLocation,
                images: ensuitewindowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitewindowSillCondition = condition;
                  });
                  _savePreference('ensuitewindowSillCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitewindowSillLocation = location;
                  });
                  _savePreference('ensuitewindowSillLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitewindowSillImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuitewindowSillImages', ensuitewindowSillImages);
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: ensuitecurtainsCondition,
                location: ensuitecurtainsLocation,
                images: ensuitecurtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitecurtainsCondition = condition;
                  });
                  _savePreference('ensuitecurtainsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitecurtainsLocation = location;
                  });
                  _savePreference('ensuitecurtainsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitecurtainsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuitecurtainsImages', ensuitecurtainsImages);
                },
              ),

              // Blinds
              ConditionItem(
                name: "Blinds",
                condition: ensuiteblindsCondition,
                location: ensuiteblindsLocation,
                images: ensuiteblindsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuiteblindsCondition = condition;
                  });
                  _savePreference('ensuiteblindsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuiteblindsLocation = location;
                  });
                  _savePreference('ensuiteblindsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuiteblindsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuiteblindsImages', ensuiteblindsImages);
                },
              ),

              // Light Switches
              ConditionItem(
                name: "Light Switches",
                condition: ensuitelightSwitchesCondition,
                location: ensuitelightSwitchesLocation,
                images: ensuitelightSwitchesImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitelightSwitchesCondition = condition;
                  });
                  _savePreference('ensuitelightSwitchesCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitelightSwitchesLocation = location;
                  });
                  _savePreference('ensuitelightSwitchesLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitelightSwitchesImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuitelightSwitchesImages', ensuitelightSwitchesImages);
                },
              ),

              // Sockets
              ConditionItem(
                name: "Sockets",
                condition: ensuitesocketsCondition,
                location: ensuitesocketsLocation,
                images: ensuitesocketsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuitesocketsCondition = condition;
                  });
                  _savePreference('ensuitesocketsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuitesocketsLocation = location;
                  });
                  _savePreference('ensuitesocketsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuitesocketsImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuitesocketsImages', ensuitesocketsImages);
                },
              ),

              // Flooring
              ConditionItem(
                name: "Flooring",
                condition: ensuiteflooringCondition,
                location: ensuiteflooringLocation,
                images: ensuiteflooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuiteflooringCondition = condition;
                  });
                  _savePreference('ensuiteflooringCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuiteflooringLocation = location;
                  });
                  _savePreference('ensuiteflooringLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuiteflooringImages.add(imagePath);
                  });
                  _savePreferenceList(
                      'ensuiteflooringImages', ensuiteflooringImages);
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: ensuiteadditionalItemsCondition,
                location: ensuiteadditionalItemsLocation,
                images: ensuiteadditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ensuiteadditionalItemsCondition = condition;
                  });
                  _savePreference(
                      'ensuiteadditionalItemsCondition', condition!);
                },
                onLocationSelected: (location) {
                  setState(() {
                    ensuiteadditionalItemsLocation = location;
                  });
                  _savePreference('ensuiteadditionalItemsLocation', location!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ensuiteadditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList('ensuiteadditionalItemsImages',
                      ensuiteadditionalItemsImages);
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
  final Function(String) onImageAdded;

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
                      // Initialize the camera when the button is pressed
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        final cameraController = CameraController(
                          cameras.first,
                          ResolutionPreset.high,
                        );
                        await cameraController.initialize();
                        final image = await cameraController.takePicture();
                        final imagePath = image.path;

                        // Save the image path using the provided callback
                        onImageAdded(imagePath);
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
