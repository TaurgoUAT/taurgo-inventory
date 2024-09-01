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
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        AuthController.instance.deleteAccount();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          'Delete Account',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: bWhite, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(50), // Button corner radius
                        ),
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
