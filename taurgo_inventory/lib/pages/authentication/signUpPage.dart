import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/authentication/signInPage.dart';

import '../../constants/AppColors.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(0),
                child: Center(
                  child: image,
                ),
              ),
              SignUpCard(),
              SizedBox(height: 10),
              TextField(
                cursorColor: kPrimaryColor,
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  labelStyle: TextStyle(
                    color: kPrimaryColor, // Hint text color
                    fontSize: 14,
                  ),
                  suffixIcon:
                  Icon(Icons.drive_file_rename_outline, color: kPrimaryColor),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                cursorColor: kPrimaryColor,
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(
                    color: kPrimaryColor, // Hint text color
                    fontSize: 14,
                  ),
                  suffixIcon:
                  Icon(Icons.perm_identity_rounded, color: kPrimaryColor),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                cursorColor: kPrimaryColor,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "User Name",
                  labelStyle: TextStyle(
                    color: kPrimaryColor, // Hint text color
                    fontSize: 14,
                  ),
                  suffixIcon:
                  Icon(Icons.perm_identity_rounded, color: kPrimaryColor),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                cursorColor: kPrimaryColor,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: kPrimaryColor, // Hint text color
                    fontSize: 14,
                  ),
                  suffixIcon: Icon(Icons.email_outlined, color: kPrimaryColor),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                cursorColor: kPrimaryColor,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: kPrimaryColor, // Hint text color
                    fontSize: 14,
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
                  ),                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                obscureText: !_isPasswordVisible,
              ),
              SizedBox(height: 10),
              TextField(
                cursorColor: kPrimaryColor,
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  labelStyle: TextStyle(
                    color: kPrimaryColor, // Hint text color
                    fontSize: 14,
                  ),
                  suffixIcon: Icon(Icons.location_on_outlined, color: kPrimaryColor),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),

              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                },
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AuthController.instance.registerUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim(),
                      firstNameController.text.trim(),
                      lastNameController.text.trim(),
                      locationController.text.trim());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                      child: Text('Sign Up', style: TextStyle(fontSize: 18)),
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
              SizedBox(
                height: 10,
              ),
              Center(

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
                                ..onTap = () => Get.to(() => SignInPage())),
                        ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
