import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  User? user;
  List<Map<String, dynamic>> userDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getFirebaseUserId();
    print(firebaseId);
    fetchUserDetails();
  }

  late String firebaseId;
  late File image; // List to store selected images

  final ImagePicker _picker = ImagePicker(); // Image picker instance

// Function to open gallery and select a single image
  Future<void> pickImageFromGallery() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery); // Pick a single image
      if (imageFile != null) {
        setState(() {
          image = File(imageFile.path); // Store the selected image
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text(
              'Image selected from gallery',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: bWhite,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        );
      }
    } else {
      print('Gallery permission not granted');
    }
  }
  // Function to open the camera and capture an image
  Future<void> captureMultipleImagesWithCamera() async {
    bool continueCapturing = true;

    while (continueCapturing) {
      final XFile? capturedImage =
          await _picker.pickImage(source: ImageSource.camera);
      if (capturedImage != null) {
        setState(() {
          image = File(capturedImage.path);
        });

        // Show a dialog asking if the user wants to capture another image
        bool? shouldContinue = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: bWhite,
              title: Row(
                children: [
                  Icon(Icons.flip_camera_ios, color: kPrimaryColor),
                  SizedBox(width: 10),
                  Text(
                    'Capture another image?',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Do you want to capture another image with the camera?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Close the dialog
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Continue capturing
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldContinue == false) {
          continueCapturing = false; // Stop the loop
        }
      } else {
        // User canceled capturing, exit the loop
        continueCapturing = false;
      }
    }
  }

  Future<void> getFirebaseUserId() async {
    try {
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          firebaseId = user!.uid;
        });
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error getting user UID: $e");
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$baseURL/user/firebaseId/$firebaseId'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        final List<dynamic> userData = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Assuming you have a userDetails map to store user information
            userDetails =
                userData.map((item) => item as Map<String, dynamic>).toList();
            print(userDetails.length);
            if (userDetails.isNotEmpty) {
              print("Hello");
              print(userDetails.length);
              userNameController =
                  TextEditingController(text: userDetails[0]['userName'] ?? '');
              firstNameController = TextEditingController(
                  text: userDetails[0]['firstName'] ?? '');
              lastNameController =
                  TextEditingController(text: userDetails[0]['lastName'] ?? '');
              locationController =
                  TextEditingController(text: userDetails[0]['location'] ?? '');
            }
            isLoading = false;
          });
        }
      } else {
        print("Failed to load user data: ${response.statusCode}");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load user data. Please try again."),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile(String userName, String firstName,
      String lastName, String location) async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              color: kPrimaryColor,
              strokeWidth: 3.0,
              strokeCap: StrokeCap.square,
            ),
          ),
        );
      },
    );

    try {
      var uri = Uri.parse('$baseURL/user/edit-user');

      final request = http.MultipartRequest('POST', uri)
        ..fields['firebaseId'] = firebaseId
        ..fields['userName'] = userName
        ..fields['firstName'] = firstName
        ..fields['lastName'] = lastName
        ..fields['location'] = location;

      var response = await request.send();

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('User Updated');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text(
              'User Updated Succesfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        );

        // Hide the loading indicator
        Navigator.of(context).pop();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      } else {
        print('Failed to Upload the Property Details ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Failed to Upload the Property Details: ${response.statusCode}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Network error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Network error: $e',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    } finally {
      // Ensure the dialog is dismissed
      Navigator.of(context).pop();
    }
  }

  XFile? _selectedLogo; // Store the selected image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedLogo = image;
      });
    }
  }

  void _showDeviceSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                width: 20, // Adjust width and height for the circular icon
                height: 20,
                decoration: BoxDecoration(
                  color: kPrimaryColor, // Green background for the circle
                  shape: BoxShape.circle, // Circular shape
                ),
                child: Icon(
                  Icons.done, // Done icon
                  color: bWhite, // White icon color
                  size: 12, // Adjust the icon size
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Select your Media',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjust the dialog height
            children: [
              Text(
                'Please Select your Media before continue',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),
              // Add some space between the text and buttons
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12, // Adjust width and height for the circular icon
                    decoration: BoxDecoration(
                      color: kPrimaryColor, // Green background for the circle
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined, // Done icon
                      color: bWhite, // White icon color
                      size: 14, // Adjust the icon size
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Text(
                    'Camera',
                    style: TextStyle(
                      color: bWhite,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                captureMultipleImagesWithCamera();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12, // Adjust width and height for the circular icon
                    decoration: BoxDecoration(
                      color: kPrimaryColor, // Green background for the circle
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: Icon(
                      Icons.image_outlined, // Done icon
                      color: bWhite, // White icon color
                      size: 14, // Adjust the icon size
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      color: bWhite,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                pickImageFromGallery();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Function to select an image from the gallery
  void _selectImageFromGallery() {
    // Implement your gallery selection logic here
  }

// Function to capture an image using the camera
  void _captureImageWithCamera() {
    // Implement your camera capture logic here
  }

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
              Navigator.pop(
                  context); // Close EditProfile and go back to HomePage
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
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(0),
                //     child: GestureDetector(
                //       onTap: _showDeviceSelection,
                //       child: image !=  null
                //           ? ClipOval(
                //         child: Image.file(
                //           image!, // Use '!' to indicate that image is not null
                //           height: 150, // Adjust the height for a larger circular image
                //           width: 150, // Adjust the width for a larger circular image
                //           fit: BoxFit.cover, // Ensure the image covers the circular area
                //         ),
                //       )
                //           : Container(
                //         height: 150,
                //         width: 150,
                //         decoration: BoxDecoration(
                //           color: Colors.grey[200],
                //           shape: BoxShape.circle, // Make the container circular
                //         ),
                //         child: Icon(
                //           Icons.add_a_photo,
                //           color: Colors.grey[700],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // // UserName Text Field
                SizedBox(height: 20),
                TextField(
                  cursorColor: kPrimaryColor,
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14 // Change the label text color
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12 // Change the text color inside the TextField
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
                        fontSize: 14 // Change the label text color
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12 // Change the text color inside the TextField
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
                        fontSize: 14 // Change the label text color
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12 // Change the text color inside the TextField
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
                        fontSize: 14 // Change the label text color
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when not focused
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        // Change the border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(
                      color: kSecondaryTextColourTwo,
                      fontSize: 12 // Change the text color inside the TextField
                      ),
                ),
                Spacer(),

                // Save Button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // AuthController.instance.logOut();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              backgroundColor: Colors.white,
                              title: Row(
                                children: [
                                  Icon(Icons.update_outlined,
                                      color: kPrimaryColor),
                                  SizedBox(width: 10),
                                  Text(
                                    'Update',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Make sure you have updated your details',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    _updateProfile(
                                        userNameController.text.trim(),
                                        firstNameController.text.trim(),
                                        lastNameController.text.trim(),
                                        locationController.text.trim());
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    backgroundColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        // Background color of the container
                        borderRadius: BorderRadius.circular(10.0),
                        // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            // Shadow color
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                        border: Border.all(
                          color: kPrimaryColor, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ), // Padding inside the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.update_outlined,
                            color: bWhite, // Customize the icon color
                          ),
                          SizedBox(width: 8.0),
                          // Space between the icon and the text
                          Text(
                            "Update", // Customize the text
                            style: TextStyle(
                              color: bWhite, // Text color
                              fontSize: 16.0, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
