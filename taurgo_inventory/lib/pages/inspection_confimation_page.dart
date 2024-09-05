import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import '../../constants/AppColors.dart';
import 'package:digital_signature_flutter/digital_signature_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Dtos/AddressDto.dart';
import '../Dtos/PropertyDto.dart';
import '../Dtos/UserDto.dart';

class InspectionConfimationPage extends StatefulWidget {
  final String propertyId;

  const InspectionConfimationPage({super.key, required this.propertyId});

  @override
  State<InspectionConfimationPage> createState() =>
      _InspectionConfimationPageState();
}

class _InspectionConfimationPageState extends State<InspectionConfimationPage> {
  SignatureController? controller;
  Uint8List? signature;
  List<Map<String, dynamic>> completedProperties = [];
  List<Map<String, dynamic>> pendingProperties = [];
  bool isLoading = true;
  String filterOption = 'All'; // Initial filter option
  List<Map<String, dynamic>> filteredProperties = [];
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> userDetails = [];
  User? user;
  String? selectedType;
  final Set<String> visitedPages = {}; // Track visited pages

  //SOC
  String? overview;
  String? accessoryCleanliness;
  String? windowSill;
  String? carpets;
  String? ceilings;
  String? curtains;
  String? hardFlooring;
  String? kitchenArea;
  String? oven;
  String? mattress;
  String? upholstrey;
  String? wall;
  String? window;
  String? woodwork;
  List<String> overviewImages = [];
  List<String> accessoryCleanlinessImages = [];
  List<String> windowSillImages = [];
  List<String> carpetsImages = [];
  List<String> ceilingsImages = [];
  List<String> curtainsImages = [];
  List<String> hardFlooringImages = [];
  List<String> kitchenAreaImages = [];
  List<String> ovenImages = [];
  List<String> mattressImages = [];
  List<String> upholstreyImages = [];
  List<String> wallImages = [];
  List<String> windowImages = [];
  List<String> woodworkImages = [];

  @override
  void initState() {
    super.initState();
    fetchProperties();
    getFirebaseUserId();
    // fetchProperties();
    controller = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
    getSharedPreferencesData();
    print(overview);
    _loadPreferences(widget.propertyId);

  }

  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      overview = prefs.getString('overview_${propertyId}' ?? "N/A") ;

      accessoryCleanliness =
          prefs.getString('accessoryCleanliness_${propertyId}' ?? "N/A");
      windowSill = prefs.getString('windowSill_${propertyId}' ?? "N/A");
      carpets = prefs.getString('carpets_${propertyId}');
      ceilings = prefs.getString('ceilings_${propertyId}');
      curtains = prefs.getString('curtains_${propertyId}');
      hardFlooring = prefs.getString('hardFlooring_${propertyId}');
      kitchenArea = prefs.getString('kitchenArea_${propertyId}');
      oven = prefs.getString('oven_${propertyId}');
      mattress = prefs.getString('mattress_${propertyId}');
      upholstrey = prefs.getString('upholstrey_${propertyId}');
      wall = prefs.getString('wall_${propertyId}');
      window = prefs.getString('window_${propertyId}');
      woodwork = prefs.getString('woodwork_${propertyId}');

      overviewImages =
          prefs.getStringList('overviewImages_${propertyId}') ?? [];
      accessoryCleanlinessImages =
          prefs.getStringList('accessoryCleanlinessImages_${propertyId}') ?? [];
      windowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      carpetsImages = prefs.getStringList('carpetsImages_${propertyId}') ?? [];
      ceilingsImages =
          prefs.getStringList('ceilingsImages_${propertyId}') ?? [];
      curtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      hardFlooringImages =
          prefs.getStringList('hardFlooringImages_${propertyId}') ?? [];
      kitchenAreaImages =
          prefs.getStringList('kitchenAreaImages_${propertyId}') ?? [];
      ovenImages = prefs.getStringList('ovenImages_${propertyId}') ?? [];
      mattressImages =
          prefs.getStringList('mattressImages_${propertyId}') ?? [];
      upholstreyImages =
          prefs.getStringList('upholstreyImages_${propertyId}') ?? [];
      wallImages = prefs.getStringList('wallImages_${propertyId}') ?? [];
      windowImages = prefs.getStringList('windowImages_${propertyId}') ?? [];
      woodworkImages =
          prefs.getStringList('woodworkImages_${propertyId}') ?? [];
      print(overview);
    });
  }

  late PropertyDto property = PropertyDto(
    id: 'property123',
    addressDto: AddressDto(
      addressLineOne: overview ?? 'N/A',
      addressLineTwo: accessoryCleanliness ?? 'N/A',
      city: 'Vavuniya',
      state: 'Western',
      country: 'Sri Lanka',
      postalCode: '12345',
    ),
    userDto: UserDto(
      firebaseId: 'user001',
      firstName: 'Abishan',
      lastName: 'Ananthan',
      userName: 'abishaan09',
      email: 'abiabishan09@gmail.com',
      location: '+Vavuniya',
    ),
    inspectionDto: InspectionDto(
      inspectionId: 'insp001',
      inspectorName: 'Jane Smith',
      inspectionType: 'Check Out',
      date: '2024-09-01',
      time: '2024-09-01',
      keyLocation: '2024-09-01',
      keyReference: '2024-09-01',
      internalNotes: '2024-09-01',
      inspectionReports: [
        InspectionReportDto(
          reportId: 'report001',
          name: 'Schedule of Condition',
          subTypes: [
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Overview - Odours',
              images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '', conditionImages: [],
            ),

            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            //
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            //
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            //
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            //
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            //
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            //
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),
            // SubTypeDto(
            //   subTypeId: 'subType001',
            //   subTypeName: 'Overview - Odours',
            //   images: ['https://www.loans.com.au/dA/9de8aa8d51/what-factors-affect-property-value.png'],
            //   comments: 'Condition: Good, Additional Comments: Good',
            //   feedback: '',
            // ),

            // Add more SubTypeDto items as needed
          ],
          additionalComments: 'All areas in good condition.',
        ),
        // Add more InspectionReportDto items as needed
      ],
    ),
  );

  Future<void> _saveData() async {
    try {
      await sendPropertyData(property);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data saved successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save data: $e'),
      ));
    }
  }

  Future<void> sendPropertyData(PropertyDto property) async {
    final url = '$baseURL/summary/generateReport'; // Replace with your backend URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(property.toJson());

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save data: ${response.reasonPhrase}');
    }
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
        print("Edit Page - $propertyId");
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties =
              data.map((item) => item as Map<String, dynamic>).toList();
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


  Future<Map<String, dynamic>> getSharedPreferencesData() async {
    String propertyId = widget.propertyId;
    final prefs = await SharedPreferences.getInstance();

    // Retrieve address data
    final addressLineOne =
        prefs.getString('overview_${propertyId}') ?? 'Default Address Line One';
    final addressLineTwo =
        prefs.getString('addressLineTwo') ?? 'Default Address Line Two';
    final city = prefs.getString('city') ?? 'Default City';
    final state = prefs.getString('state') ?? 'Default State';
    final country = prefs.getString('country') ?? 'Default Country';
    final postalCode = prefs.getString('postalCode') ?? 'Default Postal Code';

    // Retrieve user data
    final userFirebaseId =
        prefs.getString('userFirebaseId') ?? 'Default Firebase ID';
    final userFirstName =
        prefs.getString('userFirstName') ?? 'Default First Name';
    final userLastName = prefs.getString('userLastName') ?? 'Default Last Name';
    final userUserName = prefs.getString('userUserName') ?? 'Default Username';
    final userEmail = prefs.getString('userEmail') ?? 'Default Email';
    final userLocation = prefs.getString('userLocation') ?? 'Default Location';

    // Retrieve inspection data
    final inspectionId =
        prefs.getString('inspectionId') ?? 'Default Inspection ID';
    final inspectorName =
        prefs.getString('inspectorName') ?? 'Default Inspector Name';
    final inspectionType =
        prefs.getString('inspectionType') ?? 'Default Inspection Type';
    final date = prefs.getString('date') ?? 'Default Date';
    final time = prefs.getString('time') ?? 'Default Time';
    final keyLocation =
        prefs.getString('keyLocation') ?? 'Default Key Location';
    final keyReference =
        prefs.getString('keyReference') ?? 'Default Key Reference';
    final internalNotes =
        prefs.getString('internalNotes') ?? 'Default Internal Notes';

    // Retrieve image paths or URLs from SharedPreferences
    final subTypeImagePaths = prefs.getString('overview_${propertyId}') ?? [];
    final subTypeComments =
        prefs.getString('subTypeComments') ?? 'Default Comments';
    final subTypeFeedback =
        prefs.getString('subTypeFeedback') ?? 'Default Feedback';
    final additionalComments =
        prefs.getString('additionalComments') ?? 'Default Additional Comments';

    return {
      'addressDto': {
        'addressLineOne': addressLineOne,
        'addressLineTwo': addressLineTwo,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
      },
      'userDto': {
        'firebaseId': userFirebaseId,
        'firstName': userFirstName,
        'lastName': userLastName,
        'userName': userUserName,
        'email': userEmail,
        'location': userLocation,
      },
      'inspectionDto': {
        'inspectionId': inspectionId,
        'inspectorName': inspectorName,
        'inspectionType': inspectionType,
        'date': date,
        'time': time,
        'keyLocation': keyLocation,
        'keyReference': keyReference,
        'internalNotes': internalNotes,
        'inspectionReports': [
          {
            'reportId': 'report001',
            'name': 'Schedule of Condition',
            'subTypes': [
              {
                'subTypeId': 'subType001',
                'subTypeName': 'Odours',
                'images': subTypeImagePaths, // Use image paths or URLs
                'comments': subTypeComments,
                'feedback': subTypeFeedback,
              },
            ],
            'additionalComments': additionalComments,
          },
        ],
      },
    };
  }

// Function to load images based on their paths
  Future<List<File>> loadImages(List<String> imagePaths) async {
    final imageFiles = <File>[];
    for (String path in imagePaths) {
      final file = File(path);
      if (await file.exists()) {
        imageFiles.add(file);
      }
    }
    return imageFiles;
  }

  // Example usage
  void exampleUsage() async {
    final data = await getSharedPreferencesData();
    final imagePaths = List<String>.from(
        data['inspectionDto']['inspectionReports'][0]['subTypes'][0]['images']);
    final imageFiles = await loadImages(imagePaths);

    // Now you have the list of image files and can use them as needed
  }

  // void onPreviewPressed() async {
  //   final data = await getSharedPreferencesData();
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => InspectionConfimationPage(
  //         finalDate: data,),
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   getFirebaseUserId();
  //   // fetchProperties();
  //   controller = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
  //   super.initState();
  //
  // }

  // Future<void> _saveData() async {
  //   try {
  //     await sendPropertyData(property);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Data saved successfully!'),
  //     ));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Failed to save data: $e'),
  //     ));
  //   }
  // }

  // Future<void> sendPropertyData(PropertyDto property) async {
  //   final url = '$baseURL/summary/generateReport'; // Replace with your backend URL
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode(property.toJson());
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body,
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to save data: ${response.reasonPhrase}');
  //   }
  // }

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

  // void _previewReport() async {
  //   try {
  //     // Pass all types, subtypes, and images from the form into the DTO
  //     property.inspectionDto!.inspectionReports[0].subTypes = [
  //       SubTypeDto(
  //         subTypeId: 'subType001',
  //         subTypeName: 'Overview - Odours',
  //         imageUrls: [], // Initially empty, will be populated after upload
  //         images: selectedImages, // List of image files selected by user
  //         comments: 'Condition: Good, Additional Comments: Good',
  //         feedback: '',
  //       ),
  //       // Add more subtypes as necessary
  //     ];
  //
  //     // Navigate to preview or call _saveData if needed
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PreviewPage(property: property),
  //       ),
  //     );
  //   } catch (e) {
  //     print("Error in previewing report: $e");
  //   }
  // }
  //
  // Future<void> sendPropertyData(PropertyDto property) async {
  //   final url = '$baseURL/summary/generateReport';
  //   final headers = {'Content-Type': 'application/json'};
  //
  //   // Upload images first, then update imageUrls in DTO
  //   for (var report in property.inspectionDto.inspectionReports) {
  //     for (var subType in report.subTypes) {
  //       await uploadImages(subType);
  //     }
  //   }
  //
  //   final body = jsonEncode(property.toJson());
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body,
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to save data: ${response.reasonPhrase}');
  //   }
  // }
  //
  // Future<void> uploadImages(SubTypeDto subType) async {
  //   final url = '$baseURL/uploadImages';
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //   // Attach the images to the request
  //   for (File image in subType.images) {
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'images',
  //         image.path,
  //       ),
  //     );
  //   }
  //
  //   final response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     List<String> uploadedImageUrls = jsonDecode(responseBody);
  //
  //     // Update imageUrls with uploaded URLs
  //     subType.imageUrls.addAll(uploadedImageUrls);
  //   } else {
  //     throw Exception('Failed to upload images');
  //   }
  // }

  // Future<void> sendPropertyData(PropertyDto.dart property) async {
  //   final url = 'http://your-backend-url/api/property';
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode(property.toJson());
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Data sent successfully');
  //   } else {
  //     print('Failed to send data: ${response.reasonPhrase}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      //Schedule of Condition',
      {
        'title': '1. Schedule of Condition',
        'icon': Icons.schedule,
        'subItems': [
          // Overview
          {
            'title': '1.1 Overview - Odours',
            'details': [
              {'label': 'Condition', 'value': "overview"},
              {'label': 'Additional Comments', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Genral Cleanliness',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.3 Bathroom/En Suite/ Toilet(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.4 Carpets',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.5 Ceiling(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.6 Curtains/Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.7 Hard Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.8 Kitchen Area',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.9 Kitchen - White Goods',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.10 Oven/Hob/Extractor Hood/Cooker',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.11 Mattress(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.12 Upholstery',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.13 Wall(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.14 Window(s)',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.15 Woodwork',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          // {
          //   'title': '1.2 Name - Cleanliness',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Clean'},
          //   ],
          //   'images': ['path_to_image3', 'path_to_image4']
          //   // Use image paths or URLs
          // },
        ],
      },
      {
        'title': '2. EV Charger(s)',
        'icon': Icons.charging_station,
        'subItems': [
          {
            'title': '2.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '3. Meter Readings',
        'icon': Icons.gas_meter,
        'subItems': [
          {
            'title': '3.1 Gas Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '3.2 Electric Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '3.3 Water Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '3.4 Oil Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '3.5 Other ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '4. Keys',
        'icon': Icons.key,
        'subItems': [
          {
            'title': '4.1 Yale ',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '4.2 Mortice',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.3 Window Lock',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.4 Gas/Electric Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.5 Car Pass/Permit ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.6 Remote/Security Fob ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.7 Other ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '5. Keys Handed Over At Check In',
        'icon': Icons.key,
        'subItems': [
          {
            'title': '5.1 Yale',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '5.2 Mortice',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '5.3 Other',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '6. Health & Safety | Smoke & Carbon Monoxide Alarms',
        'icon': Icons.health_and_safety,
        'subItems': [
          {
            'title': '6.1 Smoke Alarm(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '6.2 Heat Sensor Alarm(s)',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '6.3 Carbon Monoxide Alarm(s)',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '7. Garage',
        'icon': Icons.garage,
        'subItems': [
          {
            'title': '7.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '7.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.5 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.6 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.7 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.8 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.9 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.10 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.11 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '8. Front Garden',
        'icon': Icons.lightbulb,
        'subItems': [
          {
            'title': '8.1 Garden Discritpion',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '8.2 DriveWay',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '8.3 Outside Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '8.4 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '9. Exterior Front',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '9.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.4 Porch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.5 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '10. Entrance Hallway',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '10.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.4 Door Bell/Reciever',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.5 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.12 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.13 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.14 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.15 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.16 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '11. Toilet',
        'icon': Icons.wash_rounded,
        'subItems': [
          {
            'title': '11.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.10 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.11 Toilet',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.12 Basin',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.13 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.14 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.15 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.16 Accessories',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.17 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.18 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '12. Lounge',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '12.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.5 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.6 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.7 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.8 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.9 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.10 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.11 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.12 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.13 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.14 Fireplace',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.15 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.16 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '13. Kitchen',
        'icon': Icons.kitchen,
        'subItems': [
          {
            'title': '13.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.12 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.13 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.14 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.15 Kitchen Units',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.16 Extractor Hood',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.17 Cooker',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.18 Hod',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.19 Oven',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.20 Worktop(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.21 Sink',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.22 Fridge/Freezer',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.24 Dishwasher',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.25 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.26 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '14. Utility Room/Area',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '14.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.12 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.13 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.14 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.15 Kitchen Units',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.16 Worktop(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.17 Sink',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.18 Fridge/Freezer',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.19 Washing Machine',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.20 Dishwasher',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.21 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.22 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '15. Stairs',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '15.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.2 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.3 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.4 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.5 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.6 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.7 Curtains',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.8 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.9 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.10 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.11 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.12 Staircase',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.13 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.14 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '16. Landing',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '16.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.2 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.3 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.4 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.5 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.6 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.7 Curtains',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.8 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.9 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.10 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.11 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.12 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.13 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '17. Bedroom 1',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '17.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.5 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.6 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.7 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.8 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.9 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.10 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.11 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.12 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.13 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.14 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.15 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '18. En-Suite',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '18.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.12 Toilet',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.13 Basin',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.14 Shower Unit/Cubicle',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.15 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.16 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.17 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.18 Accessories',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.19 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.20 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '19. Bedroom ',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '19.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.12 Toilet',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.13 Basin',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.14 Shower Unit/Cubicle',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.15 Bath/ Bath Panels',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.16 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.17 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.18 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.19 Accessories',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.20 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.21 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '20. Rear Garden',
        'icon': Icons.landscape,
        'subItems': [
          {
            'title': '20.1 Garden Description',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.2 Outside Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.3 Summer House',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.4 Shed(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.5 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '21. Manuals & Certificates',
        'icon': Icons.receipt_long,
        'subItems': [
          {
            'title': '21.1 House Application Manual',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.2 Kitchen Appliances Manuals',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.3 Heating System Manual',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.4 Landlord Gas Safety Certificate',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.5 Legionella Risk Assessment',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.6 Electrical Safety Certificate',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.7 Energy Performance Certificate',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.8 Move In Checklist',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '22. Property Receipts',
        'icon': Icons.receipt_long,
        'subItems': [
          {
            'title': '22.1 Receipts',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },

      // Add more headings here
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report Preview',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingScreen(),
                ),
              );
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       elevation: 10,
              //       backgroundColor: Colors.white,
              //       title: Row(
              //         children: [
              //           Icon(Icons.info_outline, color: kPrimaryColor),
              //           SizedBox(width: 10),
              //           Text(
              //             'Do you want to Exit',
              //             style: TextStyle(
              //               color: kPrimaryColor,
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //       content: Text(
              //         'Your process will not be saved if you exit the process',
              //         style: TextStyle(
              //           color: Colors.grey[800],
              //           fontSize: 14,
              //           fontWeight: FontWeight.w400,
              //           height: 1.5,
              //         ),
              //       ),
              //       actions: <Widget>[
              //         TextButton(
              //           child: Text(
              //             'Cancel',
              //             style: TextStyle(
              //               color: kPrimaryColor,
              //               fontSize: 16,
              //             ),
              //           ),
              //           onPressed: () {
              //             Navigator.of(context).pop(); // Close the dialog
              //           },
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             Navigator.pushReplacement(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => LandingScreen()),
              //             ); // Close the dialog
              //           },
              //           style: TextButton.styleFrom(
              //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //             backgroundColor: kPrimaryColor,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //           ),
              //           child: Text(
              //             'Exit',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //             ),
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // );
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: kPrimaryColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                _saveData();// Link the save button to the function
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       elevation: 10,
                //       backgroundColor: Colors.white,
                //       title: Row(
                //         children: [
                //           Icon(Icons.info_outline, color: kPrimaryColor),
                //           SizedBox(width: 10),
                //           Text(
                //             'Continue Saving',
                //             style: TextStyle(
                //               color: kPrimaryColor,
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ],
                //       ),
                //       content: Text(
                //         'You Cannot make any changes after you save the Property',
                //         style: TextStyle(
                //           color: Colors.grey[800],
                //           fontSize: 14,
                //           fontWeight: FontWeight.w400,
                //           height: 1.5,
                //         ),
                //       ),
                //       actions: <Widget>[
                //         TextButton(
                //           child: Text('Cancel',
                //             style: TextStyle(
                //               color: kPrimaryColor,
                //               fontSize: 16,
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.of(context).pop(); // Close the dialog
                //           },
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(builder: (context) => DetailsConfirmationPage(
                //                 lineOneAddress: widget.lineOneAddress,
                //                 lineTwoAddress: widget.lineTwoAddress,
                //                 city: widget.city,
                //                 state: widget.state,
                //                 country: widget.country,
                //                 postalCode: widget.postalCode,
                //                 reference: widget.reference,
                //                 client: widget.client,
                //                 type: widget.type,
                //                 furnishing: widget.furnishing,
                //                 noOfBeds: widget.noOfBeds,
                //                 noOfBaths: widget.noOfBaths,
                //                 garage: garageSelected,
                //                 parking: parkingSelected,
                //                 notes: widget.notes,
                //                 selectedType: selectedType.toString(),
                //                 date: selectedDate,
                //                 time: selectedTime,
                //                 keyLocation: keysIwth.toString(),
                //                 referenceForKey: referenceController.text,
                //                 internalNotes: internalNotesController.text,
                //               )),
                //             );
                //           },
                //           style: TextButton.styleFrom(
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 16, vertical: 8),
                //             backgroundColor: kPrimaryColor,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //           child: Text(
                //             'Continue',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 16,
                //             ),
                //           ),
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Save', // Replace with the actual location
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14, // Adjust the font size
                    fontFamily: "Inter",
                  ),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // Prevents ListView from scrolling independently
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ExpansionTile(
                      title: Text(item['title']),
                      leading: Icon(
                        item['icon'],
                        color: kPrimaryColor,
                      ),
                      children: item['subItems'].map<Widget>((subItem) {
                        return ExpansionTile(
                          title: Text(subItem['title']),
                          children: [
                            Column(
                              children:
                                  subItem['details'].map<Widget>((detail) {
                                return ListTile(
                                  title: Text(detail['label']),
                                  subtitle: Text(detail['value']),
                                );
                              }).toList(),
                            ),
                            Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subItem['images'].length,
                                itemBuilder: (context, imgIndex) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    width: 100,
                                    child: Image.asset(subItem['images'][
                                        imgIndex]), // Use Image.network() for URLs
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Text('Declaration',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14, // Adjust the font size
                      fontFamily: "Inter",
                    )),
                const SizedBox(height: 15),
                const Text(
                    'I/We the undersigned, affirm  that if I/we do not'
                    ' comment on the inventory in writing within seven days '
                    'of receipt of this inventory I/We accept the inventory '
                    'as being an accurate record of the contents and '
                    'conditions of the property',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: kPrimaryTextColourTwo,
                      fontSize: 12, // Adjust the font size
                      fontFamily: "Inter",
                    )),
                const SizedBox(height: 15),
                const Text('Please put the signature here',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14, // Adjust the font size
                      fontFamily: "Inter",
                    )),
                const SizedBox(height: 15),
                Card(
                  child: Center(
                    child: Signature(
                      height: 200,
                      width: double.maxFinite,
                      controller: controller!,
                      backgroundColor: bWhite,
                    ),
                  ),
                ),
                buttonWidgets(context)!,
                const SizedBox(height: 30),
                signature != null
                    ? Column(
                        children: [
                          Center(child: Image.memory(signature!)),
                          const SizedBox(height: 10),
                          MaterialButton(
                            color: Colors.green,
                            onPressed: () {},
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buttonWidgets(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // TextButton(
        //   onPressed: () async {
        //     if (controller!.isNotEmpty) {
        //       final sign = await exportSignature();
        //       setState(() {
        //         signature = sign;
        //       });
        //     } else {
        //       //showMessage
        //       // Please put your signature;
        //     }
        //   },
        //   child: const Text("Preview",
        //       style: TextStyle(fontSize: 20, color: kPrimaryColor)),
        // ),
        TextButton(
          onPressed: () {
            controller?.clear();
            setState(() {
              signature = null;
            });
          },
          child: const Text("Re-Sign",
              style: TextStyle(fontSize: 20, color: Colors.redAccent)),
        ),
      ],
    );
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      points: controller!.points,
    );

    final signature = exportController.toPngBytes();

    //clean up the memory
    exportController.dispose();

    return signature;
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
