import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/deatails_confirmation_page.dart';
import '../constants/AppColors.dart';
import 'package:intl/intl.dart';

import 'landing_screen.dart';
class AddPropertyDetailsPageSecond extends StatefulWidget {
  const AddPropertyDetailsPageSecond({super.key});

  @override
  State<AddPropertyDetailsPageSecond> createState() => _AddPropertyDetailsPageSecondState();
}

class _AddPropertyDetailsPageSecondState extends State<AddPropertyDetailsPageSecond> {
  int selectedBedNumber = 1;

  DateTime? _currentdate;
  String? selectedType;
  String? keysIwth;

  Map<String, String>? selectedPackage;
  final List<String> types = [
    'Inventory & Schedule of Condition',
    'Check In',
    'Standalone Inspection',
    'Update',
    "Checkout",
    'Inventory & Check In',
    'Risk Assessment',
    'Midterm Inventory',
    'Self Service Inspection'
  ];

  final List<String> keys = [
    'With Inspector',
    'With Agent',
    'With Landlord',
    'With Tenant',
    'At property'
  ];

  bool parkingSelected = true;
  bool garageSelected = true;
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

  void _showCalendar(BuildContext context) {
    DateTime tempPickedDate = _currentdate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM, dd yyyy').format(tempPickedDate),
                      style: TextStyle(color: Colors.blue, fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentdate = tempPickedDate;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.blue, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPickedDate,
                  onDateTimeChanged: (DateTime newdate) {
                    setState(() {
                      tempPickedDate = newdate;
                    });
                  },
                  use24hFormat: true, // This is not necessary for date-only mode, but kept here for completeness
                  maximumDate: DateTime(2050, 12, 30),
                  minimumYear: 2024,
                  maximumYear: 2050,
                  minuteInterval: 1, // This is not used in date-only mode but kept here for completeness
                  mode: CupertinoDatePickerMode.date, // Change mode to date-only
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    DateTime tempPickedDate = _currentdate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM, dd yyyy').format(tempPickedDate),
                      style: TextStyle(color: Colors.blue, fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentdate = tempPickedDate;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.blue, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPickedDate,
                  onDateTimeChanged: (DateTime newdate) {
                    setState(() {
                      tempPickedDate = newdate;
                    });
                  },
                  mode: CupertinoDatePickerMode.time, // Set mode to time-only
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
          child: Icon(
            Icons.close_sharp,
            color: kPrimaryColor,
            size: 24, // Adjust the icon size
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsConfirmationPage()),
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





              //Type Text
              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Type",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryTextColourTwo,
                  ),
                ),
              ),

              SizedBox(height: 12.0),

              //Type
              Padding(
                padding: EdgeInsets.all(0),
                child:  DropdownButtonFormField<String>(
                  dropdownColor: bWhite,
                  value: selectedType,
                  hint: Text('Select Type'),
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
                    contentPadding: EdgeInsets.all(5
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: kPrimaryColor,
                  ),
                  items: types.map((String type) {
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
                      selectedPackage = null; // Reset the selected package
                    });
                  },
                ),
              ),
              // SizedBox(height: 12.0),

              // //Title Text
              // Padding(
              //   padding: EdgeInsets.all(0),
              //   child: Text(
              //     "Title",
              //     style: TextStyle(
              //       fontSize: 14.0,
              //       fontWeight: FontWeight.w700,
              //       color: kPrimaryTextColourTwo,
              //     ),
              //   ),
              // ),
              //
              // SizedBox(height: 12.0),
              //
              // //Title
              // Padding(
              //   padding: EdgeInsets.all(0),
              //   child:  DropdownButtonFormField<String>(
              //     dropdownColor: bWhite,
              //     value: selectedType,
              //     hint: Text('Select a package type'),
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         borderSide: BorderSide(
              //           color: kPrimaryColor,
              //           width: 1.5,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         borderSide: BorderSide(
              //           color: kPrimaryColor,
              //           width: 1.5,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         borderSide: BorderSide(
              //           color: kPrimaryColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       contentPadding: EdgeInsets.all(5
              //       ),
              //     ),
              //     icon: Icon(
              //       Icons.arrow_drop_down,
              //       color: kPrimaryColor,
              //     ),
              //     items: types.map((String type) {
              //       return DropdownMenuItem<String>(
              //         value: type,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //           child: Align(
              //             alignment: Alignment.centerLeft,
              //             child: Text(
              //               type,
              //               style: TextStyle(
              //                 color: kPrimaryTextColour,
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w500,
              //                 fontFamily: "Inter",
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         selectedType = newValue;
              //         selectedPackage = null; // Reset the selected package
              //       });
              //     },
              //   ),
              // ),


              //Template Texrt
              // Padding(
              //   padding: EdgeInsets.all(0),
              //   child: Text(
              //     "Template",
              //     style: TextStyle(
              //       fontSize: 14.0,
              //       fontWeight: FontWeight.w700,
              //       color: kPrimaryTextColourTwo,
              //     ),
              //   ),
              // ),
              //
              // SizedBox(height: 6.0),
              // //Template
              // Padding(
              //   padding: EdgeInsets.all(0),
              //   child:  DropdownButtonFormField<String>(
              //     dropdownColor: bWhite,
              //     value: selectedType,
              //     hint: Text('Select a package type'),
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         borderSide: BorderSide(
              //           color: kPrimaryColor,
              //           width: 1.5,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         borderSide: BorderSide(
              //           color: kPrimaryColor,
              //           width: 1.5,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         borderSide: BorderSide(
              //           color: kPrimaryColor,
              //           width: 2.0,
              //         ),
              //       ),
              //       contentPadding: EdgeInsets.all(5
              //       ),
              //     ),
              //     icon: Icon(
              //       Icons.arrow_drop_down,
              //       color: kPrimaryColor,
              //     ),
              //     items: types.map((String type) {
              //       return DropdownMenuItem<String>(
              //         value: type,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //           child: Align(
              //             alignment: Alignment.centerLeft,
              //             child: Text(
              //               type,
              //               style: TextStyle(
              //                 color: kPrimaryTextColour,
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w500,
              //                 fontFamily: "Inter",
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         selectedType = newValue;
              //         selectedPackage = null; // Reset the selected package
              //       });
              //     },
              //   ),
              // ),
              SizedBox(height: 12.0),


              //Date
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryTextColourTwo,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        size: 24,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        _showCalendar(context);
                      },
                    ),
                  ],
                )
              ),

              //Time
              Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryTextColourTwo,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.watch_later_outlined,
                          size: 24,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          _showTimePicker(context);
                        },
                      ),
                    ],
                  )
              ),

              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Keys With",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryTextColourTwo,
                  ),
                ),
              ),
              SizedBox(height: 12.0),

              //Keys
              Padding(
                padding: EdgeInsets.all(0),
                child:  DropdownButtonFormField<String>(
                  dropdownColor: bWhite,
                  value: keysIwth,
                  hint: Text('Key Location'),
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
                    contentPadding: EdgeInsets.all(5
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: kPrimaryColor,
                  ),
                  items: keys.map((String type) {
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
                      keysIwth = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 12.0),


              //Line One
              Padding(
                padding: EdgeInsets.all(0.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Reference",
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
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: "Internal Notes",
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
