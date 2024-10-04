import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:digital_signature_flutter/digital_signature_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/Dtos/InspectionReportDto.dart';
import 'package:taurgo_inventory/Dtos/PropertyDto.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';
import 'package:http/http.dart' as http;
import '../../constants/UrlConstants.dart';
import '../../widgets/HexagonLoadingWidget.dart';

class PreviewInspectionPage extends StatefulWidget {
  final String propertyId;
  final List<File> images;

  const PreviewInspectionPage(
      {super.key, required this.propertyId, required this.images});

  @override
  State<PreviewInspectionPage> createState() => _PreviewInspectionPageState();
}

class _PreviewInspectionPageState extends State<PreviewInspectionPage> {
  late List<File> images;
  final notesController = TextEditingController();
  SignatureController? controller;
  Uint8List? signature;
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> userDetails = [];
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    images = List.from(widget.images);
    controller = SignatureController(penStrokeWidth: 5, penColor: Colors.black);
    getFirebaseUserId();
    fetchUserDetails();
    fetchProperties();
  }

  late String firebaseId;

  Future<void> getFirebaseUserId() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        firebaseId = user!.uid;
      });
      fetchUserDetails();
    } else {
      print("No user is currently signed in.");
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$baseURL/user/firebaseId/$firebaseId'));
      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);
        if (mounted) {
          setState(() {
            userDetails =
                userData.map((item) => item as Map<String, dynamic>).toList();
            print(userDetails[0]['email']);
            isLoading = false;
          });
        }
      } else {
        handleError(response);
      }
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> fetchProperties() async {
    setState(() => isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('$baseURL/property/${widget.propertyId}'))
          .timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties =
              data.map((item) => item as Map<String, dynamic>).toList();
          isLoading = false;
        });
      } else {
        handleError(response);
      }
    } catch (e) {
      handleError(e);
    }
  }

  void handleError(dynamic error) {
    setState(() {
      isLoading = false;
    });
    print("Error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred. Please try again.")));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<String> fileToBase64(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> submitData(BuildContext context) async {
    try {
      showLoadingDialog(context);

      List<String> base64Images = await Future.wait(images.map(fileToBase64));
      String comment = notesController.text;
      // String base64Signature =
      //     signature != null ? base64Encode(signature!) : '';

      // Update the DTO with the collected data
      PropertySummaryDto inspectionReportDtoDto = PropertySummaryDto(
        propertyId: widget.propertyId,
        addressDto: AddressDto(
          addressLineOne: properties[0]['addressLineOne'] ?? 'No address',
          addressLineTwo: properties[0]['addressLineTwo'] ?? 'No address',
          city: properties[0]['city'] ?? 'No address',
          state: properties[0]['state'] ?? 'No address',
          country: properties[0]['country'] ?? 'No address',
          postalCode: properties[0]['postalCode'] ?? 'No address',
        ),
        userDto: UserDto(
          firebaseId: 'user001',
          firstName: 'Abishan',
          lastName: 'Ananthan',
          userName: userDetails[0]['userName'] ?? 'Taurgo',
          email: userDetails[0]['email'] ?? 'info@taurgo.co.uk',
          location: 'Vavuniya',
        ),
        inspectionDto: InspectionSumamryDto(
          inspectionId: 'insp001',
          inspectorName: properties[0]['client'] ?? 'No address',
          inspectionType: properties[0]['inspectionType'] ?? 'No address',
          date: properties[0]['date'] ?? 'No address',
          time: properties[0]['time'] ?? 'No address',
          keyLocation: properties[0]['keyLocation'] ?? 'No address',
          keyReference: properties[0]['keyLocation'] ?? 'No address',
          internalNotes: properties[0]['keyLocation'] ?? 'No address',
        ),
        images: base64Images,
        // Set the base64 images
        comment: comment,
        // Set the comment
        signature: '', // Set the signature
      );

      print(
          "Summary DTO: ${inspectionReportDtoDto.toJson()}"); // Debug statement

      final url = '$baseURL/summary/inspection-report';
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            inspectionReportDtoDto.toJson()), // Use the toJson method
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text(
              'Report Has been Sent to your Email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        handleError(response);
      }
    } catch (e) {
      handleError(e);
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: HexagonLoadingWidget(
            color: kPrimaryColor, // Use your custom color
            size: 120,            // Specify the size you want
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Preview',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 14, // Adjust the font size
              fontFamily: "Inter",
            ),
          ),
          centerTitle: true,
          backgroundColor: bWhite,
          leading: IconButton(
            icon: Icon(Icons.close_sharp, color: kPrimaryColor),
            onPressed: () => showExitDialog(context),
          ),
          actions: [
            GestureDetector(
              onTap: () => submitData(context),
              child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text('Submit',
                      style: TextStyle(color: kPrimaryColor, fontSize: 14))),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageGrid(),
                SizedBox(height: 12.0),
                buildCommentsField(),
                const SizedBox(height: 15),
                // buildDeclarationText(),
                // const SizedBox(height: 15),
                // buildSignatureSection(),
                // const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Do you want to Exit?',
              style: TextStyle(color: kPrimaryColor, fontSize: 18)),
          content:
              Text('Your process will not be saved if you exit the process'),
          actions: [
            TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColor)),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage())),
              child: Text(
                'Exit',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildImageGrid() {
    return Container(
      height: 500,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(images[index], fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => images.removeAt(index)),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    child: Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCommentsField() {
    return TextField(
      cursorColor: kPrimaryColor,
      textInputAction: TextInputAction.done,
      controller: notesController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Comments',
        hintStyle: TextStyle(color: kPrimaryColor, fontSize: 14),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(8)),
      ),
      style: TextStyle(color: kSecondaryTextColourTwo, fontSize: 12),
    );
  }

  // Widget buildDeclarationText() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Declaration',
  //           style: TextStyle(color: kPrimaryColor, fontSize: 14)),
  //       const Text(
  //           'I/We the undersigned, affirm  that if I/we do not'
  //           ' comment on the inventory in writing within seven days '
  //           'of receipt of this inventory I/We accept the inventory '
  //           'as being an accurate record of the contents and '
  //           'conditions of the property',
  //           textAlign: TextAlign.justify,
  //           style: TextStyle(
  //             color: kPrimaryTextColourTwo,
  //             fontSize: 12, // Adjust the font size
  //             fontFamily: "Inter",
  //           )),
  //     ],
  //   );
  // }
  //
  // Widget buildSignatureSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Signature', style: TextStyle(color: kPrimaryColor, fontSize: 14)),
  //       Container(
  //         height: 200,
  //         child: Signature(
  //           controller: controller!,
  //           height: 200,
  //           backgroundColor: Colors.grey[200]!,
  //         ),
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.clear),
  //         onPressed: () {
  //           controller?.clear();
  //         },
  //       ),
  //     ],
  //   );
  // }
}
class DotLoadingText extends StatefulWidget {
  @override
  _DotLoadingTextState createState() => _DotLoadingTextState();
}

class _DotLoadingTextState extends State<DotLoadingText> {
  String _dots = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_dots.length < 3) {
          _dots += ".";
        } else {
          _dots = "";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible( // Allow text to resize properly
      child: Text(
        "Generating Report$_dots",
        style: const TextStyle(
          color: kPrimaryColor,
          fontSize: 14, // Adjust the font size
          fontFamily: "Inter",
        ),
        overflow: TextOverflow.ellipsis, // Prevent overflow
      ),
    );
  }
}
