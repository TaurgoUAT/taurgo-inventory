import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import the PDF viewer package
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taurgo_inventory/pages/property_details_view_page.dart';
import '../constants/AppColors.dart';
import '../constants/UrlConstants.dart';
import '../widgets/HexagonLoadingWidget.dart';
import 'home_page.dart';
import 'dart:convert';
class ViewPdf extends StatefulWidget {
  final String propertyId;

  const ViewPdf({super.key, required this.propertyId});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  String? pdfPath; // Store the path of the downloaded PDF
  late PDFViewController _pdfViewController;
  bool isLoading = true;
  List<Map<String, dynamic>> properties = [];
  String? propertyCity;
  String? inspectionType;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchProperties();
    fetchPdf();
    print(widget.propertyId);
  }
  //
  // Future<void> fetchProperties() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   String propertyId = widget.propertyId;
  //
  //   try {
  //     final response = await http
  //         .get(Uri.parse('$baseURL/property/$propertyId'))
  //         .timeout(Duration(seconds: 60)); // Set the timeout duration
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         properties =
  //             data.map((item) => item as Map<String, dynamic>).toList();
  //         print(properties[0]['inspectionType']);
  //         propertyCity = properties[0]['city'];
  //         inspectionType = properties[0]['inspectionType'];
  //
  //         isLoading = false;
  //       });
  //     } else {
  //       // Handle server errors
  //       setState(() {
  //         properties = []; // Ensure properties is set to an empty list
  //         isLoading = false;
  //       });
  //       // Display error message
  //     }
  //   } catch (e) {
  //     // Handle network errors
  //     setState(() {
  //       properties = []; // Ensure properties is set to an empty list
  //       isLoading = false;
  //     });
  //     // Display error message
  //   }
  // }
  //


  // Future<void> fetchPdf() async {
  //   String propertyId = widget.propertyId;
  //   final response =
  //       await http.get(Uri.parse('$baseURL/report/fetch/$propertyId'));
  //   if (response.statusCode == 200) {
  //     // Save the PDF to a temporary file
  //     final directory = await getTemporaryDirectory();
  //     final file = File('${directory.path}/${widget.propertyId}.pdf');
  //     await file.writeAsBytes(response.bodyBytes);
  //     setState(() {
  //       pdfPath = file.path; // Update the path to the file
  //     });
  //   } else {
  //     // Handle errors
  //     print('Error fetching PDF: ${response.statusCode}');
  //   }
  // }

  Future<void> fetchPdf() async {
    String propertyId = widget.propertyId;
    final response = await http.get(Uri.parse('$baseURL/report/fetch/$propertyId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String pdfUrl = data['downloadUrl']; // Get the download URL

      // Now download the PDF from the AWS URL
      final pdfResponse = await http.get(Uri.parse(pdfUrl));

      if (pdfResponse.statusCode == 200) {
        // Save the PDF to a temporary file
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/${widget.propertyId}.pdf');
        await file.writeAsBytes(pdfResponse.bodyBytes);

        setState(() {
          pdfPath = file.path; // Update the path to the file
        });
      } else {
        print('Error downloading PDF from AWS: ${pdfResponse.statusCode}');
      }
    } else {
      print('Error fetching PDF URL: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 14, // Adjust the font size
              fontFamily: "Inter",
            ),
          ),
          centerTitle: true,
          backgroundColor: bWhite,
          leading: IconButton(
            icon: Icon(
              Icons.close_sharp,
              color: kPrimaryColor,
            ),
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
                          'Do you want to Exit',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Your process will not be saved if you exit the process',
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PropertyDetailsViewPage(propertyId: widget.propertyId)), // Replace HomePage with your
                            // home page
                            // widget
                          ); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Exit',
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
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                _sharePdf();
              },
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Share',
                  style: TextStyle(color: kPrimaryColor, fontSize: 14),
                ),
              ),
            )
          ],
        ),
        body: pdfPath == null // Check if the PDF is loaded
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: Center(
                        child: HexagonLoadingWidget(
                          color: kPrimaryColor, // Use your custom color
                          size: 120,            // Specify the size you want
                        ),

                      ),
                    ),

                  ],
                ),
              )
            : PDFView(
          filePath: pdfPath,
          autoSpacing: false,
          pageSnap: true,
          enableSwipe: true, // Enable swipe to switch pages
          swipeHorizontal: false, // Enable horizontal swiping (if required)
          onRender: (pages) {
            setState(() {
              _totalPages = pages!;
              _isLoading = false;
            });
          },
          onViewCreated: (PDFViewController pdfViewController) {
            _pdfViewController = pdfViewController;
          },
          onPageChanged: (page, total) {
            setState(() {
              _currentPage = page!;
            });
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "Error loading PDF",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            );
            print('Error loading PDF: $error');
          },
          onPageError: (page, error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  "Error on page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            );
            print('Error on page $page: $error');
          },
        ),
      ),
    );
  }

  Future<void> _sharePdf() async {
    try {
      XFile pdfFile = XFile(pdfPath!);
      // Share subject and body text
      final subjectText = "Your Inspection Report is Ready!";
      final shareText = "Please find your Inspection Report attached.\n\n"
          "Thank you for using Taurgo Inventory for Property Management.";

      Share.shareXFiles(
        [pdfFile],
        text: shareText,
        subject: subjectText,
      );
    } catch (e) {
      print('Error sharing PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share the PDF.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

}
