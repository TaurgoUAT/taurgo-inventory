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
  int selectedBedNumber = 0;
  int selectedBathsNumber = 0;

  bool parkingSelected = false;
  bool garageSelected = false;
  bool locationEnabled = false;

  var addressLineOneController = TextEditingController();
  var addressLineTwoController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var postCodeController = TextEditingController();

  var referenceController = TextEditingController();
  var clientController = TextEditingController();
  var notesController = TextEditingController();

  String? selectedFurnishing; // Variable to hold the selected furnishing option
  String? selectedType;

  final List<String> furnishing = [
    'Unfurnished',
    'Partially Unfurnished',
    'Fully Unfurnished',
  ];

  final List<String> type = [
    'Apartment',
    'Bedsit',
    'Bungalow',
    'Cottage',
    'House',
    'Maisonette',
    'Mansion',
    'Flat - Purpose Buile',
    'Flat - Converted',
    'Studio Apartment',
    'Tenement',
    'Commercial',
    'Condominium',
    'Duplex',
    'Retail',
    'Industrial',
    'Office',
    'Room',
    'HMO',
    'Barn',
    'Restaurant',
    'Bar',
    'Warehouse',
    'Storage',
    'Government',
    'Public Space',
    'Multi-Unit Building',
    'Mobile Home',
    'Other',
  ];

  bool _validateInputs() {
    if (addressLineOneController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        countryController.text.isEmpty ||
        postCodeController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
            leading: IconButton(
              icon: Icon(
                Icons.close_sharp,
                color: kPrimaryColor,
              ),
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
                                      LandingScreen()), // Replace HomePage with your home page
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
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (_validateInputs()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPropertyDetailsPageSecond(
                            lineOneAddress: addressLineOneController.text,
                            lineTwoAddress: addressLineTwoController.text,
                            city: cityController.text,
                            state: stateController.text,
                            country: countryController.text,
                            postalCode: postCodeController.text,
                            reference: referenceController.text,
                            client: clientController.text,
                            type: selectedType.toString(),
                            furnishing: selectedFurnishing.toString(),
                            noOfBeds: selectedBedNumber.toString(),
                            noOfBaths: selectedBathsNumber.toString(),
                            garage: garageSelected,
                            parking: parkingSelected,
                            notes: notesController.text,
                          )),
                    );
                  } else {
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
                                'Missing Information',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Please fill in all mandatory fields before proceeding.',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
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
                                'OK',
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
                  }
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
            ]),

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

                // Padding(
                //   padding: EdgeInsets.all(0),
                //   child: Text(
                //     "* Required Filds",
                //     style: TextStyle(
                //       fontSize: 11.0,
                //       fontWeight: FontWeight.w700,
                //       color: kPrimaryColor,
                //     ),
                //   ),
                // ),

                //Line One
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: addressLineOneController,
                    decoration: InputDecoration(
                      labelText: "Line 1 *",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    controller: addressLineTwoController,
                    decoration: InputDecoration(
                      labelText: "Line 2",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: "City *",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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

                //State
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: stateController,
                    decoration: InputDecoration(
                      labelText: "State *",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    controller: countryController,
                    decoration: InputDecoration(
                      labelText: "Country *",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    controller: postCodeController,
                    decoration: InputDecoration(
                      labelText: "Postal Code *",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    "Details",
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
                //Refernece
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: referenceController,
                    decoration: InputDecoration(
                      labelText: "Referenece",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    controller: clientController,
                    decoration: InputDecoration(
                      labelText: "Client",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                //Type Text
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Type *",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                ),

                SizedBox(height: 12.0),

                Padding(
                  padding: EdgeInsets.all(0),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: bWhite,
                    value: selectedType,
                    hint: Text('Select Property Type'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: kPrimaryColor,
                    ),
                    items: type.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              type,
                              style: TextStyle(
                                color: kPrimaryTextColour,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue;
                      });
                    },
                  ),
                ),

                //Furnishing
                SizedBox(height: 12.0),
                //Type Text
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Furnishing",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                ),

                SizedBox(height: 12.0),

                Padding(
                  padding: EdgeInsets.all(0),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: bWhite,
                    value: selectedFurnishing,
                    hint: Text('Furnishing'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: kPrimaryColor,
                    ),
                    items: furnishing.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              type,
                              style: TextStyle(
                                color: kPrimaryTextColour,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFurnishing = newValue;
                      });
                    },
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
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryTextColourTwo,
                        ),
                      ),
                      DropdownButton<int>(
                        iconSize: 24,
                        dropdownColor: bWhite,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        value: selectedBedNumber,
                        // Ensure this value exists in the items list
                        items: List.generate(11, (index) {
                          return DropdownMenuItem<int>(
                            value: index, // No duplicates in this list
                            child: Text(
                              '$index',
                              style: TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                          );
                        }),
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
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryTextColourTwo,
                        ),
                      ),
                      DropdownButton<int>(
                        iconSize: 24,
                        dropdownColor: bWhite,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        value: selectedBathsNumber,
                        // Ensure this value exists in the items list
                        items: List.generate(11, (index) {
                          return DropdownMenuItem<int>(
                            value: index, // No duplicates in this list
                            child: Text(
                              '$index',
                              style: TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                          );
                        }),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedBathsNumber = newValue!;
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
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryTextColourTwo,
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
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryTextColourTwo,
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
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: "Notes",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
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
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 12,
                      width: 60,
                      decoration: BoxDecoration(
                        color: bWhite,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
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
      ),

    );
  }
}
