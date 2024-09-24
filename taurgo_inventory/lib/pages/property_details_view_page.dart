import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taurgo_inventory/pages/InspectionReportsPages/inspection_only_page.dart';
import 'package:taurgo_inventory/pages/edit_details_page.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/view_pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/AppColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/UrlConstants.dart';

class PropertyDetailsViewPage extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsViewPage({
    super.key,
    required this.propertyId,
  });

  @override
  State<PropertyDetailsViewPage> createState() =>
      _PropertyDetailsViewPageState();
}

class _PropertyDetailsViewPageState extends State<PropertyDetailsViewPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> properties = [];
  File? _imageFile; // File to store the selected image
  String? propertyAddressLineOne;
  String? propertyAddressLineTwo;
  String? propertyCity;
  String? propertyCountry;
  String? address;

  // Method to pick an image from the camera
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(Icons.info_outline, color: kPrimaryColor),
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
                'Update the Cover Picture of the Property',
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
                    'Retake',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    _pickImage();
                  },
                ),
                TextButton(
                  onPressed: () {
                    // AuthController.instance.logOut();
                    // print(propertyId);
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           EditReportPage(
                    //             propertyId: propertyId,
                    //           )), // Replace HomePage
                    //   // with your home page
                    //   // widget
                    // ); // Close the dialog
                    //TODO: Need to Add the Backend Handling
                    setState(() {
                      _imageFile = File(image.path);
                      Navigator.of(context).pop(); // Save the captured image
                    });
                    // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.red.withOpacity(0.8),
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
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProperties();
    print(widget.propertyId);
  }

  Future<void> fetchProperties() async {
    setState(() {
      isLoading = true;
    });

    String propertyId = widget.propertyId;

    try {
      final response = await http
          .get(Uri.parse('$baseURL/property/$propertyId'))
          .timeout(Duration(seconds: 60)); // Set the timeout duration

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties =
              data.map((item) => item as Map<String, dynamic>).toList();
          print(properties[0]['inspectionType']);
          propertyAddressLineOne = properties[0]['addressLineOne'];
          propertyAddressLineTwo = properties[0]['addressLineTwo'];
          propertyCity = properties[0]['city'];
          propertyCountry = properties[0]['country'];
          address = "$propertyAddressLineTwo,$propertyCity,$propertyCountry";
          print(address);
          isLoading = false;
        });
      } else {
        // Handle server errors
        setState(() {
          properties = []; // Ensure properties is set to an empty list
          isLoading = false;
        });
        // Display error message
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        properties = []; // Ensure properties is set to an empty list
        isLoading = false;
      });
      // Display error message
    }
  }

  void _openMap() async {
    print("Address in Map : Taurgo $address");
    String googleMapsUrl = "https://www.google"
        ".com/maps/search/?api=1&query=$address";
    Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              'Inspection Info', // Replace with the actual location
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14, // Adjust the font size
                fontFamily: "Inter",
              ),
            ),
            centerTitle: true,
            backgroundColor: bWhite,
            leading: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage()), // Replace HomePage with your home page
                      // widget
                    );
                  },
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           Helpandsupportpage()), // Replace HomePage with your home page widget
                  // );
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
                          color:
                              kPrimaryColor, // Set the color to your primary color
                          strokeWidth: 3.0,
                          strokeCap: StrokeCap.square, // Set the stroke width
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Add some space between the progress indicator and the text
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: kPrimaryColor,
                          // You can set the text color to match your theme
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("No properties available"),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: fetchProperties,
                                child: Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          color: bWhite,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Image
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Stack(
                                    children: [
                                      // Image or placeholder text
                                      Container(
                                        width: double.maxFinite,
                                        height: 220,
                                        color: Colors.grey[300],
                                        // Optional background color when no image
                                        child: Image.asset(
                                          'assets/images/prop-img.png', //
                                          // Replace with your image path
                                          width: 150, // Adjust width to match height for a perfect circle
                                          height: 150, // Adjust height as needed
                                          fit: BoxFit.cover, // Image fit mode
                                        )
                                      ),
                                      // Camera icon button in the left bottom corner
                                      // Positioned(
                                      //   bottom: 10,
                                      //   left: 10,
                                      //   child: IconButton(
                                      //     icon: Icon(
                                      //       Icons.camera_alt,
                                      //       color: Colors.white,
                                      //       size: 30,
                                      //     ),
                                      //     onPressed: () {
                                      //       _pickImage(); // Open the camera and capture image
                                      //     },
                                      //     color: Colors
                                      //         .black54, // Optional background color for the icon
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 15.0),

                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Inspection state",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              color: kPrimaryTextColourTwo,
                                            ),
                                          ),
                                          SizedBox(height: 3.0),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kActiveButtonColour,
                                                ),
                                                padding: EdgeInsets.all(16.0),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                properties[0]['status'],
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      kSecondaryTextColourTwo,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 2, // Thickness of the divider
                                          height:
                                              30, // Adjust the height as needed
                                          color: Color(
                                              0xFFC2C2C2), // Divider color
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(0),
                                      child: properties[0]['status'] != 'Completed'
                                          ''?  ElevatedButton(
                                        onPressed: () {
                                          // Check if the status is completed
                                          if (properties[0]['inspectionType'] == "Inventory & Schedule of Condition" ||
                                              properties[0]['inspectionType'] == "Check In" ||
                                              properties[0]['inspectionType'] == "Checkout" ||
                                              properties[0]['inspectionType'] == "Inventory & Check In" ||
                                              properties[0]['inspectionType'] == "Risk Assessment") {
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
                                                        'Sync information',
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                    'Please Make Sure you have stable internet before continue, Your process will not be saved if you exit the Process',
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
                                                        Navigator.of(context).pop(); // Close the dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        print(propertyId);
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => EditReportPage(propertyId: propertyId),
                                                          ),
                                                        ); // Close the dialog
                                                      },
                                                      style: TextButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                        backgroundColor: kPrimaryColor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Agree',
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
                                          } else if (properties[0]['inspectionType'] == "Midterm Inventory" ||
                                              properties[0]['inspectionType'] == "Self Service Inspection") {
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
                                                        'Sync information',
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                    'Please Make Sure you have stable internet before continue, Your process will not be saved if you exit the Process',
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
                                                        Navigator.of(context).pop(); // Close the dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        print(propertyId);
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => InspectionOnlyPage(propertyId: propertyId),
                                                          ),
                                                        ); // Close the dialog
                                                      },
                                                      style: TextButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                        backgroundColor: kPrimaryColor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Agree',
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
                                          } else {
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
                                                        'Invalid Inspection Type',
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                    'Please Make Sure you have selected the correct Inspection or Inventory Type',
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
                                                        Navigator.of(context).pop(); // Close the dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        print(propertyId);
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => EditReportPage(propertyId: propertyId),
                                                          ),
                                                        ); // Close the dialog
                                                      },
                                                      style: TextButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                        backgroundColor: kPrimaryColor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Agree',
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
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.5),
                                          child: Text('Edit Report', style: TextStyle(fontSize: 12)),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      )
                                      :ElevatedButton(
                                        onPressed: () {

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewPdf(propertyId: widget.propertyId)), // Replace 
                                            // HomePage
                                            // with your home page
                                            // widget
                                          );

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.5),
                                          child: Text('View Report', style:
                                          TextStyle(fontSize: 12)),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),)


                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Divider(
                                      thickness: 1, color: Color(0xFFC2C2C2)),
                                ),

//Address
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Address",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                              color: kPrimaryTextColourTwo,
                                            ),
                                          ),
                                          SizedBox(height: 3.0),
                                          Text(
                                            properties[0]['addressLineOne'] ?? 'No address',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              color: kSecondaryTextColourTwo,
                                            ),
                                          ),
                                          Text(
                                            properties[0]['addressLineTwo'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              color: kSecondaryTextColourTwo,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                properties[0]['city'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: kSecondaryTextColourTwo,
                                                ),
                                              ),
                                              Text(
                                                ",",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: kSecondaryTextColourTwo,
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                properties[0]['state'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: kSecondaryTextColourTwo,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            properties[0]['country'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              color: kSecondaryTextColourTwo,
                                            ),
                                          ),
                                          Text(
                                            properties[0]['postalCode'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              color: kSecondaryTextColourTwo,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Check if the status is not 'completed' before showing the navigation icon
                                      properties[0]['status'] != 'Completed'
                                          ? IconButton(
                                        icon: Icon(
                                          Icons.navigation,
                                          size: 36,
                                          color: kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          _openMap();
                                        },
                                      )
                                          : Container(), // Empty container if the status is 'completed'
                                    ],
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Divider(
                                      thickness: 1, color: Color(0xFFC2C2C2)),
                                ),

                                //Date and Type
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Inspection Date",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: kPrimaryTextColourTwo,
                                              ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                              properties[0]['date'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color: kSecondaryTextColourTwo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 2, // Thickness of the divider
                                          height:
                                              30, // Adjust the height as needed
                                          color: Color(
                                              0xFFC2C2C2), // Divider color
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Inspection Time",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: kPrimaryTextColourTwo,
                                              ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                              properties[0]['time'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color: kSecondaryTextColourTwo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Divider(
                                      thickness: 1, color: Color(0xFFC2C2C2)),
                                ),

                                //Rooms and  and Furnishning
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Inspection Type",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: kPrimaryTextColourTwo,
                                              ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                              properties[0]['inspectionType'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color: kSecondaryTextColourTwo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 2, // Thickness of the divider
                                          height:
                                              30, // Adjust the height as needed
                                          color: Color(
                                              0xFFC2C2C2), // Divider color
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "General",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: kPrimaryTextColourTwo,
                                              ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.bed,
                                                    size: 20.0,
                                                    color: kPrimaryColor),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  properties[0]['noOfBeds'],
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: kPrimaryColor),
                                                ),
                                                SizedBox(width: 16.0),
                                                Icon(Icons.bathtub,
                                                    size: 20.0,
                                                    color: kPrimaryColor),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  properties[0]['noOfBaths'],
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: kPrimaryColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Divider(
                                      thickness: 1, color: Color(0xFFC2C2C2)),
                                ),

                                //Client and Key Location
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Client",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: kPrimaryTextColourTwo,
                                              ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                              properties[0]['client'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color: kSecondaryTextColourTwo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 2, // Thickness of the divider
                                          height:
                                              30, // Adjust the height as needed
                                          color: Color(
                                              0xFFC2C2C2), // Divider color
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Location of Keys",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                                color: kPrimaryTextColourTwo,
                                              ),
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                              properties[0]['keyLocation'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color: kSecondaryTextColourTwo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Divider(
                                      thickness: 1, color: Color(0xFFC2C2C2)),
                                ),

                                Spacer(),

                                // Save Button
                                Center(
                                  child: properties[0]['status'] != 'Completed'
                                      '' //
                                  // Check if the status is not 'Completed'
                                      ? GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditDetailsPage(
                                            propertyId: widget.propertyId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor, // Background color of the container
                                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1), // Shadow color
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
                                          SizedBox(width: 8.0), // Space between the icon and the text
                                          Text(
                                            "Edit Info", // Customize the text
                                            style: TextStyle(
                                              color: bWhite, // Text color
                                              fontSize: 16.0, // Font size
                                              fontWeight: FontWeight.bold, // Font weight
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      : SizedBox.shrink(), // If status is 'Completed', show nothing
                                )

                              ],
                            ),
                          ),
                        ),
                )),
    );
  }
}
