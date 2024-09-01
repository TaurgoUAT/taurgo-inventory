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
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'FAQs',
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              color: bWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SearchBarSectionHelpAndSupport(),
                  SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16.0),
                  //   child: Text(
                  //     'FAQs',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // _buildNavigationButton(context, 'Connecting to Ricoh Theta Z1',
                  //     RicohThetaZ1GuidePage()),
                  // SizedBox(height: 10),

                  _buildFAQsSection(),
                  SizedBox(height: 30),
                  _buildMoreInfoSection(),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => TermsandConidtions()),
                        // );
                      },
                      child: Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Handle privacy policy link press
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => PrivacyPolicyPage()),
                        // );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildNavigationButton(
      BuildContext context, String title, Widget page) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: bWhite,
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'FAQs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        ExpansionTile(
          title: Text(
              'What is Taurgo and how can it benefit real estate professionals?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                color: Colors.grey,
              )
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Taurgo is a virtual tour app designed to help real estate professionals create immersive virtual tours for their property listings. It allows you to capture 360-degree photos, including floor plans, and share them with potential buyers or tenants, enhancing your property marketing efforts.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                    color: Colors.grey,
                  )),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
              'How do I capture virtual tour photos, including floor plans, using Taurgo and a compatible camera?',style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
            color: Colors.grey,
          )
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'To capture virtual tour photos, including floor plans, you can connect the Taurgo app with a compatible camera, such as the Ricoh Theta Z1. Using the Taurgo app, you can capture 360-degree images of your property, and if desired, integrate floor plans into the virtual tour.',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                color: Colors.grey,
              )
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
              'Is it easy to upload, edit, and share photos, including floor plans, with the Taurgo team?',style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
            color: Colors.grey,
          )
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Absolutely! Taurgo makes it easy to upload, edit, and share your virtual tour photos, including floor plans, with the Taurgo team. Once you have captured the photos using the app, you can upload them directly and make any necessary edits or enhancements. You can also include floor plans in the virtual tour to provide a comprehensive view of the property.',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                color: Colors.grey,
              )
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
              'How long does it take for the Taurgo team to process and send back the completed virtual tour package, including floor plans?',style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
            color: Colors.grey,
          )
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'The Taurgo team strives to process and send back the completed virtual tour package, including floor plans, within 24 hours. This allows you to quickly incorporate the final photos and floor plans into your property listings, providing potential buyers or tenants with a comprehensive view of the property.',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                color: Colors.grey,
              )
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
              'What should I do if I encounter any issues or have questions while using Taurgo?',style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
            color: Colors.grey,
          )
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'If you encounter any issues or have questions while using Taurgo, the Taurgo team is there to assist you. Simply send an email to info@taurgo.co.uk, and they will be happy to help you resolve any problems or address any inquiries you may have regarding capturing and including floor plans in your virtual tours.',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
                color: Colors.grey,
              )
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildMoreInfoSection() {
    return Center(
      child: Column(
        children: [
          Text(
            'For more information visit our web page',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              const url = 'https://taurgo.co.uk';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            icon: Icon(Icons.web),
            label: Text('Taurgo.co.uk'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: bWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 326,
            height: 40,
            decoration: BoxDecoration(
              color: bWhite,
              border: Border.all(
                color: kSecondaryButtonBorderColor,
                // Replace with your desired border color
                width: 2.0, // Adjust the border width as needed
              ), // Background color of the search bar
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search,
                      color: kSecondaryButtonBorderColor), // Search icon
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: kSecondaryButtonBorderColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.mic,
                      color: kSecondaryButtonBorderColor), // Mic icon
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNavigationButton(
      BuildContext context, String title, Widget page) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: bWhite,
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }


}


class SearchBarSectionHelpAndSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            height: 40,
            decoration: BoxDecoration(
              color: bWhite,
              border: Border.all(
                color: kSecondaryButtonBorderColor, // Replace with your desired
                // border color
                width: 2.0, // Adjust the border width as needed
              ), // Background color of the search bar
              borderRadius: BorderRadius.circular(30.0),

              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 2,
              //     blurRadius: 5,
              //     offset: Offset(0, 3),
              //   ),
              // ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search,
                      color: kSecondaryButtonBorderColor), // Search icon
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: kSecondaryButtonBorderColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.mic,
                      color: kSecondaryButtonBorderColor), // Mic icon
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


