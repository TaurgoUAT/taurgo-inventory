import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/widgets/add_action.dart';
import '../../constants/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/reportPages/camera_preview_page.dart'; // Import shared_preferences

class ScheduleOfCondition extends StatefulWidget {
  final List<File>? capturedImages;
  final String propertyId;

  const ScheduleOfCondition({super.key, this.capturedImages, required this
      .propertyId});

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
  List<String> overviewImages = [];
  List<String> accessoryCleanlinessImages = [];
  List<String> windowSillImages = [];
  List<String> carpetsImages = [];
  List<String> ceilingsImages = [];
  List<String> curtainsImages = [];
  List<String> hardFlooringImages = [];
  List<String> kitchenAreaImages = [];
  List<String> ovenImages = [];
  List<String> mattressImages = [];
  List<String> upholstreyImages = [];
  List<String> wallImages = [];
  List<String> windowImages = [];
  List<String> woodworkImages = [];

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
      overview = prefs.getString('overview_${propertyId}');

          accessoryCleanliness = prefs.getString('accessoryCleanliness_${propertyId}');
          windowSill = prefs.getString('windowSill_${propertyId}');
          carpets = prefs.getString('carpets_${propertyId}');
          ceilings = prefs.getString('ceilings_${propertyId}');
          curtains = prefs.getString('curtains_${propertyId}');
          hardFlooring = prefs.getString('hardFlooring_${propertyId}');
          kitchenArea = prefs.getString('kitchenArea_${propertyId}');
          oven = prefs.getString('oven_${propertyId}');
          mattress = prefs.getString('mattress_${propertyId}');
          upholstrey = prefs.getString('upholstrey_${propertyId}');
          wall = prefs.getString('wall_${propertyId}');
          window = prefs.getString('window_${propertyId}');
          woodwork = prefs.getString('woodwork_${propertyId}');


      overviewImages = prefs.getStringList('overviewImages_${propertyId}') ?? [];
          accessoryCleanlinessImages =
              prefs.getStringList('accessoryCleanlinessImages_${propertyId}') ?? [];
          windowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
          carpetsImages = prefs.getStringList('carpetsImages_${propertyId}') ?? [];
          ceilingsImages = prefs.getStringList('ceilingsImages_${propertyId}') ?? [];
          curtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
          hardFlooringImages = prefs.getStringList('hardFlooringImages_${propertyId}') ?? [];
          kitchenAreaImages = prefs.getStringList('kitchenAreaImages_${propertyId}') ?? [];
          ovenImages = prefs.getStringList('ovenImages_${propertyId}') ?? [];
          mattressImages = prefs.getStringList('mattressImages_${propertyId}') ?? [];
          upholstreyImages = prefs.getStringList('upholstreyImages_${propertyId}') ?? [];
          wallImages = prefs.getStringList('wallImages_${propertyId}') ?? [];
          windowImages = prefs.getStringList('windowImages_${propertyId}') ?? [];
          woodworkImages = prefs.getStringList('woodworkImages_${propertyId}') ?? [];
    });
  }
  // Function to load preferences
  // Future<void> _loadPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     overview = prefs.getString('overview');
  //     accessoryCleanliness = prefs.getString('accessoryCleanliness');
  //     windowSill = prefs.getString('windowSill');
  //     carpets = prefs.getString('carpets');
  //     ceilings = prefs.getString('ceilings');
  //     curtains = prefs.getString('curtains');
  //     hardFlooring = prefs.getString('hardFlooring');
  //     kitchenArea = prefs.getString('kitchenArea');
  //     oven = prefs.getString('oven');
  //     mattress = prefs.getString('mattress');
  //     upholstrey = prefs.getString('upholstrey');
  //     wall = prefs.getString('wall');
  //     window = prefs.getString('window');
  //     woodwork = prefs.getString('woodwork');
  //
  //     overviewImages = prefs.getStringList('overviewImages') ?? [];
  //     accessoryCleanlinessImages =
  //         prefs.getStringList('accessoryCleanlinessImages') ?? [];
  //     windowSillImages = prefs.getStringList('windowSillImages') ?? [];
  //     carpetsImages = prefs.getStringList('carpetsImages') ?? [];
  //     ceilingsImages = prefs.getStringList('ceilingsImages') ?? [];
  //     curtainsImages = prefs.getStringList('curtainsImages') ?? [];
  //     hardFlooringImages = prefs.getStringList('hardFlooringImages') ?? [];
  //     kitchenAreaImages = prefs.getStringList('kitchenAreaImages') ?? [];
  //     ovenImages = prefs.getStringList('ovenImages') ?? [];
  //     mattressImages = prefs.getStringList('mattressImages') ?? [];
  //     upholstreyImages = prefs.getStringList('upholstreyImages') ?? [];
  //     wallImages = prefs.getStringList('wallImages') ?? [];
  //     windowImages = prefs.getStringList('windowImages') ?? [];
  //     woodworkImages = prefs.getStringList('woodworkImages') ?? [];
  //   });
  // }

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
              // Overview
              ConditionItem(
                name: "Overview",
                condition: overview,
                description: overview,
                images: overviewImages,
                onConditionSelected: (condition) {
                  setState(() {
                    overview = condition;
                  });
                  _savePreference(propertyId, 'overview', condition!);
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    overview = description;
                  });
                  _savePreference(propertyId, 'overview', description!);
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    overviewImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId, 'overviewImages', overviewImages);
                },
              ),



              // Accessory Cleanliness
              ConditionItem(
                name: "Accessory - Cleanliness",
                condition: accessoryCleanliness,
                description: accessoryCleanliness,
                images: accessoryCleanlinessImages,
                onConditionSelected: (condition) {
                  setState(() {
                    accessoryCleanliness = condition;
                  });
                  _savePreference(propertyId,
                      'accessoryCleanliness', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    accessoryCleanliness = description;
                  });
                  _savePreference(propertyId,
                      'accessoryCleanliness', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    accessoryCleanlinessImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'accessoryCleanlinessImages',
                      accessoryCleanlinessImages); // Save preference
                },
              ),

              // Window Sill
              ConditionItem(
                name: "Window Sill",
                condition: windowSill,
                description: windowSill,
                images: windowSillImages,
                onConditionSelected: (condition) {
                  setState(() {
                    windowSill = condition;
                  });
                  _savePreference(propertyId,'windowSill', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    windowSill = description;
                  });
                  _savePreference(propertyId,
                      'windowSill', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowSillImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'windowSillImages', windowSillImages); // Save preference
                },
              ),

              // Carpets
              ConditionItem(
                name: "Carpets",
                condition: carpets,
                description: carpets,
                images: carpetsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    carpets = condition;
                  });
                  _savePreference(propertyId,'carpets', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    carpets = description;
                  });
                  _savePreference(propertyId,'carpets', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    carpetsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'carpetsImages', carpetsImages); // Save preference
                },
              ),

              // Ceilings
              ConditionItem(
                name: "Ceilings",
                condition: ceilings,
                description: ceilings,
                images: ceilingsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    ceilings = condition;
                  });
                  _savePreference(propertyId,'ceilings', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    ceilings = description;
                  });
                  _savePreference(propertyId,'ceilings', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ceilingsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'ceilingsImages', ceilingsImages); // Save preference
                },
              ),

              // Curtains
              ConditionItem(
                name: "Curtains",
                condition: curtains,
                description: curtains,
                images: curtainsImages,
                onConditionSelected: (condition) {
                  setState(() {
                    curtains = condition;
                  });
                  _savePreference(propertyId,'curtains', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    curtains = description;
                  });
                  _savePreference(propertyId,'curtains', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    curtainsImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'curtainsImages', curtainsImages); // Save preference
                },
              ),

              // Hard Flooring
              ConditionItem(
                name: "Hard Flooring",
                condition: hardFlooring,
                description: hardFlooring,
                images: hardFlooringImages,
                onConditionSelected: (condition) {
                  setState(() {
                    hardFlooring = condition;
                  });
                  _savePreference(propertyId,
                      'hardFlooring', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    hardFlooring = description;
                  });
                  _savePreference(propertyId,
                      'hardFlooring', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    hardFlooringImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'hardFlooringImages',
                      hardFlooringImages); // Save preference
                },
              ),

              // Kitchen Area
              ConditionItem(
                name: "Kitchen Area",
                condition: kitchenArea,
                description: kitchenArea,
                images: kitchenAreaImages,
                onConditionSelected: (condition) {
                  setState(() {
                    kitchenArea = condition;
                  });
                  _savePreference(propertyId,'kitchenArea', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    kitchenArea = description;
                  });
                  _savePreference(propertyId,
                      'kitchenArea', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    kitchenAreaImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,'kitchenAreaImages',
                      kitchenAreaImages); // Save preference
                },
              ),

              // Oven
              ConditionItem(
                name: "Oven",
                condition: oven,
                description: oven,
                images: ovenImages,
                onConditionSelected: (condition) {
                  setState(() {
                    oven = condition;
                  });
                  _savePreference(propertyId,'oven', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    oven = description;
                  });
                  _savePreference(propertyId,'oven', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    ovenImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'ovenImages', ovenImages); // Save preference
                },
              ),

              // Mattress
              ConditionItem(
                name: "Mattress",
                condition: mattress,
                description: mattress,
                images: mattressImages,
                onConditionSelected: (condition) {
                  setState(() {
                    mattress = condition;
                  });
                  _savePreference(propertyId,'mattress', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    mattress = description;
                  });
                  _savePreference(propertyId,'mattress', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    mattressImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'mattressImages', mattressImages); // Save preference
                },
              ),

              // Upholstrey
              ConditionItem(
                name: "Upholstrey",
                condition: upholstrey,
                description: upholstrey,
                images: upholstreyImages,
                onConditionSelected: (condition) {
                  setState(() {
                    upholstrey = condition;
                  });
                  _savePreference(propertyId,'upholstrey', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    upholstrey = description;
                  });
                  _savePreference(propertyId,
                      'upholstrey', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    upholstreyImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'upholstreyImages', upholstreyImages); // Save preference
                },
              ),

              // Wall
              ConditionItem(
                name: "Wall",
                condition: wall,
                description: wall,
                images: wallImages,
                onConditionSelected: (condition) {
                  setState(() {
                    wall = condition;
                  });
                  _savePreference(propertyId,'wall', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    wall = description;
                  });
                  _savePreference(propertyId,'wall', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    wallImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'wallImages', wallImages); // Save preference
                },
              ),
              // Window
              ConditionItem(
                name: "Window",
                condition: window,
                description: window,
                images: windowImages,
                onConditionSelected: (condition) {
                  setState(() {
                    window = condition;
                  });
                  _savePreference(propertyId,'window', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    window = description;
                  });
                  _savePreference(propertyId,'window', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    windowImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'windowImages', windowImages); // Save preference
                },
              ),

              // Woodwork
              ConditionItem(
                name: "Woodwork",
                condition: woodwork,
                description: woodwork,
                images: woodworkImages,
                onConditionSelected: (condition) {
                  setState(() {
                    woodwork = condition;
                  });
                  _savePreference(propertyId,'woodwork', condition!); // Save preference
                },
                onDescriptionSelected: (description) {
                  setState(() {
                    woodwork = description;
                  });
                  _savePreference(propertyId,'woodwork', description!); // Save preference
                },
                onImageAdded: (imagePath) {
                  setState(() {
                    woodworkImages.add(imagePath);
                  });
                  _savePreferenceList(propertyId,
                      'woodworkImages', woodworkImages); // Save preference
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
// Import shared_preferences

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
