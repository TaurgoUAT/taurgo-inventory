import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:taurgo_inventory/pages/authentication/signInPage.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../../../constants/AppColors.dart';
import '../../../widgets/HexagonLoadingWidget.dart';

class AuthController extends GetxController {
  // Where should I need this Auth Controller
  // SignUp Page, LogIn Page, Landing Page, Account Page

  // Instance of Auth Controller Class
  static AuthController instance = Get.find();
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Access Firestore
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // User would be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("LogIn Page");
      Get.offAll(() => SignInPage());
    } else {
      print("Home Page");
      // TODO: Have to check whether I can navigate from splash screen to welcome Page
      Get.offAll(() => HomePage());
    }
  }

  void registerUser(String email, String password, String name, String trim, String trim1, String trim2) async {
    // Show loading dialog
    isLoading(true);
    final loadingDialog = Get.dialog(
      Center(
        child: HexagonLoadingWidget(
          color: kPrimaryColor, // Use your custom color
          size: 120,            // Specify the size you want
        ),
      ),
      barrierDismissible: false, // Prevent the user from dismissing the dialog
    );

    try {
      // Perform registration
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      print(user?.email);

      // Send user details to server
      var uri = Uri.parse('$baseURL/user-details/new-user');
      final request = http.MultipartRequest('POST', uri)
        ..fields['firebaseId'] = user!.uid
        ..fields['userName'] = name
        ..fields['email'] = user.email!;

      var response = await request.send();
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Request successful');
      } else {
        print('${response.statusCode}');
      }

      // Successful registration
      // Get.offAll(() => HomePage());
    } catch (e) {
      // Handle errors and show snackbar
      Get.snackbar(
        "Account Creation failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      // Hide the loading dialog
      isLoading(false);
      if (loadingDialog != null) {
        Get.back(); // Close the loading dialog
      }
    }
  }

  void logInUser(String email, password) async {
    try {
      isLoading(true); // Show loading indicator
      Get.dialog(
        Center(
          child: HexagonLoadingWidget(
            color: kPrimaryColor, // Use your custom color
            size: 120,            // Specify the size you want
          )
        ),
        barrierDismissible:
            false, // Prevents the user from dismissing the dialog
      );
      await Future.delayed(Duration(seconds: 2));
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading(false); // Stop loading
      Get.back(); // Close the loading dialog
      // Navigate to home page
      Get.offAll(() => HomePage());
    } catch (e) {
      isLoading(false); // Stop loading
      Get.back(); // Close loading dialog
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
        await firestore.collection('users-deatils').doc(user.uid).delete();

        // Delete the user account
        await user.delete();

        // Sign out the user
        await auth.signOut();

        Get.snackbar(
            "Account Deleted", "Your account has been deleted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            titleText: Text("Success", style: TextStyle(color: Colors.white)),
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancels the sign-in, return null
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential using the auth details
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, get the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the current user
      User? user = userCredential.user;

      if (user != null) {
        // Send user details to your backend
        await sendUserDetailsToBackend(user.uid, googleUser.displayName ?? '', user.email ?? '');
      }

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> sendUserDetailsToBackend(String firebaseId, String name, String email) async {
    try {
      var uri = Uri.parse('$baseURL/user/new-user'); // Backend API endpoint
      final request = http.MultipartRequest('POST', uri)
        ..fields['firebaseId'] = firebaseId
        ..fields['userName'] = name
        ..fields['email'] = email;

      // Send the request
      var response = await request.send();
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('User details successfully sent to the backend');
      } else {
        print('Failed to send user details to backend: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending user details to backend: $e');
    }
  }

  // Future<UserCredential?> signInWithApple() async {
  //   try {
  //     // Check if the platform supports Sign in with Apple
  //     if (Platform.isIOS || Platform.isMacOS) {
  //       // Request credential from Apple
  //       final appleCredential = await SignInWithApple.getAppleIDCredential(
  //         scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
  //       );
  //
  //       // Create an OAuth credential using the obtained credential
  //       final oauthCredential = OAuthProvider('apple.com').credential(
  //         idToken: appleCredential.identityToken,
  //         accessToken: appleCredential.authorizationCode,
  //       );
  //
  //       // Sign in with Firebase using the OAuth credential
  //       final userCredential = await auth.signInWithCredential(oauthCredential);
  //
  //       // Get the current user
  //       User? user = userCredential.user;
  //
  //       if (user != null) {
  //         // Update the user's display name if it's available
  //         if (appleCredential.givenName != null && appleCredential.familyName != null) {
  //           String displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
  //           await user.updateDisplayName(displayName);
  //         }
  //
  //         // Send user details to your backend
  //         await sendUserDetailsToBackend(
  //           user.uid,
  //           user.displayName ?? '',
  //           user.email ?? '',
  //         );
  //       }
  //
  //       return userCredential;
  //     } else {
  //       // Handle other platforms, e.g., Android or Web
  //       print('Sign in with Apple is not supported on this platform.');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error signing in with Apple: $e');
  //     return null;
  //   }
  // }

  void forgotPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent!")),
      );
    } catch (e) {
      String message = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            message = "No user found for that email.";
            break;
          case 'invalid-email':
            message = "The email address is not valid.";
            break;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}




