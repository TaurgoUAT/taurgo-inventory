import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/property_details_view_page.dart';
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
import '../constants/AppColors.dart';

import 'landing_screen.dart';

class EditReportPage extends StatefulWidget {
  const EditReportPage({super.key});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  String? selectedType;

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

  // Map of types to their corresponding pages
  final Map<String, Widget> typeToPageMap = {
    'Schedule of Condition': ScheduleOfCondition(),
    'EV Charger': EvCharger(),
    'Meter Reading': MeterReading(),
    'Keys': Keys(),
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
    'Property Receipts': Receripts(),
    // Add more mappings here
    // 'EV Charger': EVChargerPage(),
    // 'Meter Reading': MeterReadingPage(),
    // ...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report', // Replace with the actual location
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 14, // Adjust the font size
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
                  builder: (context) => PropertyDetailsViewPage()), // Replace HomePage with
              // your
              // home page widget
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24, // Adjust the icon size
          ),
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                '', // Replace with the actual location
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Set the color of the border
                            width: 1.0, // Set the thickness of the border
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(types[index]),
                        onTap: () {
                          setState(() {
                            selectedType = types[index];
                          });

                          // Navigate to the corresponding page based on the type
                          if (typeToPageMap.containsKey(selectedType)) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  typeToPageMap[selectedType]!),
                            );
                          } else {
                            // Handle the case where the page is not mapped
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Page for $selectedType not yet implemented.'),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
