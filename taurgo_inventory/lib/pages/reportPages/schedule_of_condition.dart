import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'dart:async';
import 'dart:convert'; // For JSON encoding/decoding
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/widgets/add_action.dart';
import '../../constants/AppColors.dart';
import 'package:flutter/material.dart';

class ScheduleOfCondition extends StatefulWidget {
  final List<File>? capturedImages;

  const ScheduleOfCondition({super.key, this.capturedImages});

  @override
  State<ScheduleOfCondition> createState() => _ScheduleOfConditionState();
}



class _ScheduleOfConditionState extends State<ScheduleOfCondition> {
  List<String> filesToJson(List<File> files) {
    return files.map((file) => file.path).toList();
  }

  List<File> jsonToFiles(List<String> paths) {
    return paths.map((path) => File(path)).toList();
  }

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
    _loadConditions(); // Load conditions from SharedPreferences
    _loadImages(); // Load captured images from SharedPreferences
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('capturedImages') ?? [];
    setState(() {
      capturedImages = jsonToFiles(paths);
    });
  }

  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = filesToJson(capturedImages);
    await prefs.setStringList('capturedImages', paths);
    print(paths);
  }

  Future<void> _loadConditions() async {
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

  Future<void> _saveConditions() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('overview', overview ?? '');
    await prefs.setString('accessoryCleanliness', accessoryCleanliness ?? '');
    await prefs.setString('windowSill', windowSill ?? '');
    await prefs.setString('carpets', carpets ?? '');
    await prefs.setString('ceilings', ceilings ?? '');
    await prefs.setString('curtains', curtains ?? '');
    await prefs.setString('hardFlooring', hardFlooring ?? '');
    await prefs.setString('kitchenArea', kitchenArea ?? '');
    await prefs.setString('oven', oven ?? '');
    await prefs.setString('mattress', mattress ?? '');
    await prefs.setString('upholstrey', upholstrey ?? '');
    await prefs.setString('wall', wall ?? '');
    await prefs.setString('window', window ?? '');
    await prefs.setString('woodwork', woodwork ?? '');
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
    return PopScope(
      canPop: false,
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
                          'Do you want to Exit',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Your process will not be saved if you exit the process',
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
                                    EditReportPage()), // Replace HomePage with your home page
                          ); // Close the dialog
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
                            'Save and Continue',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        'Please Make Sure You Have Entered all the Details before Saving',
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
                          onPressed: () async {
                            await _saveConditions(); // Save conditions before continuing
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditReportPage()), // Replace HomePage with your home page
                            ); // Close the dialog
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
                ConditionItem(
                  name: "Overview",
                  selectedCondition: overview,
                  onConditionSelected: (condition) {
                    setState(() {
                      overview = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Accessory - Cleanliness",
                  selectedCondition: accessoryCleanliness,
                  onConditionSelected: (condition) {
                    setState(() {
                      accessoryCleanliness = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Window Sill",
                  selectedCondition: windowSill,
                  onConditionSelected: (condition) {
                    setState(() {
                      windowSill = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Carpets",
                  selectedCondition: carpets,
                  onConditionSelected: (condition) {
                    setState(() {
                      carpets = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Ceilings",
                  selectedCondition: ceilings,
                  onConditionSelected: (condition) {
                    setState(() {
                      ceilings = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Curtains",
                  selectedCondition: curtains,
                  onConditionSelected: (condition) {
                    setState(() {
                      curtains = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Hard Flooring",
                  selectedCondition: hardFlooring,
                  onConditionSelected: (condition) {
                    setState(() {
                      hardFlooring = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Kitchen Area",
                  selectedCondition: kitchenArea,
                  onConditionSelected: (condition) {
                    setState(() {
                      kitchenArea = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Oven",
                  selectedCondition: oven,
                  onConditionSelected: (condition) {
                    setState(() {
                      oven = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Mattress",
                  selectedCondition: mattress,
                  onConditionSelected: (condition) {
                    setState(() {
                      mattress = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Upholstrey",
                  selectedCondition: upholstrey,
                  onConditionSelected: (condition) {
                    setState(() {
                      upholstrey = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Wall",
                  selectedCondition: wall,
                  onConditionSelected: (condition) {
                    setState(() {
                      wall = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Window",
                  selectedCondition: window,
                  onConditionSelected: (condition) {
                    setState(() {
                      window = condition;
                    });
                  },
                ),
                ConditionItem(
                  name: "Woodwork",
                  selectedCondition: woodwork,
                  onConditionSelected: (condition) {
                    setState(() {
                      woodwork = condition;
                    });
                  },
                ),
                SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _showCapturedImages,
                    child: Text('Show Captured Images'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveConditions(); // Save conditions
                      await _saveImages(); // Save images
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditReportPage()), // Replace with your home page
                      );
                    },
                    child: Text('Save and Continue'),
                  ),
                ],
              ),),
                SizedBox(height: 20),
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
      ),
    );
  }
}

class ConditionItem extends StatelessWidget {
  final String name;
  final String? selectedCondition;
  final Function(String?) onConditionSelected;

  const ConditionItem({
    Key? key,
    required this.name,
    this.selectedCondition,
    required this.onConditionSelected,
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
                    "Name",
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
                        print("${cameras.toString()}");
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
          SizedBox(
            height: 6,
          ),
          GestureDetector(
            onTap: () async {
              if (Navigator.canPop(context)) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConditionDetails(
                      initialCondition: selectedCondition,
                      type: name,
                    ),
                  ),
                );
                if (result != null) {
                  onConditionSelected(result);
                }
              }
            },
            child: Text(
              selectedCondition ?? "Condition",
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

