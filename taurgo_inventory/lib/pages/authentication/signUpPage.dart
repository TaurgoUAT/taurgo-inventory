import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:taurgo_inventory/pages/authentication/signInPage.dart';
import '../../constants/AppColors.dart';
import '../../widgets/BottomWaveClipper.dart';
import '../../widgets/SocialMediaLogin.dart';
import 'Widgets/SignUpBoard.dart';
import 'controller/authController.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var locationController = TextEditingController();
  bool _isPasswordVisible = false;

  var image =
      Image.asset('assets/logo/logo.png', height: 250, fit: BoxFit.scaleDown);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // color: bWhite,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: BottomWaveClipper(),
                  // Custom clipper for the bottom border
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kPrimaryColor,
                          bWhite,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Align the image at the top center
                        Positioned(
                          top: 20,
                          // Adjust this value to position it vertically
                          left: 16,
                          right: 0,
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, right: 20),
                              child:
                                  image, // Replace 'image' with your actual widget or Image widget
                            ),
                          ),
                        ),
                        // Align the SignUpCard below the image
                        Positioned(
                          top: 220,
                          // Adjust this value to position SignUpCard below the image
                          left: 16,
                          // Add left padding
                          child: SignUpCard(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child:TextField(
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
                      prefixIcon:IconButton(
                        icon: Icon(
                          Icons.person_2_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                    style: TextStyle(
                        color: kSecondaryTextColourTwo,
                        fontSize: 12// Change the text color inside the TextField
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child:TextField(
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
                      prefixIcon:IconButton(
                        icon: Icon(
                          Icons.person_2_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                    style: TextStyle(
                        color: kSecondaryTextColourTwo,
                        fontSize: 12// Change the text color inside the TextField
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child:TextField(
                    cursorColor: kPrimaryColor,
                    controller: nameController ,
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
                      prefixIcon:IconButton(
                        icon: Icon(
                          Icons.person_outline_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                    style: TextStyle(
                        color: kSecondaryTextColourTwo,
                        fontSize: 12// Change the text color inside the TextField
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child:TextField(
                    cursorColor: kPrimaryColor,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                      prefixIcon:IconButton(
                        icon: Icon(
                          Icons.email_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                    style: TextStyle(
                        color: kSecondaryTextColourTwo,
                        fontSize: 12// Change the text color inside the TextField
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      prefixIcon:IconButton(
                        icon: Icon(
                          Icons.bug_report_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(
                        color: kSecondaryTextColourTwo,
                        fontSize: 12// Change the text color inside the TextField
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child:TextField(
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
                      prefixIcon:IconButton(
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: kPrimaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                    style: TextStyle(
                        color: kSecondaryTextColourTwo,
                        fontSize: 12// Change the text color inside the TextField
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child: GestureDetector(
                    onTap: () {
                      AuthController.instance.registerUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim(),
                          firstNameController.text.trim(),
                          lastNameController.text.trim(),
                          locationController.text.trim());
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 2.0,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: bWhite),
                          SizedBox(width: 8.0),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              color: bWhite,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Center(
                      child: RichText(
                    text: TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        children: [
                          TextSpan(
                              text: " Sign In",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => const SignInPage
                                  ())),
                        ]),
                  )),
                ),
                const SizedBox(height: 18),
                Center(
                  child: SocialMediaLogin(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
