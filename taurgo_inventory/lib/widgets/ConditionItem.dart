import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/AppColors.dart';
import '../../widgets/ConditionItem.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';

class ConditionItem extends StatelessWidget {
  final String name;
  final String? selectedCondition;
  final Function(String?) onConditionSelected;
  final List<File> capturedImages; // Add this line to accept captured images

  const ConditionItem({
    Key? key,
    required this.name,
    this.selectedCondition,
    required this.onConditionSelected,
    required this.capturedImages, // Add this line to accept captured images
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
                  // Uncomment and modify if needed
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.warning_amber,
                  //     size: 24,
                  //     color: kAccentColor,
                  //   ),
                  //   onPressed: () {
                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(
                  //     //     builder: (context) => AddAction(),
                  //     //   ),
                  //     // );
                  //   },
                  // ),
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
          // Display captured images
          if (capturedImages.isNotEmpty)
            Container(
              height: 80, // Adjust height as needed
              margin: EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: capturedImages.length,
                itemBuilder: (context, index) {
                  final image = capturedImages[index];
                  return Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: 100, // Adjust width as needed
                      height: 80, // Adjust height as needed
                    ),
                  );
                },
              ),
            ),
          Divider(thickness: 1, color: Color(0xFFC2C2C2)),
        ],
      ),
    );
  }
}
