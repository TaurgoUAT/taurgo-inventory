import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/add_property_details_page_second.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../constants/AppColors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/UrlConstants.dart';
class EditDetailsPage extends StatefulWidget {
  final String propertyId;
  const EditDetailsPage({super.key, required this.propertyId});

  @override
  State<EditDetailsPage> createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
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

  final List<String> furnishing = [
    'Unfurnished',
    'Partially Unfurnished',
    'Fully Unfurnished',
  ];
  String? selectedType;
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


  DateTime? _currentDate;
  DateTime? _currentTime;

  String? selectedDate;
  String? selectedTime;

  String? selectedInventoryType;
  String? keysIwth;

  final List<String> inventoryType = [
    'Inventory & Schedule of Condition',
    'Check In',
    "Checkout",
    'Inventory & Check In',
    'Risk Assessment',
  ];

  final List<String> keys = [
    'With Inspector',
    'With Agent',
    'With Landlord',
    'With Tenant',
    'At property'
  ];

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
  bool isLoading = true;
  List<Map<String, dynamic>> properties = [];


  @override
  void initState() {
    super.initState();
    fetchProperties();
    print(widget.propertyId);
  }

  Future<void> fetchProperties() async {
    setState(() {
      isLoading = true;
    });

    String propertyId = widget.propertyId;

    try {
      final response = await http.get(Uri.parse('$baseURL/property/$propertyId'))
          .timeout(Duration(seconds: 60)); // Set the timeout duration

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties = data.map((item) => item as Map<String, dynamic>).toList();
          if (properties.isNotEmpty) {
            // Initialize the controller once data is fetched
            addressLineOneController = TextEditingController(
                text: properties[0]['addressLineOne'] ?? ''
            );

            addressLineTwoController = TextEditingController(
                text: properties[0]['addressLineTwo'] ?? ''
            );

            cityController = TextEditingController(
                text: properties[0]['city'] ?? ''
            );

            stateController = TextEditingController(
                text: properties[0]['state'] ?? ''
            );

            countryController = TextEditingController(
                text: properties[0]['country'] ?? ''
            );

            postCodeController = TextEditingController(
                text: properties[0]['postalCode'] ?? ''
            );

            //Additional Details
            referenceController = TextEditingController(
                text: properties[0]['ref'] ?? ''
            );

            clientController = TextEditingController(
                text: properties[0]['client'] ?? ''
            );

            //Type
            selectedType = type.contains(properties[0]['type']) ? properties[0]['type'] : null;
            //Furnishing
            selectedFurnishing = furnishing.contains(properties[0]['furnishing']) ? properties[0]['furnishing']
                : null;
            //Beds
            selectedBedNumber = properties[0]['noOfBeds'];
            //Baths
            //Garage
            //Parking
            //Notes
            // notesController = TextEditingController(
            //     text: properties[0]['client'] ?? ''
            // );
            //Ins Type
            selectedInventoryType = inventoryType.contains
              (properties[0]['inspectionType']) ?
            properties[0]['inspectionType']
                : null;
            //Date
            selectedDate = properties[0]['date'];
            //Time
            selectedTime = properties[0]['time'];
            //Key With
            keysIwth = keys.contains(properties[0]['keyLocation']) ?
            properties[0]['keyLocation']
                : null;
            //Key Location
            //Add Notes
            notesController = TextEditingController(
                text: properties[0]['internalNotes'] ?? ''
            );
          }
          isLoading = false;
        });
      } else {
        // Handle server errors
        setState(() {
          properties = []; // Ensure properties is set to an empty list
          isLoading = false;
        });
        // Display error message
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        properties = []; // Ensure properties is set to an empty list
        isLoading = false;
      });
      // Display error message
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              'Edit Report', // Replace with the actual location
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
                                  builder: (context) =>
                                      HomePage()), // Replace HomePage with your
                              // home page
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
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Update', // Replace with the actual location
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
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineOneController,
                  decoration: InputDecoration(
                    labelText: 'Line 1 *',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),
                //Line two
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: addressLineTwoController,
                  decoration: InputDecoration(
                    labelText: 'Line 2 *',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),
                //City
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City *',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),
                //State
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'State *',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),
                //Country
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: countryController,
                  decoration: InputDecoration(
                    labelText: 'Country *',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),
                //Postal Code
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: postCodeController,
                  decoration: InputDecoration(
                    labelText: 'Postal Code *',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),

                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Additional Details",
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
                const SizedBox(height: 12.0),
                //Refernece
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: referenceController,
                  decoration: InputDecoration(
                    labelText: 'Reference',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),
                const SizedBox(height: 12.0),
                //Client
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: clientController,
                  decoration: InputDecoration(
                    labelText: 'Client',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),

                const SizedBox(height: 12.0),
                //Type Text
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Type *",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 12.0),


                Padding(
                  padding: EdgeInsets.all(0),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: bWhite,
                    value: selectedType , // Ensure the value is either valid or null
                    hint: Text(
                      'Select Furnishing Type',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
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
                    items: type.map((String furnish) {
                      return DropdownMenuItem<String>(
                        value: furnish,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              furnish,
                              style: TextStyle(
                                color: kPrimaryColor,
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
                const SizedBox(height: 12.0),
                //Type Text
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Furnishing",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 12.0),

                Padding(
                  padding: EdgeInsets.all(0),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: bWhite,
                    value: selectedFurnishing , // Ensure the value is either valid or null
                    hint: Text(
                      'Select Furnishing Type',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
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
                    items: furnishing.map((String furnish) {
                      return DropdownMenuItem<String>(
                        value: furnish,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              furnish,
                              style: TextStyle(
                                color: kPrimaryColor,
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
                          color: kPrimaryColor,
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
                          color: kPrimaryColor,
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
                          color: kPrimaryColor,
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
                          color: kPrimaryColor,
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
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: notesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Note',
                    hintStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),

                SizedBox(height: 30.0),

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
                      color: kPrimaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 12.0),

                //Ins Type
                Padding(
                  padding: EdgeInsets.all(0),
                  child:  DropdownButtonFormField<String>(
                    dropdownColor: bWhite,
                    value: selectedInventoryType,
                    hint: Text('Select Type',style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    )),
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
                    items: inventoryType.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              type,
                              style: TextStyle(
                                color: kPrimaryColor,
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
                        selectedInventoryType = newValue;
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
                            color: kPrimaryColor,
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
                            color: kPrimaryColor,
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
                      color: kPrimaryColor,
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
                    hint: Text('Key Location',style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    )),
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
                                color: kPrimaryColor,
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




                TextField(
                  cursorColor: kPrimaryColor,
                  controller: notesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Additional Notes',
                    hintStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14// Change the label text color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor, // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12// Change the text color inside the TextField
                  ),
                ),

                SizedBox(height: 12.0),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
