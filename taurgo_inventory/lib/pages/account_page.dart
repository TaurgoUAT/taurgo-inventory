import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taurgo_inventory/pages/profile-pages/edit_profile.dart';
import 'package:taurgo_inventory/pages/profile-pages/faq_page.dart';
import 'package:taurgo_inventory/pages/profile-pages/report_problem.dart';
import 'package:taurgo_inventory/pages/profile-pages/setting_page.dart';
import '../../constants/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/ButtonSquare.dart';
import 'authentication/controller/authController.dart';

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
  List<Map<String, dynamic>> userDetails = [];
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
      final response =
          await http.get(Uri.parse('$baseURL/user/firebaseId/$firebaseId'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        final List<dynamic> userData = json.decode(response.body);

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

        body: SingleChildScrollView(
          // color: bWhite,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0,right: 16, bottom: 16,top: 75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Add some padding around the image
                    child: Stack(
                      children: [
                        Container(
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle, // Ensure the container remains a circle
                          //   border: Border.all(
                          //     color: kPrimaryColor, // Set the border color
                          //     width: 2.0, // Set the border width
                          //   ),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.grey.withOpacity(0.5), // Shadow color
                          //       spreadRadius: 4, // How wide the shadow spreads
                          //       blurRadius: 10, // Softness of the shadow
                          //       offset: Offset(0, 4), // Offset for the shadow position
                          //     ),
                          //   ],
                          // ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.png', // Replace with your image path
                              width: 150, // Adjust width to match height for a perfect circle
                              height: 150, // Adjust height as needed
                              fit: BoxFit.cover, // Image fit mode
                            ),
                          ),
                        ),
                        // Positioned(
                        //   width: 30,
                        //   height: 30,
                        //   bottom: 6, // Adjust position of the icon
                        //   right: 6,  // Adjust position of the icon
                        //   child: CircleAvatar(
                        //     radius: 20, // Size of the edit icon
                        //     backgroundColor: kPrimaryColor, // Background color for the
                        //     // icon
                        //     child: IconButton(
                        //       icon: Icon(Icons.camera_alt_outlined, color: bWhite,
                        //         size: 16,),
                        //       // Edit icon
                        //       onPressed: () {
                        //         // Add your edit function here
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Text("${userDetails.isNotEmpty ?
                  userDetails[0]['userName'] ?? ''
                      'Taurgo' : 'Taurgo'}"
                    ,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 2.0),
                Center(
                  child: Text(
                    userDetails.isNotEmpty
                        ? userDetails[0]['email'] ??
                            ''
                                'info@taurgo.com'
                        : 'info@taurgo.com',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Adjust spacing between containers
                    children: [
                      ButtonSquare(
                          width: 100,
                          height: 100,
                          bgColor: kPrimaryColor,
                          borderColor: kPrimaryColor,
                          childWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: bWhite,
                                ),
                              ),
                              Text(
                                'Assigned',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: bWhite,
                                ),
                              ),
                            ],
                          )),
                      ButtonSquare(
                          width: 100,
                          height: 100,
                          bgColor: bWhite,
                          borderColor: kPrimaryColor,
                          childWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          )),
                      ButtonSquare(
                          width: 100,
                          height: 100,
                          bgColor: bWhite,
                          borderColor: kPrimaryColor,
                          childWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),
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
                SizedBox(height: 12.0),
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
                                color: kPrimaryColor.withOpacity(0.3),
                                shape: BoxShape.rectangle,
                                // You can use BoxShape.circle for a circular container
                                borderRadius: BorderRadius.circular(15.0), //
                              ),
                              padding: EdgeInsets.all(8.0),
                              // Space inside the container around the icon
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
                    )),
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
                                color: kPrimaryColor.withOpacity(0.3),
                                // Background color of
                                // the container
                                shape: BoxShape.rectangle,
                                // You can use BoxShape.circle for a circular container
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
                              padding: EdgeInsets.all(8.0),
                              // Space inside the container around the icon
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
                    )),
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
                                color: kPrimaryColor.withOpacity(0.3),
                                // Background color of
                                // the container
                                shape: BoxShape.rectangle,
                                // You can use BoxShape.circle for a circular container
                                borderRadius: BorderRadius.circular(15.0), //
                              ),
                              padding: EdgeInsets.all(8.0),
                              // Space inside the container around the icon
                              child: IconButton(
                                icon: Icon(
                                  Icons.report_outlined,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportProblem(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              "Report a Problem",
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
                                builder: (context) => ReportProblem(),
                              ),
                            );
                          },
                        ),
                      ],
                    )),
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
                                color: kPrimaryColor.withOpacity(0.3),
                                // Background color of
                                // the container
                                shape: BoxShape.rectangle,
                                // You can use BoxShape.circle for a circular container
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
                              padding: EdgeInsets.all(8.0),
                              // Space inside the container around the icon
                              child: IconButton(
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _shareApp();
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              "Share",
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
                            _shareApp();
                          },
                        ),
                      ],
                    )),
                SizedBox(height: 30.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // AuthController.instance.logOut();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 10,
                              backgroundColor: Colors.white,
                              title: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: kPrimaryColor),
                                  SizedBox(width: 10),
                                  Text(
                                    'Log Out',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Are you sure want to Logout?',
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
                                    AuthController.instance.logOut();
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
                                        horizontal: 16, vertical: 8),
                                    backgroundColor:
                                    Colors.red.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: bWhite, // Background color of the container
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
                          Icon(
                            Icons.logout,
                            color: kPrimaryColor, // Customize the icon color
                          ),
                          SizedBox(width: 8.0), // Space between the icon and the text
                          Text(
                            "Log Out", // Customize the text
                            style: TextStyle(
                              color: kPrimaryColor, // Text color
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
  void _shareApp() {
    String appLink = "https://apps.apple"
        ".com/lk/app/taurgo-inventory/id6670381008";
    final shareText = "Check out the new Taurgo Inventory App — Your Ultimate "
        "tool for effortlessly managing property details. 🏡✨ "
        "Whether you're a real estate pro or just keeping track of your own "
        "properties, this app has got you covered! ${appLink}";

    Share.share(shareText);
  }
}
