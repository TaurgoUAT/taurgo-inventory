import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import the PDF viewer package
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../constants/AppColors.dart';
import '../constants/UrlConstants.dart';
import 'home_page.dart';

class ViewPdf extends StatefulWidget {
  final String propertyId;
  const ViewPdf({super.key, required this.propertyId});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  String? pdfPath; // Store the path of the downloaded PDF

  @override
  void initState() {
    super.initState();
    fetchPdf();
  }

  Future<void> fetchPdf() async {
    String propertyId = widget.propertyId;
    final response = await http.get(Uri.parse('$baseURL/report/$propertyId'));
    if (response.statusCode == 200) {
      // Save the PDF to a temporary file
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${widget.propertyId}.pdf');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        pdfPath = file.path; // Update the path to the file
      });
    } else {
      // Handle errors
      print('Error fetching PDF: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report',
            style: TextStyle(color: kPrimaryColor, fontSize: 14),
          ),
          centerTitle: true,
          backgroundColor: bWhite,
          leading: IconButton(
            icon: Icon(Icons.close_sharp, color: kPrimaryColor),
            onPressed: () {
              // Handle exit logic
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // Handle share logic
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
            : PDFView(
          filePath: pdfPath,
          autoSpacing: false,
          pageSnap: true,
          onError: (error) {
            print('Error loading PDF: $error');
          },
          onPageError: (page, error) {
            print('Error on page $page: $error');
          },
        ),
      ),
    );
  }
}
