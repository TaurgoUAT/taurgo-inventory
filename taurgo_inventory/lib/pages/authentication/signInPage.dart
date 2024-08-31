import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taurgo_inventory/pages/authentication/signUpPage.dart';

import '../../constants/AppColors.dart';
import 'Widgets/SignInBoard.dart';
import 'controller/authController.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  var image =
  Image.asset('assets/logo/logo.png', height: 250, fit: BoxFit.scaleDown);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
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
              SignInCard(),
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
              SizedBox(height: 30), // Increased spacing
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
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                obscureText: !_isPasswordVisible,
              ),
              SizedBox(height: 70),
              GestureDetector(
                onTap: () {
                  AuthController.instance.logInUser(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AuthController.instance.logInUser(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10),
                      child: Text('Sign In', style: TextStyle(fontSize: 18)),
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
              SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => SignUpPage()),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
