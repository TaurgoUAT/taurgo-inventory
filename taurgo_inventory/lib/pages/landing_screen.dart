import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:taurgo_inventory/pages/add_property_details_page.dart';
import 'package:taurgo_inventory/pages/property_details_view_page.dart';
import '../constants/AppColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authentication/controller/authController.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<Map<String, dynamic>> completedProperties = [];
  List<Map<String, dynamic>> pendingProperties = [];
  bool isLoading = true;
  String filterOption = 'All'; // Initial filter option
  List<Map<String, dynamic>> filteredProperties = [];
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> userDetails= [];
  User? user;

  @override
  void initState() {
    super.initState();
    getFirebaseUserId();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/property/all/$firebaseId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            properties =
                data.map((item) => item as Map<String, dynamic>).toList();
            filteredProperties = properties;
            isLoading = false;
          });
        }
      } else {
        print("Failed to load properties: ${response.statusCode}");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to load properties. Please try again.")),
          );
        }
      }
    } catch (e) {
      print("Error fetching properties: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  late String firebaseId;

  Future<void> getFirebaseUserId() async {
    try {
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          firebaseId = user!.uid;
        });
        fetchUserDetails();
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error getting user UID: $e");
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http.get(Uri.parse
        ('$baseURL/user/firebaseId/$firebaseId'));


      if (response.statusCode == 200) {
        print(response.statusCode);
        final List<dynamic>userData = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Assuming you have a userDetails map to store user information
            userDetails =
                userData.map((item) => item as Map<String, dynamic>).toList();
            print(userDetails.length);
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
  Future<void> deletePropertyById(String propertyId) async {
    print(propertyId);
    final url = '$baseURL/property/$propertyId';
    // Replace with your actual
    // API endpoint

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Deletion was successful
      print('Property deleted successfully');
      fetchProperties();
    } else {
      // Deletion failed
      throw Exception('Failed to delete property');
    }
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: bWhite,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Filter Options",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
              Divider(),
              ListTile(
                title: Text("Active"),
                onTap: () {
                  // applyFilter('Completed');
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Completed"),
                onTap: () {
                  // applyFilter('Pending');
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("All"),
                onTap: () {
                  // applyFilter('All');
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userDetails.isNotEmpty ? userDetails[0]['userName'] ?? ''
                          'Abishan' : 'Abishan',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                      ),
                    ),
                    SizedBox(height: 2),
                    // Adjust the spacing between the text and the location row
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                          size: 11, // Adjust the icon size
                        ),
                        SizedBox(width: 4),
                        // Space between the icon and the location text
                        Text(
                          userDetails.isNotEmpty ? userDetails[0]['location']
                              ?? ''
                              'UK' : 'UK',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 11, // Adjust the font size
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: bWhite,
            leading: GestureDetector(
              onTap: (){

              },
              // onTap: () {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(builder: (context) => Homepage()),
              //   );
              // },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logo/Taurgo Logo.png'),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                onPressed: () {
                  AuthController.instance.logOut();
                },
              ),
            ],
          ),
          body: isLoading
              ? Center(
            child: Column(
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
            ),
          )
              : Container(
            color: bWhite,
            child: properties.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                    //Search bar
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: 40,
                            decoration: BoxDecoration(
                              color: bWhite,
                              border: Border.all(
                                color: kSecondaryButtonBorderColor,
                                // Replace with your desired
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
                                      color:
                                      kSecondaryButtonBorderColor), // Search icon
                                ),
                                Expanded(
                                  child: TextField(
                                    cursorColor: kPrimaryColor,
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          color: kSecondaryButtonBorderColor),
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
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    //Filter Options
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Your Properties",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showFilterOptions(context);
                                },
                                child: Text(
                                  "Filter",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                    color: kSecondaryTextColourTwo,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.filter_alt_outlined,
                                  size: 24,
                                  color: kSecondaryTextColourTwo,
                                ),
                                onPressed: () {
                                  _showFilterOptions(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                        height: 20,),
                          Center(
                            child: Text(
                              'Welcome to Taurgo inventory',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'No properties available',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 150,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap:(){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddPropertyDetailsPage()), //
                                  // Replace with your page or function to add properties
                                );
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 0.0, top: 0),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Start Report",
                                    // The text you want to display
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 16.0, // Font size
                                      fontWeight: FontWeight.bold, // Font weight
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    )

                  ],
                ),
              ),
            )
                : Padding(
              padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),

              //Search bar
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 40,
                      decoration: BoxDecoration(
                        color: bWhite,
                        border: Border.all(
                          color: kSecondaryButtonBorderColor,
                          // Replace with your desired
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
                                color:
                                kSecondaryButtonBorderColor), // Search icon
                          ),
                          Expanded(
                            child: TextField(
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    color: kSecondaryButtonBorderColor),
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
              ),

              SizedBox(
                height: 20,
              ),

              //Filter Options
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Your Properties",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showFilterOptions(context);
                          },
                          child: Text(
                            "Filter",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: kSecondaryTextColourTwo,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            size: 24,
                            color: kSecondaryTextColourTwo,
                          ),
                          onPressed: () {
                            _showFilterOptions(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredProperties.length,
                  itemBuilder: (context, index) {
                    int reversedIndex = filteredProperties.length - 1 - index;
                    final property = filteredProperties[reversedIndex];
                    return propertyContainer(
                      property['status'] ?? '',
                      property['propertyId'] ?? '',
                      property['addressLineOne'] ?? '',
                      property['addressLineTwo'] ?? '',
                      property['city'] ?? '',
                      property['state'] ?? '',
                      property['country'] ?? '',
                      property['postalCode'] ?? '',
                      property['ref'] ?? '',
                      property['client'] ?? '',
                      property['type'] ?? '',
                      property['furnishing'] ?? '',
                      property['noOfBeds'] ?? '',
                      property['noOfBaths'] ?? '',
                      property['garage'] ?? '',
                      property['parking'] ?? '',
                      property['notes'] ?? '',
                      property['inspectionType'] ?? '',
                      property['date'] ?? '',
                      property['time'] ?? '',
                      property['keyLocation'] ?? '',
                      property['referneceKey'] ?? '',
                      property['internalNotes'] ?? '',
                    );
                  },
                ),
              ),
              //Container for Listing

              //Floating Button with
            ],
          ),
        ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Navigate to the new page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPropertyDetailsPage()),
              );
            },
            label: Icon(
              Icons.add,
              color: bWhite,
              size: 48,
            ),
            // Icon for the button
            backgroundColor: kPrimaryColor,
            hoverColor: kPrimaryColor.withOpacity(0.4),
            // Hover color of the button
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.white, // Color of the border
                width: 2.0, // Width of the border
              ),
            ),
            elevation: 3.0,
          ),

        ));
  }

  Widget propertyContainer(
    String status,
      String propertyId,
    String addressLineOne,
    String addressLineTwo,
    String city,
    String state,
    String country,
    String postalCode,
    String ref,
    String client,
    String type,
    String furnishing,
    String noOfBeds,
    String noOfBaths,
    String garage,
    String parking,
    String notes,
    String inspectionType,
    String date,
    String time,
    String keyLocation,
    String referneceKey,
    String internalNotes,
// Add status as a parameter
  ) {
    return GestureDetector(
      onTap: () {
        print(propertyId);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsViewPage(
                propertyId: propertyId,
              ),
            ));
      },
      child: Container(
        height: 305,
        margin: EdgeInsets.only(bottom: 16.0, top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black, width: 1),
          // Add border color and width
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: Offset(4.0, 4.0),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        inspectionType,
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 100,
                        margin: EdgeInsets.only(bottom: 0.0, top: 0),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: Text(
                            status,
                            // The text you want to display
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 11.0, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    addressLineOne,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: allBlack,
                    ),
                  ),
                  Text(
                    addressLineTwo,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                  Text(
                    city,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                  Text(
                    country,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                  Text(
                    postalCode,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: kPrimaryTextColourTwo,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: allBlack,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.bed, size: 20.0, color: kPrimaryColor),
                      SizedBox(width: 4.0),
                      Text(
                        noOfBeds,
                        style: TextStyle(fontSize: 14.0, color: kPrimaryColor),
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.bathtub, size: 20.0, color: kPrimaryColor),
                      SizedBox(width: 4.0),
                      Text(
                        noOfBaths,
                        style: TextStyle(fontSize: 14.0, color: kPrimaryColor),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      
                      Expanded(child: Container(),),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
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
                                    Icon(Icons.info_outline, color: kPrimaryColor),
                                    SizedBox(width: 10),
                                    Text(
                                      'Confirm Deletion',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Are you sure you want to delete this item?',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel',
                                      style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                    ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await deletePropertyById(propertyId); // Call the delete function with propertyId
                                        Navigator.of(context).pop(); // Close the dialog
                                        // Optionally, refresh the list or perform additional actions here
                                      } catch (e) {
                                        // Handle errors if needed
                                        print('Error: $e');
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  // TextButton(
                                  //   child: Text('Delete'),
                                  //   onPressed: () {
                                  //     // Add delete action here
                                  //     Navigator.of(context).pop(); // Close the dialog
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      // ElevatedButton(
                      //   onPressed: () {},
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(7.5),
                      //     child: Text('Sync', style: TextStyle(fontSize: 18)),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: kPrimaryColor,
                      //     foregroundColor: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
