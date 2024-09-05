import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
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

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    setState(() {
      isLoading = true;
    });

    String propertyId = widget.propertyId;

    try {
      final response = await http.get(Uri.parse('$baseURL/property/$propertyId'))
          .timeout(Duration(seconds: 60)); // Set the timeout duration

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties = data.map((item) => item as Map<String, dynamic>).toList();
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

  @override
  Widget build(BuildContext context) {
    String propertyId = widget.propertyId;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
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
                  Navigator.pushReplacement(
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
                      child: Image.asset(
                        'assets/images/prop-img.png',
                        // Replace with your image path
                        width: double
                            .maxFinite, // Adjust the width as needed
                        height: 220, // Adjust the height as needed
                        fit: BoxFit
                            .cover, // Adjust the fit as needed (e.g., BoxFit.contain, BoxFit.fill)
                      ),
                    ),

                    SizedBox(height: 15.0),

                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: kSecondaryTextColourTwo,
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
                              height: 30, // Adjust the height as needed
                              color: Color(0xFFC2C2C2), // Divider color
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    backgroundColor: Colors.white,
                                    title: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: kPrimaryColor),
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
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print(propertyId);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditReportPage(
                                                      propertyId: propertyId,
                                                    )), // Replace HomePage
                                            // with your home page
                                            // widget
                                          ); // Close the dialog
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8),
                                          backgroundColor: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
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
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: Text('Edit Report',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0.0),
                      child:
                      Divider(thickness: 1, color: Color(0xFFC2C2C2)),
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
                                properties[0]['addressLineTwo'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    properties[0]['city'],
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
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    properties[0]['state'],
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: kSecondaryTextColourTwo,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                properties[0]['country'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                              Text(
                                properties[0]['postalCode'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: kSecondaryTextColourTwo,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.navigation,
                              size: 36,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              // _showFilterOptions(context);
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0.0),
                      child:
                      Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                    ),

                    //Date and Type
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              height: 30, // Adjust the height as needed
                              color: Color(0xFFC2C2C2), // Divider color
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0.0),
                      child:
                      Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                    ),

                    //Rooms and  and Furnishning
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              height: 30, // Adjust the height as needed
                              color: Color(0xFFC2C2C2), // Divider color
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
                                        size: 20.0, color: kPrimaryColor),
                                    SizedBox(width: 4.0),
                                    Text(
                                      properties[0]['noOfBeds'],
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: kPrimaryColor),
                                    ),
                                    SizedBox(width: 16.0),
                                    Icon(Icons.bathtub,
                                        size: 20.0, color: kPrimaryColor),
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0.0),
                      child:
                      Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                    ),

                    //Client and Key Location
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              height: 30, // Adjust the height as needed
                              color: Color(0xFFC2C2C2), // Divider color
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0.0),
                      child:
                      Divider(thickness: 1, color: Color(0xFFC2C2C2)),
                    ),
                    Spacer(),

                    Center(
                      child: GestureDetector(
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
                              "Sync",
                              // The text you want to display
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 16.0, // Font size
                                fontWeight:
                                FontWeight.bold, // Font weight
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

        )


      ),
    );
  }

}
