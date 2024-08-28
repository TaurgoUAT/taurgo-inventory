import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import '../../constants/AppColors.dart';
import '../../widgets/DottedBorderPainter.dart';


class EvCharger extends StatefulWidget {
  const EvCharger({super.key});

  @override
  State<EvCharger> createState() => _EvChargerState();
}

class _EvChargerState extends State<EvCharger> {
  List<File> images = []; // List to store selected images
  List<String> imageNames = []; // List to hold image names

  List<File> imagesToUpload = [];

  List<File> logoUpload = [];

  List<File> floorPlansUpload = [];
  Future<void> selectFromGalleryForPanorama(BuildContext context) async {
    try {
      final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();

      if (pickedFiles == null || pickedFiles.isEmpty) return;

      setState(() {
        for (var pickedFile in pickedFiles) {
          final imageTemp = File(pickedFile.path);
          images.add(imageTemp);
          imageNames
              .add('Panoramas'); // Ensure this is consistent with the image
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text('Panorama images have been selected',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Sorry for the inconvenience: $e',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: Container(
        color: bWhite,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPaint(
                painter: DottedBorderPainter(),
                child: Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        selectFromGalleryForPanorama(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: kPrimaryColor, size: 32),
                          SizedBox(height: 8),
                          // Add spacing between the icon and the text
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // // Save the selected condition and details
                    // Navigator.pop(context, _detailsController.text);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
