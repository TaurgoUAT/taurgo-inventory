import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import 'package:digital_signature_flutter/digital_signature_flutter.dart';
import 'package:flutter/services.dart';

class InspectionConfimationPage extends StatefulWidget {
  const InspectionConfimationPage({super.key});

  @override
  State<InspectionConfimationPage> createState() =>
      _InspectionConfimationPageState();
}

class _InspectionConfimationPageState extends State<InspectionConfimationPage> {
  SignatureController? controller;
  Uint8List? signature;

  @override
  void initState() {
    controller = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      //Schedule of Condition',
      {
        'title': '1 Schedule of Condition',
        'icon': Icons.schedule,
        'subItems': [

          // Overview
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '2 Staircase',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '2.1 Name - Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '2.2 Name - Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },

      // Add more headings here
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report Preview',
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
                  builder: (context) => LandingScreen(),
                ),
              );
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       elevation: 10,
              //       backgroundColor: Colors.white,
              //       title: Row(
              //         children: [
              //           Icon(Icons.info_outline, color: kPrimaryColor),
              //           SizedBox(width: 10),
              //           Text(
              //             'Do you want to Exit',
              //             style: TextStyle(
              //               color: kPrimaryColor,
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //       content: Text(
              //         'Your process will not be saved if you exit the process',
              //         style: TextStyle(
              //           color: Colors.grey[800],
              //           fontSize: 14,
              //           fontWeight: FontWeight.w400,
              //           height: 1.5,
              //         ),
              //       ),
              //       actions: <Widget>[
              //         TextButton(
              //           child: Text(
              //             'Cancel',
              //             style: TextStyle(
              //               color: kPrimaryColor,
              //               fontSize: 16,
              //             ),
              //           ),
              //           onPressed: () {
              //             Navigator.of(context).pop(); // Close the dialog
              //           },
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             Navigator.pushReplacement(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => LandingScreen()),
              //             ); // Close the dialog
              //           },
              //           style: TextButton.styleFrom(
              //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //             backgroundColor: kPrimaryColor,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //           ),
              //           child: Text(
              //             'Exit',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //             ),
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // );
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: kPrimaryColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       elevation: 10,
                //       backgroundColor: Colors.white,
                //       title: Row(
                //         children: [
                //           Icon(Icons.info_outline, color: kPrimaryColor),
                //           SizedBox(width: 10),
                //           Text(
                //             'Continue Saving',
                //             style: TextStyle(
                //               color: kPrimaryColor,
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ],
                //       ),
                //       content: Text(
                //         'You Cannot make any changes after you save the Property',
                //         style: TextStyle(
                //           color: Colors.grey[800],
                //           fontSize: 14,
                //           fontWeight: FontWeight.w400,
                //           height: 1.5,
                //         ),
                //       ),
                //       actions: <Widget>[
                //         TextButton(
                //           child: Text('Cancel',
                //             style: TextStyle(
                //               color: kPrimaryColor,
                //               fontSize: 16,
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.of(context).pop(); // Close the dialog
                //           },
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(builder: (context) => DetailsConfirmationPage(
                //                 lineOneAddress: widget.lineOneAddress,
                //                 lineTwoAddress: widget.lineTwoAddress,
                //                 city: widget.city,
                //                 state: widget.state,
                //                 country: widget.country,
                //                 postalCode: widget.postalCode,
                //                 reference: widget.reference,
                //                 client: widget.client,
                //                 type: widget.type,
                //                 furnishing: widget.furnishing,
                //                 noOfBeds: widget.noOfBeds,
                //                 noOfBaths: widget.noOfBaths,
                //                 garage: garageSelected,
                //                 parking: parkingSelected,
                //                 notes: widget.notes,
                //                 selectedType: selectedType.toString(),
                //                 date: selectedDate,
                //                 time: selectedTime,
                //                 keyLocation: keysIwth.toString(),
                //                 referenceForKey: referenceController.text,
                //                 internalNotes: internalNotesController.text,
                //               )),
                //             );
                //           },
                //           style: TextButton.styleFrom(
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 16, vertical: 8),
                //             backgroundColor: kPrimaryColor,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //           child: Text(
                //             'Continue',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 16,
                //             ),
                //           ),
                //         ),
                //       ],
                //     );
                //   },
                // );
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
        // body: SingleChildScrollView(
        //  child: Padding(
        //    padding: EdgeInsets.all(16),
        //    child: Column(
        //      crossAxisAlignment: CrossAxisAlignment.start,
        //      children: [
        //
        //
        //        const SizedBox(height: 15),
        //        const Text('Please put the signature here',
        //            style: TextStyle(fontSize: 12, color: Colors.black)),
        //        const SizedBox(height: 15),
        //        Card(
        //          child: Center(
        //            child: Signature(
        //              height: 200,
        //              width: double.maxFinite,
        //              controller: controller!,
        //              backgroundColor: bWhite,
        //            ),
        //            // ),
        //          ),
        //        ),
        //        buttonWidgets(context)!,
        //        const SizedBox(height: 30),
        //        // const Text(viewSignature),
        //        signature != null
        //            ? Column(
        //          children: [
        //            Center(child: Image.memory(signature!)),
        //            const SizedBox(height: 10),
        //            MaterialButton(
        //              color: Colors.green,
        //              onPressed: (){},
        //              child: const Text("Submit", style: TextStyle(fontSize: 12, ),),
        //            )
        //          ],
        //        ) : Container(),
        //        const SizedBox(height: 30),
        //      ],
        //    ),
        //  ),
        // ),
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ExpansionTile(
              title: Text(item['title']),
              leading: Icon(item['icon']),
              children: item['subItems'].map<Widget>((subItem) {
                return ExpansionTile(
                  title: Text(subItem['title']),
                  children: [
                    Column(
                      children: subItem['details'].map<Widget>((detail) {
                        return ListTile(
                          title: Text(detail['label']),
                          subtitle: Text(detail['value']),
                        );
                      }).toList(),
                    ),
                    Container(
                      height: 100,
                      color: Colors.grey[200],
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: subItem['images'].length,
                        itemBuilder: (context, imgIndex) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 100,
                            child: Image.asset(subItem['images']
                                [imgIndex]), // Use Image.network() for URLs
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  buttonWidgets(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () async {
            if (controller!.isNotEmpty) {
              final sign = await exportSignature();
              setState(() {
                signature = sign;
              });
            } else {
              //showMessage
              // Please put your signature;
            }
          },
          child: const Text("Preview",
              style: TextStyle(fontSize: 20, color: kPrimaryColor)),
        ),
        TextButton(
          onPressed: () {
            controller?.clear();
            setState(() {
              signature = null;
            });
          },
          child: const Text("Re SIgn",
              style: TextStyle(fontSize: 20, color: Colors.redAccent)),
        ),
      ],
    );
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      points: controller!.points,
    );

    final signature = exportController.toPngBytes();

    //clean up the memory
    exportController.dispose();

    return signature;
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
