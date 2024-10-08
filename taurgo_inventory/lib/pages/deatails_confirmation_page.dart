import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:taurgo_inventory/pages/edit_details_page.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../../constants/AppColors.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/HexagonLoadingWidget.dart';

class DetailsConfirmationPage extends StatefulWidget {

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

  final String? selectedType;
  final String? date;
  final String? time;
  final String? keyLocation;
  final String? referenceForKey;
  final String? internalNotes;

  const DetailsConfirmationPage({super.key, this.lineOneAddress, this.lineTwoAddress, this.city, this.state, this.country, this.postalCode, this.reference, this.client, this.type, this.furnishing, this.noOfBeds, this.noOfBaths, this.garage, this.parking, this.notes, this.selectedType, this.date, this.time, this.keyLocation, this.referenceForKey, this.internalNotes});

  @override
  State<DetailsConfirmationPage> createState() => _DetailsConfirmationPageState();
}

class _DetailsConfirmationPageState extends State<DetailsConfirmationPage> {
  User? user;
  late String firebaseId;

  late TextEditingController lineOneAddressController;
  late TextEditingController lineTwoAddressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController postalCodeController;
  late TextEditingController clientController;


  @override
  void initState() {
    super.initState();
    getFirebaseUserId();
    lineOneAddressController = TextEditingController(text: widget.lineOneAddress ?? '');
    lineTwoAddressController = TextEditingController(text: widget.lineTwoAddress ?? '');
    cityController = TextEditingController(text: widget.city ?? '');
    stateController = TextEditingController(text: widget.state ?? '');
    countryController = TextEditingController(text: widget.country ?? '');
    postalCodeController = TextEditingController(text: widget.postalCode ?? '');
    clientController = TextEditingController(text: widget.client ?? '');
  }
  Future<void> getFirebaseUserId() async {
    try {
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          firebaseId = user!.uid;
        });
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error getting user UID: $e");
    }
  }

  Future<void> _saveDetails() async {

    // Show loading indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: HexagonLoadingWidget(
            color: kPrimaryColor, // Use your custom color
            size: 120,            // Specify the size you want
          ),
        );
      },
    );

    try {
      var uri = Uri.parse('$baseURL/property/addProps');

      final request = http.MultipartRequest('POST', uri)
        ..fields['firebaseId'] = firebaseId
      //Address
        ..fields['addressLineOne'] = widget.lineOneAddress ?? 'N/A'
        ..fields['addressLineTwo'] = widget.lineTwoAddress ?? 'N/A'
        ..fields['city'] = widget.city ?? 'N/A'
        ..fields['state'] = widget.state ?? 'N/A'
        ..fields['country'] = widget.country ?? 'N/A'
        ..fields['postalCode'] = widget.postalCode ?? 'N/A'
      //Details
        ..fields['ref'] = widget.reference ?? 'N/A'
        ..fields['client'] = widget.client ?? 'N/A'
        ..fields['type'] = widget.type ?? 'N/A'
        ..fields['furnishing'] = widget.furnishing ?? 'N/A'
        ..fields['noOfBeds'] = widget.noOfBeds ?? 'N/A'
        ..fields['noOfBaths'] = widget.noOfBaths ?? 'N/A'
        ..fields['garage'] = widget.garage.toString() ?? 'N/A'
        ..fields['parking'] = widget.parking.toString() ?? 'N/A'
        ..fields['notes'] = widget.parking.toString() ?? 'N/A'

        ..fields['inspectionType'] = widget.selectedType ?? 'N/A'
        ..fields['date'] = widget.date ?? 'N/A'
        ..fields['time'] = widget.time ?? 'N/A'
        ..fields['keyLocation'] = widget.keyLocation ?? 'N/A'
        ..fields['referneceKey'] = widget.referenceForKey ?? 'N/A'
        ..fields['internalNotes'] = widget.internalNotes ?? 'N/A';

      var response = await request.send();

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Property Updated, Please start uploading your tours');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text(
              'Request Succesfull, you can continue to taking pictures',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        );

        // Hide the loading indicator
        Navigator.of(context).pop();

        // Navigate to the confirmation page
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>HomePage(),
            ),
          );
        });
      } else {
        print('Failed to Upload the Property Details ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Failed to Upload the Property Details: ${response.statusCode}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Network error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Network error: $e',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    } finally {
      // Ensure the dialog is dismissed
      Navigator.of(context).pop();
    }
  }
  @override
  void dispose() {
    // Dispose controllers when not needed
    lineOneAddressController.dispose();
    lineTwoAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirmation',
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EditReportPage(propertyId: '',),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: (){
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => EditDetailsPage()),
        //       // );
        //     },
        //     child: Container(
        //       margin: EdgeInsets.all(16),
        //       child: Text(
        //         'Edit', // Replace with the actual location
        //         style: TextStyle(
        //           color: kPrimaryColor,
        //           fontSize: 14, // Adjust the font size
        //           fontFamily: "Inter",
        //         ),
        //       ),
        //     ),
        //   )
        // ],
      ),

      body: Container(
        color: bWhite,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Confirmation",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ),

              SizedBox(height: 12.0),

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
                  onTap: _saveDetails,
                  child: Container(

                    width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      // Background color of the container
                      borderRadius: BorderRadius.circular(10.0),
                      // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                      border: Border.all(
                        color: kPrimaryColor, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_border_outlined,
                          color: bWhite, // Customize the icon color
                        ),
                        SizedBox(width: 8.0),
                        // Space between the icon and the text
                        Text(
                          "Save", // Customize the text
                          style: TextStyle(
                            color: bWhite, // Text color
                            fontSize: 16.0, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
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

                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

