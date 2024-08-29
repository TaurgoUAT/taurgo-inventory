import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../constants/AppColors.dart';
import '../constants/AppColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/UrlConstants.dart';
class PropertyDetailsViewPage extends StatefulWidget {
  final String? status;
  final String? propertyId;
  final String? lineOneAddress;
  final String? lineTwoAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? reference;
  final String? client;
  final String? type;
  final String? furnishing;
  final String? noOfBeds;
  final String? noOfBaths;
  final String? garage;
  final String? parking;
  final String? notes;

  final String? selectedType;
  final String? date;
  final String? time;
  final String? keyLocation;
  final String? referenceForKey;
  final String? internalNotes;
  const PropertyDetailsViewPage(
      {super.key, this.status
        , this.propertyId,this.lineOneAddress, this.lineTwoAddress, this.city,
        this.state, this.country, this.postalCode, this.reference, this.client, this.type, this.furnishing, this.noOfBeds, this.noOfBaths, this.garage, this.parking, this.notes, this.selectedType, this.date, this.time, this.keyLocation, this.referenceForKey, this.internalNotes,});

  @override
  State<PropertyDetailsViewPage> createState() =>
      _PropertyDetailsViewPageState();
}

class _PropertyDetailsViewPageState extends State<PropertyDetailsViewPage> {
  List<Map<String, dynamic>> completedProperties = [];
  List<Map<String, dynamic>> pendingProperties = [];
  bool isLoading = true;
  String filterOption = 'All'; // Initial filter option
  List<Map<String, dynamic>> filteredProperties = [];
  List<Map<String, dynamic>> properties = [];



  // @override
  // void initState() {
  //   super.initState();
  //   fetchProperties();
  // }

  // Future<void> fetchProperties() async {
  //   try {
  //     final response = await http.get(Uri.parse('$baseURL/property/${widget.propertyId}'));
  //
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       if (mounted) {
  //         setState(() {
  //           widget.lineOneAddress = data['lineOneAddress'];
  //           widget.lineTwoAddress = data['lineTwoAddress'];
  //           widget.city = data['city'];
  //           widget.state = data['state'];
  //           widget.country = data['country'];
  //           widget.postalCode = data['postalCode'];
  //           widget.status = data['status'];
  //           widget.selectedType = data['selectedType'];
  //           widget.date = data['date'];
  //           widget.time = data['time'];
  //           // ... continue mapping other fields as needed
  //           isLoading = false;
  //           // properties =
  //           //     data.map((item) => item as Map<String, dynamic>).toList();
  //           // filteredProperties = properties;
  //           // isLoading = false;
  //         });
  //       }
  //     } else {
  //       print("Failed to load properties: ${response.statusCode}");
  //       if (mounted) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Error fetching properties: $e");
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Inspection Info', // Replace with the actual location
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
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           Homepage()), // Replace HomePage with your home page widget
              // );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LandingScreen()), // Replace HomePage with your home page
                    // widget
                  );
                },
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: kPrimaryColor,
              ),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           Helpandsupportpage()), // Replace HomePage with your home page widget
                // );
              },
            ),
          ],
        ),
        body: Container(
          color: bWhite,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/images/prop-img.png', // Replace with your image path
                    width: double.maxFinite, // Adjust the width as needed
                    height: 220, // Adjust the height as needed
                    fit: BoxFit
                        .cover, // Adjust the fit as needed (e.g., BoxFit.contain, BoxFit.fill)
                  ),
                ),

                SizedBox(height: 15.0),

                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Inspection state",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kActiveButtonColour,
                                ),
                                padding: EdgeInsets.all(16.0),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.status ?? "N/A",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 2, // Thickness of the divider
                          height: 30, // Adjust the height as needed
                          color: Color(0xFFC2C2C2), // Divider color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
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
                                      'Sync information',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Please Make Sure you have stable internet before continue, Your process will not be saved if you exit the Process',
                                  textAlign: TextAlign.left,
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditReportPage()), // Replace HomePage
                                        // with your home page
                                        // widget
                                      ); // Close the dialog
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
                                      'Agree',
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
                        child: Padding(
                          padding: const EdgeInsets.all(7.5),
                          child:
                          Text('Edit Report', style: TextStyle(fontSize: 12)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                ),

//Address
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            widget.lineOneAddress ?? "",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),
                          Text(
                            widget.lineTwoAddress ?? "",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),


                          Row(
                            children: [
                              Text(
                                widget.city ?? "",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                              Text(
                                ",",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                              SizedBox(width: 2,),
                              Text(
                                widget.state ?? "",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.country ?? "",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),


                          Text(
                            widget.postalCode ?? "",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),
                        ],
                      ),


                      IconButton(
                        icon: Icon(
                          Icons.navigation,
                          size: 36,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          // _showFilterOptions(context);
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                ),


                //Date and Type
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Inspection Date",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            widget.date ?? "N/A",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),
                        ],
                      ),),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 2, // Thickness of the divider
                          height: 30, // Adjust the height as needed
                          color: Color(0xFFC2C2C2), // Divider color
                        ),
                      ),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Inspection Time",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            widget.time ?? "N/A",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),
                        ],
                      ),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                ),

                //Rooms and  and Furnishning
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Inspection Type",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            widget.selectedType ?? "N/A",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),
                        ],
                      ),),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 2, // Thickness of the divider
                          height: 30, // Adjust the height as needed
                          color: Color(0xFFC2C2C2), // Divider color
                        ),
                      ),

                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "General",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Row(
                            children: <Widget>[
                              Icon(Icons.bed, size: 20.0, color: kPrimaryColor),
                              SizedBox(width: 4.0),
                              Text(
                                widget.noOfBeds ?? "N/A",
                                style: TextStyle(fontSize: 14.0, color: kPrimaryColor),
                              ),
                              SizedBox(width: 16.0),
                              Icon(Icons.bathtub, size: 20.0, color: kPrimaryColor),
                              SizedBox(width: 4.0),
                              Text(
                                widget.noOfBaths ?? "N/A",
                                style: TextStyle(fontSize: 14.0, color: kPrimaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                ),

                //Client and Key Location
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Client",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryTextColourTwo,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              widget.client ?? "N/A",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: kSecondaryTextColourTwo,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 2, // Thickness of the divider
                          height: 30, // Adjust the height as needed
                          color: Color(0xFFC2C2C2), // Divider color
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location of Keys",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryTextColourTwo,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              widget.keyLocation ?? "N/A",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: kSecondaryTextColourTwo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                ),
                Spacer(),

                Center(
                  child: GestureDetector(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 0.0, top: 0),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          "Sync",
                          // The text you want to display
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16.0, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
