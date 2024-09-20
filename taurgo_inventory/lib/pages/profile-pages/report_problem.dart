import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import '../camera_preview_page.dart';
class ReportProblem extends StatefulWidget {
  const ReportProblem({super.key});

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {

  var subjectController = TextEditingController();
  var problemController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PopScope(child: Scaffold(
      appBar: AppBar(
          title: Text(
            'Report Problem', // Replace with the actual location
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
              Navigator.pop(context); // Close EditProfile and go back to HomePage
              HomePage.homePageKey.currentState?.navigateToPage(1);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: kPrimaryColor,
              size: 24,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {

              },
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
          ]
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              TextField(
                cursorColor: kPrimaryColor,
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
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
              SizedBox(height: 30),

              // First Name Text Fiel
              TextFormField(
                controller: problemController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Describe your Problem here',
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
                cursorColor: kPrimaryColor,
              ),

              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: kPrimaryColor, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
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
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ), // Padding inside the container
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         // Space between the icon and the text
                        Text(
                          "Submit", // Customize the text
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
    ));
  }
}
