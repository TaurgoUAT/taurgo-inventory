import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/widgets/add_action.dart';
import '../../constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ScheduleOfCondition extends StatefulWidget {
  final List<File>? capturedImages;

  const ScheduleOfCondition({super.key, this.capturedImages});

  @override
  State<ScheduleOfCondition> createState() => _ScheduleOfConditionState();
}

class _ScheduleOfConditionState extends State<ScheduleOfCondition> {
  String? selectedCondition1;
  String? selectedCondition2;
  String? selectedCondition3;
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
  }

  void _showCapturedImages() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapturedImagesPage(images:capturedImages),
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
            Navigator.pushReplacement(
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

              //Over View
              // ConditionItem(
              //   name: "Overview",
              //   selectedCondition: overview,
              //   onConditionSelected: (condition) {
              //     setState(() {
              //       overview = condition;
              //     });
              //   },
              //   cameraController: _cameraController,
              //   initializeControllerFuture: _initializeControllerFuture,
              // ),

              ConditionItem(
                name: "Overview",
                selectedCondition: overview,
                onConditionSelected: (condition) {
                  setState(() {
                    overview = condition;
                  });
                },
              ),

              //Accessort - Cleanliness
              ConditionItem(
                name: "Accessory - Cleanliness",
                selectedCondition: accessoryCleanliness,
                onConditionSelected: (condition) {
                  setState(() {
                    accessoryCleanliness = condition;
                  });
                },
              ),

              //Window Sill
              ConditionItem(
                name: "Window Sill",
                selectedCondition: windowSill,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSill = condition;
                  });
                },
              ),


              //Carpets
              ConditionItem(
                name: "Carpets",
                selectedCondition: carpets,
                onConditionSelected: (condition) {
                  setState(() {
                    carpets = condition;
                  });
                },
              ),

              //Ceilings
              ConditionItem(
                name: "Ceilings",
                selectedCondition: ceilings,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilings = condition;
                  });
                },
              ),

              //Curtains
              ConditionItem(
                name: "Curtains",
                selectedCondition: curtains,
                onConditionSelected: (condition) {
                  setState(() {
                    curtains = condition;
                  });
                },
              ),

              //Hard Floopring
              ConditionItem(
                name: "Hard Flooring",
                selectedCondition: hardFlooring,
                onConditionSelected: (condition) {
                  setState(() {
                    hardFlooring = condition;
                  });
                },
              ),

              //Kitchen Area
              ConditionItem(
                name: "Kitchen Area",
                selectedCondition: kitchenArea,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenArea = condition;
                  });
                },
              ),

              //Oven
              ConditionItem(
                name: "Oven",
                selectedCondition: oven,
                onConditionSelected: (condition) {
                  setState(() {
                    oven = condition;
                  });
                },
              ),


              //Mattress
              ConditionItem(
                name: "Mattress",
                selectedCondition: mattress,
                onConditionSelected: (condition) {
                  setState(() {
                    mattress = condition;
                  });
                },
              ),

              //Upholstery
              ConditionItem(
                name: "Upholstery",
                selectedCondition: upholstrey,
                onConditionSelected: (condition) {
                  setState(() {
                    upholstrey = condition;
                  });
                },
              ),

              //Window(s)"
              ConditionItem(
                name: "Window(s)",
                selectedCondition: window,
                onConditionSelected: (condition) {
                  setState(() {
                    window = condition;
                  });
                },
              ),

              //Wall
              ConditionItem(
                name: "Wall(s)",
                selectedCondition: wall,
                onConditionSelected: (condition) {
                  setState(() {
                    wall = condition;
                  });
                },
              ),

              //Wall
              ConditionItem(
                name: "Woodwork",
                selectedCondition: woodwork,
                onConditionSelected: (condition) {
                  setState(() {
                    woodwork = condition;
                  });
                },
              ),


              // Add more ConditionItem widgets as needed
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _showCapturedImages, // Show captured images when clicked
      //   label: Icon(
      //     Icons.image_outlined,
      //     color: bWhite,
      //     size: 24,
      //   ),
      //   backgroundColor: kPrimaryColor,
      //   hoverColor: kPrimaryColor.withOpacity(0.4),
      //   shape: CircleBorder(
      //     side: BorderSide(
      //       color: Colors.white,
      //       width: 2.0,
      //     ),
      //   ),
      //   elevation: 3.0,
      // ),


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
                    onPressed: ()  async{
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

          SizedBox(height: 6,),
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
