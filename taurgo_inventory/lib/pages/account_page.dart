import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/profile-pages/edit_profile.dart';
import 'package:taurgo_inventory/pages/profile-pages/faq_page.dart';
import 'package:taurgo_inventory/pages/profile-pages/setting_page.dart';
import '../../constants/AppColors.dart';
import '../../widgets/add_action.dart';
import 'authentication/controller/authController.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:taurgo_inventory/pages/add_property_details_page.dart';
import 'package:taurgo_inventory/pages/property_details_view_page.dart';
import '../constants/AppColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {


  List<Map<String, dynamic>> completedProperties = [];
  List<Map<String, dynamic>> pendingProperties = [];
  bool isLoading = true;
  String filterOption = 'All'; // Initial filter option
  List<Map<String, dynamic>> filteredProperties = [];
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> userDetails= [];
  User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getFirebaseUserId();
  }
  late String firebaseId;

  Future<void> getFirebaseUserId() async {
    try {
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          firebaseId = user!.uid;
        });
        fetchUserDetails();
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error getting user UID: $e");
    }
  }
  Future<void> fetchUserDetails() async {
    try {
      final response = await http.get(Uri.parse
        ('$baseURL/user/firebaseId/$firebaseId'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        final List<dynamic>userData = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Assuming you have a userDetails map to store user information
            userDetails =
                userData.map((item) => item as Map<String, dynamic>).toList();
            print(userDetails.length);
            isLoading = false;
          });
        }
      } else {
        print("Failed to load user data: ${response.statusCode}");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load user data. Please try again."),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 14,
              fontFamily: "Inter",
            ),
          ),
          centerTitle: true,
          backgroundColor: bWhite,
          // leading: GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => EditReportPage(),
          //       ),
          //     );
          //   },
          //   child: Icon(
          //     Icons.arrow_back_ios_new,
          //     color: kPrimaryColor,
          //     size: 24,
          //   ),
          // ),
        ),
        body: Container(
          color: bWhite,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/no-img.png',
                        // Replace with your image path
                        width: 150, // Adjust the width to match the height for
                        // a perfect circle
                        height: 150, // Adjust the height as needed
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Text(
                    userDetails.isNotEmpty ? userDetails[0]['firstName'] ?? ''
                        'Abishan' : 'Abishan',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: allBlack,
                    ),
                  ),
                ),
                SizedBox(height: 2.0),
                Center(
                  child: Text(
                    userDetails.isNotEmpty ? userDetails[0]['email'] ?? ''
                        'Abishan' : 'Abishan',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "General",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.3), // Background color of
                                // the container
                                shape: BoxShape.rectangle, // You can use BoxShape.circle for a circular container
                                borderRadius: BorderRadius.circular(15.0), //
                                // Rounded corners
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.1), // Shadow color
                                //     spreadRadius: 2,
                                //     blurRadius: 5,
                                //     offset: Offset(0, 3), // Shadow position
                                //   ),
                                // ],
                              ),
                              padding: EdgeInsets.all(8.0), // Space inside the container around the icon
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit_note,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryTextColourTwo,
                              ),
                            ),
                          ],

                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ),
                          );
                        },
                      ),

                    ],
                  )
                ),
                SizedBox(height: 15.0),
                Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.3), // Background color of
                                // the container
                                shape: BoxShape.rectangle, // You can use BoxShape.circle for a circular container
                                borderRadius: BorderRadius.circular(15.0), //
                                // Rounded corners
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.1), // Shadow color
                                //     spreadRadius: 2,
                                //     blurRadius: 5,
                                //     offset: Offset(0, 3), // Shadow position
                                //   ),
                                // ],
                              ),
                              padding: EdgeInsets.all(8.0), // Space inside the container around the icon
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              "Setting",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryTextColourTwo,
                              ),
                            ),
                          ],

                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingPage(),
                              ),
                            );
                          },
                        ),

                      ],
                    )
                ),
                SizedBox(height: 15.0),
                Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.3), // Background color of
                                // the container
                                shape: BoxShape.rectangle, // You can use BoxShape.circle for a circular container
                                borderRadius: BorderRadius.circular(15.0), //
                                // Rounded corners
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.1), // Shadow color
                                //     spreadRadius: 2,
                                //     blurRadius: 5,
                                //     offset: Offset(0, 3), // Shadow position
                                //   ),
                                // ],
                              ),
                              padding: EdgeInsets.all(8.0), // Space inside the container around the icon
                              child: IconButton(
                                icon: Icon(
                                  Icons.help_outline_rounded,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FaqPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              "FAQs",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryTextColourTwo,
                              ),
                            ),
                          ],

                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FaqPage(),
                              ),
                            );
                          },
                        ),

                      ],
                    )
                ),
                Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      AuthController.instance.logOut();
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8), // Background color of the container
                        borderRadius: BorderRadius.circular(30.0), // Rounded
                        // corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding inside the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white, // Customize the icon color
                          ),
                          SizedBox(width: 8.0), // Space between the icon and the text
                          Text(
                            "Logout", // Customize the text
                            style: TextStyle(
                              color: Colors.white, // Text color
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
      ),
    );
  }
}
