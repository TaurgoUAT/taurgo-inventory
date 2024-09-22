// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
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
  var isLoading = false.obs;

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

  // void registerUser(String email, password, String userName,String firstName,
  //     lastName, String location) async {
  //   isLoading(true);
  //   final loadingDialog = Get.dialog(
  //     Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const SizedBox(
  //             width: 60.0,
  //             height: 60.0,
  //             child: CircularProgressIndicator(
  //               color: kPrimaryColor, // Set the color to your primary color
  //               strokeWidth: 3.0,
  //               strokeCap: StrokeCap.square, // Set the stroke cap
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     barrierDismissible: false, // Prevent the user from dismissing the dialog
  //   );
  //   try {
  //     UserCredential userCredential = await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //
  //     User? user = userCredential.user;
  //     print(user?.email);
  //     // print(name);
  //     print(user?.email);
  //     // Get.to(() => SubscriptionPage());
  //
  //     var uri = Uri.parse('$baseURL/user/new-user');
  //     final request = http.MultipartRequest('POST', uri)
  //       ..fields['firebaseId'] = user!.uid
  //       ..fields['firstName'] = firstName
  //       ..fields['lastName'] = lastName
  //       ..fields['userName'] = userName
  //       ..fields['email'] = email
  //       ..fields['location'] = location;
  //
  //     var response = await request.send();
  //     print('Response status: ${response.statusCode}');
  //
  //     if (response.statusCode == 200) {
  //       print('Request successful');
  //     }
  //     else{
  //       print('${response.statusCode}');
  //     }
  //     print(userName);
  //     print(user?.email);
  //     // Get.to(() => SubscriptionPage());
  //
  //
  //   } catch (e) {
  //     Get.snackbar(
  //       "Account Creation failed",
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  //   finally {
  //     // Hide the loading dialog
  //     isLoading(false);
  //     if (loadingDialog != null) {
  //       Get.back(); // Close the loading dialog
  //     }
  //   }
  // }

  void registerUser(String email, password, String userName, String firstName,
      lastName, String location) async {


    try {
      isLoading(true); // Show loading state
      // Show loading dialog
      Get.dialog(
        Center(
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              color: kPrimaryColor, // Set the color to your primary color
              strokeWidth: 3.0,
              strokeCap: StrokeCap.square, // Set the stroke cap
            ),
          ),
        ),
        barrierDismissible: false, // Prevent the user from dismissing the dialog
      );

      await Future.delayed(Duration(seconds: 2));
      // Firebase user creation
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      if (user == null) {
        throw Exception("User creation failed, please try again.");
      }

      // Send data to your backend
      var uri = Uri.parse('$baseURL/user/new-user');
      final request = http.MultipartRequest('POST', uri)
        ..fields['firebaseId'] = user.uid
        ..fields['firstName'] = firstName
        ..fields['lastName'] = lastName
        ..fields['userName'] = userName
        ..fields['email'] = email
        ..fields['location'] = location;

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Request successful');
        // Optionally navigate to SubscriptionPage or another screen here
        // Get.to(() => SubscriptionPage());
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception("Failed to register user. Please try again.");
      }
      isLoading(false); // Stop loading
      Get.back(); // Close the loading dialog
      // Navigate to home page
      Get.offAll(() => HomePage());

    } catch (e) {
      // Show error snackbar
      Get.snackbar(
        "Account Creation Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      // Hide the loading state and dialog
      isLoading(false);
      Get.back(); // Close the loading dialog
    }
  }

  void logInUser(String email, password) async {
    try {
      isLoading(true); // Show loading indicator
      Get.dialog(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircularProgressIndicator(
                  color: kPrimaryColor, // Set the color to your primary color
                  strokeWidth: 3.0,
                  strokeCap: StrokeCap.square, // Set the stroke width
                ),
              ),
            ],
          ),
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

  Future<UserCredential?> signInWithGoogle() async {
    // try {
    //   // Trigger the authentication flow
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //
    //   // If the user cancels the sign-in, return null
    //   if (googleUser == null) {
    //     return null;
    //   }
    //
    //   // Obtain the auth details from the request
    //   final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    //
    //   // Create a new credential using the auth details
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );
    //
    //   // Once signed in, get the UserCredential
    //   final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    //
    //   // Get the current user
    //   User? user = userCredential.user;
    //
    //   if (user != null) {
    //     // Send user details to your backend
    //     await sendUserDetailsToBackend(user.uid, googleUser.displayName!, user.email!);
    //   }
    //
    //   return userCredential;
    // } catch (e) {
    //   print('Error signing in with Google: $e');
    //   return null;
    // }
  }


}
