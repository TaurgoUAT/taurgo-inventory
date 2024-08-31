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


  @override
  Widget build(BuildContext context) {
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandingScreen()),
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
              Icons.arrow_back_ios_new,
              color: kPrimaryColor,
              size: 24,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16, // Horizontal spacing
              mainAxisSpacing: 16, // Vertical spacing
              childAspectRatio: 0.99, // Adjust the aspect ratio
            ),
            itemCount: types.length,
            itemBuilder: (context, index) {
              String type = types[index];
              IconData icon = typeToIconMap[type] ?? Icons.edit_note; // Default icon if not found

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = type;
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Page for $selectedType not yet implemented.'),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 150, // Adjust the width as needed
                  height: 350, // Adjust the height as needed
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: IconButton(
                            icon: Icon(
                              icon,
                              color: kPrimaryColor,
                              size: 24,
                            ),
                            onPressed: () {
                              // Your onPressed functionality here
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        Flexible(
                          child: Text(
                            types[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              );
            },

          ),
        ),
      ),
    );
  }
}
