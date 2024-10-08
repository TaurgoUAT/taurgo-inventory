import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import '../authentication/controller/authController.dart';
import '../camera_preview_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool soundEnabled = true;
  bool notificationsEnabled = true;
  bool locationEnabled = false;

  @override
  void initState() {
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Setting',
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
              Navigator.pop(context); // Close EditProfile and go back to HomePage
              HomePage.homePageKey.currentState?.navigateToPage(1);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: kPrimaryColor,
              size: 24,
            ),
          ),

          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.person, color: kPrimaryColor),
          //     onPressed: () {
          //       Navigator.pop(context); // Close EditProfile and go back to HomePage
          //       HomePage.homePageKey.currentState?.navigateToPage(1); // Navigate to AccountPage
          //     },
          //   ),
          // ],
        ),
        body: Container(
          color: bWhite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text('General Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SwitchListTile(
                  title: Text('Sound', style: TextStyle(fontSize: 12)),
                  value: soundEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      soundEnabled = value;
                    });
                  },
                  activeColor: kPrimaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
                SwitchListTile(
                  title: Text('Notifications', style: TextStyle(fontSize: 12)),
                  value: notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  activeColor: kPrimaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),

                Divider(),
                ListTile(
                  title: Text('About',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Version', style: TextStyle(fontSize: 12)),
                        Text('1.0.0', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text('License',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Terms of Service', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 15),
                        Text('Privacy Policy', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                Spacer(),


                Center(
                  child: GestureDetector(
                    onTap: () {
                      // AuthController.instance.logOut();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              backgroundColor: Colors.white,
                              title: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: kPrimaryColor),
                                  SizedBox(width: 10),
                                  Text(
                                    'Delete Account',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Are you sure want to Delete the Account? '
                                    'One you delete the Account you will '
                                    'lose all the Data',
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
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    // print(propertyId);
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           EditReportPage(
                                    //             propertyId: propertyId,
                                    //           )), // Replace HomePage
                                    //   // with your home page
                                    //   // widget
                                    // ); // Close the dialog
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8),
                                    backgroundColor: Colors.red.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8), // Background color of the
                        // container
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
                          color: bWhite, // Border color
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
                          Icon(
                            Icons.remove_circle_outline_outlined,
                            color: bWhite, // Customize the icon color
                          ),
                          SizedBox(width: 8.0), // Space between the icon and the text
                          Text(
                            "Delete Account", // Customize the text
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
