import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart';
import '../../constants/AppColors.dart';
import '../../widgets/DottedBorderPainter.dart';
import '../conditions/condition_details.dart';

class EvCharger extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;
  const EvCharger({super.key, this.capturedImages, required this.propertyId});

  @override
  State<EvCharger> createState() => _EvChargerState();
}

class _EvChargerState extends State<EvCharger> {
  List<File> images = []; // List to store selected images
  List<String> imageNames = []; // List to hold image names

  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  List<File> capturedImages = [];

  String? evChargerDescription;
  List<String> evChargerImages = [];

  @override
  void initState() {
    super.initState();
    capturedImages = widget.capturedImages ?? [];
    print("Property Id - SOC${widget.propertyId}");
    _loadPreferences(widget.propertyId);

  }

  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      evChargerDescription = prefs.getString
        ('evChargerDescription_${propertyId}');

      evChargerImages = prefs.getStringList('evChargerImages_${propertyId}')
          ?? [];
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
    return PopScope(canPop: false,
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'EV Charger',
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
            Navigator.of(context).pop();
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
              // EV Charger
              ConditionItem(
                name: "EV Charger",
                // condition: evChargerDescription,
                description: evChargerDescription,
                images: evChargerImages,
                // onConditionSelected: (condition) {
                //   setState(() {
                //     evChargerDescription = condition;
                //   });
                //   _savePreference(propertyId,'evChargerDescription', condition!); // Save preference
                // },
                onDescriptionSelected: (description) {
                  setState(() {
                    evChargerDescription = description;
                  });
                  _savePreference(propertyId,'evChargerDescription', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    evChargerImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'evChargerImages', evChargerImages);
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
  // final String? condition;
  final String? description;
  final List<String> images;
  // final Function(String?) onConditionSelected;
  final Function(String?) onDescriptionSelected;
  final Function(String) onImageAdded;

  const ConditionItem({
    Key? key,
    required this.name,
    // this.condition,
    this.description,
    required this.images,
    // required this.onConditionSelected,
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
                  IconButton(
                    icon: Icon(
                      Icons.warning_amber,
                      size: 24,
                      color: kAccentColor,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AddAction(),
                      //   ),
                      // );
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