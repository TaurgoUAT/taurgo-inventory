import 'dart:async';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/deatails_confirmation_page.dart';
import '../constants/AppColors.dart';
import 'package:intl/intl.dart';

import 'landing_screen.dart';
class AddPropertyDetailsPageSecond extends StatefulWidget {

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
  final bool? garage;
  final bool? parking;
  final String? notes;

  const AddPropertyDetailsPageSecond({super.key, this.lineOneAddress, this.lineTwoAddress, this.city, this.state, this.country, this.postalCode, this.reference, this.client, this.type, this.furnishing, this.noOfBeds, this.noOfBaths, this.garage, this.parking, this.notes, });

  @override
  State<AddPropertyDetailsPageSecond> createState() => _AddPropertyDetailsPageSecondState();
}

class _AddPropertyDetailsPageSecondState extends State<AddPropertyDetailsPageSecond> {
  int selectedBedNumber = 1;

  DateTime? _currentDate;
  DateTime? _currentTime;

  String? selectedDate;
  String? selectedTime;

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

  var referenceController = TextEditingController();
  var internalNotesController = TextEditingController();

  void _showCalendar(BuildContext context) {
    DateTime tempPickedDate = _currentDate ?? DateTime.now();

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
                      DateFormat('dd:MM:yyyy').format(tempPickedDate), // Updated date format
                      style: TextStyle(color: kPrimaryColor, fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentDate = tempPickedDate;
                          selectedDate = DateFormat('dd:MM:yyyy').format
                            (tempPickedDate);
                          print(_currentDate.toString());
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: kPrimaryColor, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPickedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      tempPickedDate = newDate;
                    });
                  },
                  maximumDate: DateTime(2050, 12, 30),
                  minimumYear: 2024,
                  // minimumDate: DateTime(2024, 09, 10),
                  maximumYear: 2050,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    DateTime tempPickedTime = _currentTime ?? DateTime.now();


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
                      DateFormat('HH:mm').format(tempPickedTime), // Displaying time in HH:mm format
                      style: TextStyle(color: kPrimaryColor, fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentTime = tempPickedTime;
                          selectedTime = DateFormat('HH:mm').format
                            (tempPickedTime);
                          print(selectedTime);

                          print(DateFormat('HH:mm').format(tempPickedTime));
                          // print(DateFormat('HH:mm').format(_currentTime));
                          print(tempPickedTime.toString());
                          print(_currentTime.toString());
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: kPrimaryColor, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPickedTime,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      tempPickedTime = newTime;
                    });
                  },
                  mode: CupertinoDatePickerMode.time, // Time-only mode
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
              onTap: (){
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
                              MaterialPageRoute(builder: (context) => DetailsConfirmationPage(
                                lineOneAddress: widget.lineOneAddress,
                                lineTwoAddress: widget.lineTwoAddress,
                                city: widget.city,
                                state: widget.state,
                                country: widget.country,
                                postalCode: widget.postalCode,
                                reference: widget.reference,
                                client: widget.client,
                                type: widget.type,
                                furnishing: widget.furnishing,
                                noOfBeds: widget.noOfBeds,
                                noOfBaths: widget.noOfBaths,
                                garage: garageSelected,
                                parking: parkingSelected,
                                notes: widget.notes,
                                selectedType: selectedType.toString(),
                                date: selectedDate,
                                time: selectedTime,
                                keyLocation: keysIwth.toString(),
                                referenceForKey: referenceController.text,
                                internalNotes: internalNotesController.text,
                              )),
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
                    "Further Details",
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
                    "Inspection Type",
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
                        Row(
                          children: [
                            Text(
                              selectedDate ?? 'Select Date',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14.0,
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

                        ],)

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
                        Row(
                          children: [
                            Text(
                              selectedTime ?? 'Select Time',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14.0,
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
                    controller: referenceController,
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
                    controller: internalNotesController,
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
      ),
    );
  }
}
