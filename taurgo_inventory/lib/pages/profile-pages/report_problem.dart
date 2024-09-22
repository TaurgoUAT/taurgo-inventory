import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';
import '../../constants/UrlConstants.dart';
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
  Future<void> _reportProblem(String subject, String description) async {

    // Show loading indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              color: kPrimaryColor,
              strokeWidth: 3.0,
              strokeCap: StrokeCap.square,
            ),
          ),
        );
      },
    );

    try {
      var uri = Uri.parse('$baseURL/report/addReport');

      final request = http.MultipartRequest('POST', uri)
        ..fields['subject'] = subject
        ..fields['description'] = description;

      var response = await request.send();

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Property Updated, Please start uploading your tours');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text(
              'Thank You for your response. We will look into the Issue and '
                  'Sort them out in the future builds',
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
        HomePage.homePageKey.currentState?.navigateToPage(1);

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
                    _reportProblem(subjectController.text.trim(),problemController
                        .text.trim());
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
