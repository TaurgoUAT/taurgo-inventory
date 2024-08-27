import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/add_property_details_page_second.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../constants/AppColors.dart';

class AddPropertyDetailsPage extends StatefulWidget {
  const AddPropertyDetailsPage({super.key});

  @override
  State<AddPropertyDetailsPage> createState() => _AddPropertyDetailsPageState();
}

class _AddPropertyDetailsPageState extends State<AddPropertyDetailsPage> {
  int selectedBedNumber = 1;

  bool parkingSelected = false;
  bool garageSelected = false;
  bool locationEnabled = false;

  var addressLineOneController = TextEditingController();
  var addressLineTwoController = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();
  var postCodeController = TextEditingController();

  // var typeController = TextEditingController();
  // var addressLineTwoController = TextEditingController();
  // var cityController = TextEditingController();
  // var countryController = TextEditingController();
  // var postCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Inspection', // Replace with the actual location
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LandingScreen()), // Replace HomePage with your home page widget
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo/Taurgo Logo.png', // Path to your company icon
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPropertyDetailsPageSecond()),
              );
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Next', // Replace with the actual location
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Create Property",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
              ),
              SizedBox(height: 12.0),

              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
              ),
              SizedBox(height: 12.0),

              //Line One
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Line 1",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //Line two
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Line 2",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //City
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "City",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //Country
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Country",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //Postal Code
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Postal Code",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              SizedBox(height: 12.0),

              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
              ),
              SizedBox(height: 12.0),
              //Refernece
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Referenece",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //Client
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Client",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //Type
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Type",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              //Beds
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Beds",
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: kSecondaryTextColourTwo,
                      ),
                    ),
                    DropdownButton<int>(
                      iconSize: 24,
                      dropdownColor: bWhite,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      value: selectedBedNumber, // the selected value
                      items: List.generate(10, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}', style: TextStyle(
                            color: kPrimaryColor
                          ),),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedBedNumber = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              //Baths
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Baths",
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: kSecondaryTextColourTwo,
                      ),
                    ),
                    DropdownButton<int>(
                      iconSize: 24,
                      dropdownColor: bWhite,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      value: selectedBedNumber, // the selected value
                      items: List.generate(10, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}', style: TextStyle(
                              color: kPrimaryColor
                          ),),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedBedNumber = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Garage
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Garage',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: kSecondaryTextColourTwo,
                      ),
                    ),
                    Switch(
                      value: garageSelected,
                      onChanged: (bool value) {
                        setState(() {
                          garageSelected = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),

// Parking (Baths)
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Parking',
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: kSecondaryTextColourTwo,
                      ),
                    ),
                    Switch(
                      value: parkingSelected,
                      onChanged: (bool value) {
                        setState(() {
                          parkingSelected = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),


              //Notes
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Notes",
                    labelStyle: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 11,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ),
              ),

              SizedBox(height: 30.0),




            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: bWhite,
        height: 36,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),

                  ),
                  SizedBox(width: 5,),
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(

                      color: bWhite,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(25.0),
                    ),

                  ),
                  SizedBox(width: 5,),
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(

                      color: bWhite,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(25.0),
                    ),

                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
