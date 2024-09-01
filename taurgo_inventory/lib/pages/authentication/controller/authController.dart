// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:taurgo_inventory/pages/authentication/signInPage.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';

import '../../../constants/AppColors.dart';

class AuthController extends GetxController {
  //Where should I need this Auth Controller
  //
  /**
   * SignUp Page,
   * LogIn Page,
   * Landing Page,
   * Account Page
   */

  //Instance of Auth Controller Class
  static AuthController instance = Get.find();
  // final FirebaseFirestore firestore = FirebaseFirestore.instance; // Access Firestore

  //Email, Password, UserName
  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    //user Would be Notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("LogIn Page");
      Get.offAll(() => SignInPage());
    } else {
      print("Home Page");
      //TODO: Have to check whether I can navigate from saplash screen to
      // welcome Page
      Get.offAll(() => HomePage());
    }
  }

  void registerUser(String email, password, String userName,String firstName,
      lastName, String location) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      print(user?.email);
      // print(name);
      print(user?.email);
      // Get.to(() => SubscriptionPage());

      var uri = Uri.parse('$baseURL/user/new-user');
      final request = http.MultipartRequest('POST', uri)
        ..fields['firebaseId'] = user!.uid
        ..fields['firstName'] = firstName
        ..fields['lastName'] = lastName
        ..fields['userName'] = userName
        ..fields['email'] = email
        ..fields['location'] = location;

      var response = await request.send();
      print('Response status: ${response.statusCode}');
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              color: kPrimaryColor, // Set the color to your primary color
              strokeWidth: 3.0,
              strokeCap: StrokeCap.square, // Set the stroke width
            ),
          ),
          SizedBox(height: 16.0), // Add some space between the progress indicator and the text
          Text(
            "Loading...",
            style: TextStyle(
              color: kPrimaryColor, // You can set the text color to match your theme
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
        ],
      );

      if (response.statusCode == 200) {
        print('Request successful');
      }
      else{
        print('${response.statusCode}');
      }
      print(userName);
      print(user?.email);
      // Get.to(() => SubscriptionPage());


    } catch (e) {
      Get.snackbar("About User", "User Message",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text("Account Creation failed",
              style: TextStyle(color: Colors.white)),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void logInUser(String email, password) async {
    try {
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              color: kPrimaryColor, // Set the color to your primary color
              strokeWidth: 3.0,
              strokeCap: StrokeCap.square, // Set the stroke width
            ),
          ),
          SizedBox(height: 16.0), // Add some space between the progress indicator and the text
          Text(
            "Loading...",
            style: TextStyle(
              color: kPrimaryColor, // You can set the text color to match your theme
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
        ],
      );
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("About Login", "User Message",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text("User LogIn is failed",
              style: TextStyle(color: Colors.redAccent)),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void logOut() async {
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60.0,
          height: 60.0,
          child: CircularProgressIndicator(
            color: kPrimaryColor, // Set the color to your primary color
            strokeWidth: 3.0,
            strokeCap: StrokeCap.square, // Set the stroke width
          ),
        ),
        SizedBox(height: 16.0), // Add some space between the progress indicator and the text
        Text(
          "Loading...",
          style: TextStyle(
            color: kPrimaryColor, // You can set the text color to match your theme
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            fontFamily: "Inter",
          ),
        ),
      ],
    );
    await auth.signOut();
  }

  void deleteAccount() async {
    try {
      User? user = auth.currentUser;

      // Delete user's data from Firestore
      if (user != null) {
        // await firestore.collection('users-deatils').doc(user.uid).delete();

        // Delete the user account
        await user.delete();

        // Sign out the user
        await auth.signOut();

        Get.snackbar("Account Deleted", "Your account has been deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            titleText: Text("Success",
                style: TextStyle(color: Colors.white)),
            messageText: Text(
              "Your account has been deleted successfully.",
              style: TextStyle(color: Colors.white),
            ));

        // Navigate to the splash screen or login page
        Get.offAll(() => LandingScreen());
      }
    } catch (e) {
      Get.snackbar("Delete Account", "Error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text("Account Deletion Failed",
              style: TextStyle(color: Colors.white)),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

}
