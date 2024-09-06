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


class Exteriorfront extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const Exteriorfront({super.key, this.capturedImages, required this.propertyId});

  @override
  State<Exteriorfront> createState() => _ExteriorfrontState();
}

class _ExteriorfrontState extends State<Exteriorfront> {
  String? newdoor;
  String? ExteriorFrontDoorCondition;
  String? exteriorFrontDoorDescription;
  String? exteriorFrontDoorFrameCondition;
  String? exteriorFrontDoorFrameDescription;
  String? exteriorFrontPorchCondition;
  String? exteriorFrontPorchDescription;
  String? exteriorFrontAdditionalItemsCondition;
  String? exteriorFrontAdditionalItemsDescription;
  List<String> exteriorFrontDoorImages = [];
  List<String> exteriorFrontDoorFrameImages = [];
  List<String> exteriorFrontPorchImages = [];
  List<String> exteriorFrontAdditionalItemsImages = [];
  late List<File> capturedImages;

 @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);
    // Load the saved preferences when the state is initialized
  }

  // Function to load preferences
  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      newdoor = prefs.getString('newdoor');
      ExteriorFrontDoorCondition = prefs.getString('doorCondition');
      exteriorFrontDoorDescription = prefs.getString('doorDescription');
      exteriorFrontDoorFrameCondition = prefs.getString('doorFrameCondition');
      exteriorFrontDoorFrameDescription = prefs.getString('doorFrameDescription');
      exteriorFrontPorchCondition = prefs.getString('porchCondition');
      exteriorFrontPorchDescription = prefs.getString('porchDescription');
      exteriorFrontAdditionalItemsCondition = prefs.getString('additionalItemsCondition');
      exteriorFrontAdditionalItemsDescription = prefs.getString('additionalItemsDescription');

      exteriorFrontDoorImages = prefs.getStringList('doorImages') ?? [];
      exteriorFrontDoorFrameImages = prefs.getStringList('doorFrameImages') ?? [];
      exteriorFrontPorchImages = prefs.getStringList('porchImages') ?? [];
      exteriorFrontAdditionalItemsImages = prefs.getStringList('additionalItemsImages') ?? [];
    });
  }

  // Function to save a preference
  Future<void> _savePreference(String propertyId, String key, String value)
  async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${key}_$propertyId', value);
  }

  Future<void> _savePreferenceList(String propertyId, String key, List<String> value) async {
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
          'Exterior Front',
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
              ConditionItem(
                name: "Door",
                condition: ExteriorFrontDoorCondition,
                description: newdoor,
                images: exteriorFrontDoorImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ExteriorFrontDoorCondition = condition;
                  });
                  _savePreference(propertyId,'doorCondition', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    newdoor = description;
                  });
                  _savePreference(propertyId,'newdoor', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    exteriorFrontDoorImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorImages', exteriorFrontDoorImages);
                },
              ),
              // Door Frame
              ConditionItem(
                name: "Door Frame",
                condition: exteriorFrontDoorFrameCondition,
                description: exteriorFrontDoorFrameDescription,
                images: exteriorFrontDoorFrameImages,
                onConditionSelected: (condition) {
                  setState(() {
                    exteriorFrontDoorFrameCondition = condition;
                  });
                  _savePreference(propertyId,'doorFrameCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    exteriorFrontDoorFrameDescription = description;
                  });
                  _savePreference(propertyId,'doorFrameDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    exteriorFrontDoorFrameImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'doorFrameImages', exteriorFrontDoorFrameImages); // Save preference
                },
              ),

              // Porch
              ConditionItem(
                name: "Porch",
                condition: exteriorFrontPorchCondition,
                description: exteriorFrontPorchDescription,
                images: exteriorFrontPorchImages,
                onConditionSelected: (condition) {
                  setState(() {
                    exteriorFrontPorchCondition = condition;
                  });
                  _savePreference(propertyId,'porchCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    exteriorFrontPorchDescription = description;
                  });
                  _savePreference(propertyId,'porchDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    exteriorFrontPorchImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'porchImages', exteriorFrontPorchImages); // Save preference
                },
              ),

              // Additional Items
              ConditionItem(
                name: "Additional Items",
                condition: exteriorFrontAdditionalItemsCondition,
                description: exteriorFrontAdditionalItemsDescription,
                images: exteriorFrontAdditionalItemsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    exteriorFrontAdditionalItemsCondition = condition;
                  });
                  _savePreference(propertyId,'additionalItemsCondition', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    exteriorFrontAdditionalItemsDescription = description;
                  });
                  _savePreference(propertyId,'additionalItemsDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    exteriorFrontAdditionalItemsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'additionalItemsImages', exteriorFrontAdditionalItemsImages); // Save preference
                },
              ),

              // Display captured images
              ...capturedImages.map((file) => Image.file(file)).toList(),

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
          // SizedBox(
          //   height: 12,
          // ),
          // GestureDetector(
          //   onTap: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ConditionDetails(
          //           initialCondition: description,
          //           type: name,
          //         ),
          //       ),
          //     );
          //
          //     if (result != null) {
          //       onDescriptionSelected(result);
          //     }
          //   },
          //   child: Text(
          //     description?.isNotEmpty == true ? description! : "Description",
          //     style: TextStyle(
          //       fontSize: 12.0,
          //       fontWeight: FontWeight.w700,
          //       color: kPrimaryTextColourTwo,
          //       fontStyle: FontStyle.italic,
          //     ),
          //   ),
          // ),
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
