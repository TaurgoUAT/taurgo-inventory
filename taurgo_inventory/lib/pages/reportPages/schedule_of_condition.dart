import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/widgets/add_action.dart';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import '../../constants/AppColors.dart';

class ScheduleOfCondition extends StatefulWidget {
  final List<File>? capturedImages;

  const ScheduleOfCondition({super.key, this.capturedImages});

  @override
  State<ScheduleOfCondition> createState() => _ScheduleOfConditionState();
}

class _ScheduleOfConditionState extends State<ScheduleOfCondition> {
  late List<File> capturedImages;

  String? overview;
  String? accessoryCleanliness;
  String? windowSill;
  String? carpets;
  String? ceilings;
  String? curtains;
  String? hardFlooring;
  String? kitchenArea;
  String? oven;
  String? mattress;
  String? upholstrey;
  String? wall;
  String? window;
  String? woodwork;

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
      overview = prefs.getString('overview');
      accessoryCleanliness = prefs.getString('accessoryCleanliness');
      windowSill = prefs.getString('windowSill');
      carpets = prefs.getString('carpets');
      ceilings = prefs.getString('ceilings');
      curtains = prefs.getString('curtains');
      hardFlooring = prefs.getString('hardFlooring');
      kitchenArea = prefs.getString('kitchenArea');
      oven = prefs.getString('oven');
      mattress = prefs.getString('mattress');
      upholstrey = prefs.getString('upholstrey');
      wall = prefs.getString('wall');
      window = prefs.getString('window');
      woodwork = prefs.getString('woodwork');
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  void _showCapturedImages() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapturedImagesPage(images: capturedImages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditReportPage(),
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
              // Overview
              ConditionItem(
                name: "Overview",
                condition: overview,
                description: overview,
                onConditionSelected: (condition) {
                  setState(() {
                    overview = condition;
                  });
                  _savePreference('overview', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    overview = description;
                  });
                  _savePreference('overview', description); // Save preference
                },
              ),

              // Accessory Cleanliness
              ConditionItem(
                name: "Accessory - Cleanliness",
                condition: accessoryCleanliness,
                description: accessoryCleanliness,
                onConditionSelected: (condition) {
                  setState(() {
                    accessoryCleanliness = condition;
                  });
                  _savePreference('accessoryCleanliness', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    accessoryCleanliness = description;
                  });
                  _savePreference('accessoryCleanliness', description); // Save preference
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: windowSill,
                description: windowSill,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSill = condition;
                  });
                  _savePreference('windowSill', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    windowSill = description;
                  });
                  _savePreference('windowSill', description); // Save preference
                },
              ),

              // Carpets
              ConditionItem(
                name: "Carpets",
                condition: carpets,
                description: carpets,
                onConditionSelected: (condition) {
                  setState(() {
                    carpets = condition;
                  });
                  _savePreference('carpets', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    carpets = description;
                  });
                  _savePreference('carpets', description); // Save preference
                },
              ),

              // Ceilings
              ConditionItem(
                name: "Ceilings",
                condition: ceilings,
                description: ceilings,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilings = condition;
                  });
                  _savePreference('ceilings', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    ceilings = description;
                  });
                  _savePreference('ceilings', description); // Save preference
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: curtains,
                description: curtains,
                onConditionSelected: (condition) {
                  setState(() {
                    curtains = condition;
                  });
                  _savePreference('curtains', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    curtains = description;
                  });
                  _savePreference('curtains', description); // Save preference
                },
              ),

              // Hard Flooring
              ConditionItem(
                name: "Hard Flooring",
                condition: hardFlooring,
                description: hardFlooring,
                onConditionSelected: (condition) {
                  setState(() {
                    hardFlooring = condition;
                  });
                  _savePreference('hardFlooring', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    hardFlooring = description;
                  });
                  _savePreference('hardFlooring', description); // Save preference
                },
              ),

              // Kitchen Area
              ConditionItem(
                name: "Kitchen Area",
                condition: kitchenArea,
                description: kitchenArea,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenArea = condition;
                  });
                  _savePreference('kitchenArea', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenArea = description;
                  });
                  _savePreference('kitchenArea', description); // Save preference
                },
              ),

              // Oven
              ConditionItem(
                name: "Oven",
                condition: oven,
                description: oven,
                onConditionSelected: (condition) {
                  setState(() {
                    oven = condition;
                  });
                  _savePreference('oven', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    oven = description;
                  });
                  _savePreference('oven', description); // Save preference
                },
              ),

              // Mattress
              ConditionItem(
                name: "Mattress",
                condition: mattress,
                description: mattress,
                onConditionSelected: (condition) {
                  setState(() {
                    mattress = condition;
                  });
                  _savePreference('mattress', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    mattress = description;
                  });
                  _savePreference('mattress', description); // Save preference
                },
              ),

              // Upholstrey
              ConditionItem(
                name: "Upholstrey",
                condition: upholstrey,
                description: upholstrey,
                onConditionSelected: (condition) {
                  setState(() {
                    upholstrey = condition;
                  });
                  _savePreference('upholstrey', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    upholstrey = description;
                  });
                  _savePreference('upholstrey', description); // Save preference
                },
              ),

              // Wall
              ConditionItem(
                name: "Wall",
                condition: wall,
                description: wall,
                onConditionSelected: (condition) {
                  setState(() {
                    wall = condition;
                  });
                  _savePreference('wall', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    wall = description;
                  });
                  _savePreference('wall', description); // Save preference
                },
              ),

              // Window
              ConditionItem(
                name: "Window",
                condition: window,
                description: window,
                onConditionSelected: (condition) {
                  setState(() {
                    window = condition;
                  });
                  _savePreference('window', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    window = description;
                  });
                  _savePreference('window', description); // Save preference
                },
              ),

              // Woodwork
              ConditionItem(
                name: "Woodwork",
                condition: woodwork,
                description: woodwork,
                onConditionSelected: (condition) {
                  setState(() {
                    woodwork = condition;
                  });
                  _savePreference('woodwork', condition); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    woodwork = description;
                  });
                  _savePreference('woodwork', description); // Save preference
                },
              ),

              // Add more ConditionItem widgets as needed
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCapturedImages, // Show captured images when clicked
        label: Icon(
          Icons.image_outlined,
          color: bWhite,
          size: 24,
        ),
        backgroundColor: kPrimaryColor,
        hoverColor: kPrimaryColor.withOpacity(0.4),
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        elevation: 3.0,
      ),
    );
  }
}

class ConditionItem extends StatelessWidget {
  final String name;
  final String? condition;
  final String? description;
  final Function(String?) onConditionSelected;
  final Function(String?) onDescriptionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.condition,
    this.description,
    required this.onConditionSelected,
    required this.onDescriptionSelected,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPreviewPage(
                              cameraController: cameraController,
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
          SizedBox(height: 12,),
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
         
          Divider(thickness: 1, color: Color(0xFFC2C2C2)),
        ],
      ),
    );
  }
}
class CapturedImagesPage extends StatelessWidget {
  final List<File> images;

  CapturedImagesPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Captured Images',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 14,
            fontFamily: "Inter",
          ),
        ),
        backgroundColor: bWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.file(images[index]);
        },
      ),
    );
  }
}