import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../constants/AppColors.dart';


class PropertyDetailsViewPage extends StatefulWidget {
  final String status;
  final String addressLineOne;
  final String addressLineTwo;
  final String city;
  final String country;
  final String postalCode;
  final String noOfBeds;
  final String noOfBaths;
  final String keyLocation;
  final String duration;
  final String message;

  const PropertyDetailsViewPage({super.key, required this.status, required this.addressLineOne, required this.addressLineTwo, required this.city, required this.country, required this.postalCode, required this.noOfBeds, required this.noOfBaths, required this.keyLocation, required this.duration, required this.message});

  @override
  State<PropertyDetailsViewPage> createState() => _PropertyDetailsViewPageState();
}

class _PropertyDetailsViewPageState extends State<PropertyDetailsViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 250, // Adjust the height as needed
                  fit: BoxFit.cover, // Adjust the fit as needed (e.g., BoxFit.contain, BoxFit.fill)
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

                            SizedBox(width: 10,),
                            Text(
                              "Active",
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditReportPage()), // Replace HomePage with your home
                          // page widget
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: Text('Edit Report', style: TextStyle(fontSize:
                        12)),
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
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryTextColourTwo,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          "Kurumankandu",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryTextColourTwo,
                          ),
                        ),
                        Text(
                          "Vavuniya",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryTextColourTwo,
                          ),
                        ),
                        Text(
                          "Sri Lanka",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryTextColourTwo,
                          ),
                        ),
                        Text(
                          "43000",
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inspection Date",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryTextColourTwo,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          "30 Aug 2024",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryTextColourTwo,
                          ),
                        ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inspection Type",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryTextColourTwo,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          "Inventory & Check In",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryTextColourTwo,
                          ),
                        ),
                      ],
                    ),
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

                   Expanded(
                     child:  Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           "Inspection Date",
                           style: TextStyle(
                             fontSize: 12.0,
                             fontWeight: FontWeight.w700,
                             color: kPrimaryTextColourTwo,
                           ),
                         ),
                         SizedBox(height: 3.0),
                         Text(
                           "30 Aug 2024",
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
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inspection Type",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryTextColourTwo,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          "Inventory & Check In",
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
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            "Taurgo",
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location of Keys",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryTextColourTwo,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            "With Agent",
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
    );
  }
}
