import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var userNameController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
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
        resizeToAvoidBottomInset: false,
        body: Container(
          color: bWhite,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UserName Text Field
                SizedBox(height: 30),
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
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

                // First Name Text Field
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
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

                // Last Name Text Field
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
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

                // Location Text Field
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
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
                Spacer(),

                // Save Button
                GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Save the profile changes
                        // Add your save logic here
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                        child: Text('Save', style: TextStyle(fontSize: 18)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
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
