import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/inspection_confimation_page.dart';
import 'package:taurgo_inventory/pages/reportPages/ExteriorFront.dart';
import 'package:taurgo_inventory/pages/reportPages/bathroom.dart';
import 'package:taurgo_inventory/pages/reportPages/bedroom.dart';
import 'package:taurgo_inventory/pages/reportPages/dining_room.dart';
import 'package:taurgo_inventory/pages/reportPages/ensuite.dart';
import 'package:taurgo_inventory/pages/reportPages/entrance_hallway.dart';
import 'package:taurgo_inventory/pages/reportPages/ev_charger.dart';
import 'package:taurgo_inventory/pages/reportPages/front_garden.dart';
import 'package:taurgo_inventory/pages/reportPages/garage.dart';
import 'package:taurgo_inventory/pages/reportPages/health_and_safety.dart';
import 'package:taurgo_inventory/pages/reportPages/key_handed_over.dart';
import 'package:taurgo_inventory/pages/reportPages/keys.dart';
import 'package:taurgo_inventory/pages/reportPages/kitchen_page.dart';
import 'package:taurgo_inventory/pages/reportPages/landing.dart';
import 'package:taurgo_inventory/pages/reportPages/lounge.dart';
import 'package:taurgo_inventory/pages/reportPages/manuals.dart';
import 'package:taurgo_inventory/pages/reportPages/meter_reading.dart';
import 'package:taurgo_inventory/pages/reportPages/rear_garden.dart';
import 'package:taurgo_inventory/pages/reportPages/receripts.dart';
import 'package:taurgo_inventory/pages/reportPages/schedule_of_condition.dart';
import 'package:taurgo_inventory/pages/reportPages/stairs.dart';
import 'package:taurgo_inventory/pages/reportPages/toilet.dart';
import 'package:taurgo_inventory/pages/reportPages/utility_room.dart';
// Import other pages here
import '../Dtos/AddressDto.dart';
import '../Dtos/PropertyDto.dart';
import '../Dtos/UserDto.dart';
import '../constants/AppColors.dart';
import 'landing_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/UrlConstants.dart';

class EditReportPage extends StatefulWidget {
  final String propertyId;
  const EditReportPage({super.key,  required this.propertyId});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  String? selectedType;
  final Set<String> visitedPages = {}; // Track visited pages
  bool isLoading = true;
  List<Map<String, dynamic>> properties = [];

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final List<String> types = [
      'Schedule of Condition',
      'EV Charger',
      'Meter Reading',
      'Keys',
      "Keys Handed Over At Check In",
      'Health & Safety | Smoke & Carbon Monoxide',
      'Front Garden',
      'Garage',
      'Exterior Front',
      'Entrance / Hallway',
      'Toilet',
      'Lounge',
      'Dining Room',
      'Kitchen',
      'Utility Room / Area',
      'Stairs',
      'Landing',
      'Bedroom 1',
      'En Suite',
      'Bathroom',
      'Rear Garden',
      'Manuals/ Certificates',
      'Property Receipts'
    ];


    final Map<String, Widget> typeToPageMap = {
      'Schedule of Condition': ScheduleOfCondition(propertyId: widget.propertyId),
      'EV Charger': EvCharger(),
      'Meter Reading': MeterReading(propertyId: widget.propertyId,),
      'Keys': Keys(propertyId: widget.propertyId,),
      "Keys Handed Over At Check In": KeyHandedOver(),
      'Health & Safety | Smoke & Carbon Monoxide': HealthAndSafety(),
      'Front Garden': FrontGarden(),
      'Garage': Garage(),
      'Exterior Front': Exteriorfront(),
      'Entrance / Hallway': EntranceHallway(),
      'Toilet': Toilet(),
      'Lounge': Lounge(),
      'Dining Room': DiningRoom(),
      'Kitchen': KitchenPage(),
      'Utility Room / Area': UtilityRoom(),
      'Stairs': Stairs(),
      'Landing': Landing(),
      'Bedroom 1': Bedroom(),
      'En Suite': Ensuite(),
      'Bathroom': Bathroom(),
      'Rear Garden': RearGarden(),
      'Manuals/ Certificates': Manuals(),
    };

    final Map<String, IconData> typeToIconMap = {
      'Schedule of Condition': Icons.schedule,
      'EV Charger': Icons.ev_station,
      'Meter Reading': Icons.electric_meter,
      'Keys': Icons.vpn_key,
      "Keys Handed Over At Check In": Icons.assignment_turned_in,
      'Health & Safety | Smoke & Carbon Monoxide': Icons.health_and_safety,
      'Front Garden': Icons.park,
      'Garage': Icons.garage,
      'Exterior Front': Icons.home,
      'Entrance / Hallway': Icons.door_front_door,
      'Toilet': Icons.wc,
      'Lounge': Icons.living,
      'Dining Room': Icons.dining,
      'Kitchen': Icons.kitchen,
      'Utility Room / Area': Icons.local_laundry_service,
      'Stairs': Icons.stairs,
      'Landing': Icons.flight_land,
      'Bedroom 1': Icons.bed,
      'En Suite': Icons.bathroom,
      'Bathroom': Icons.bathtub,
      'Rear Garden': Icons.garage_outlined,
      'Manuals/ Certificates': Icons.book,
      'Property Receipts': Icons.receipt,
    };
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report',
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
                          print(widget.propertyId);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()),
                          ); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: kPrimaryColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InspectionConfimationPage
                      (propertyId: widget.propertyId,),
                  ),
                );
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
                        'You Cannot make any changes after you save the Property',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InspectionConfimationPage(propertyId:
                                    widget.propertyId,),
                              ),
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
                            'Continue',
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
                  'Preview', // Replace with the actual location
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
        body: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: types.length,
          itemBuilder: (context, index) {
            final type = types[index];
            return GestureDetector(
              onTap: () {
                if (!visitedPages.contains(type)) {
                  visitedPages.add(type);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => typeToPageMap[type]!,
                    ),
                  ).then((_) {
                    setState(() {}); // Update the grid view after returning
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      typeToIconMap[type],
                      size: 50,
                      color: kPrimaryColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      type,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
