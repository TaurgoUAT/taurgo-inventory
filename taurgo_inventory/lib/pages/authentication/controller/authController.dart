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
import 'package:taurgo_inventory/pages/authentication/signInPage.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';

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

  void registerUser(String email, password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      print(user?.email);
      print(name);
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
