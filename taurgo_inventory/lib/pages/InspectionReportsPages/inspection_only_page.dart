import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart'; // Add this
import 'package:permission_handler/permission_handler.dart';
import 'package:taurgo_inventory/pages/InspectionReportsPages/preview_inspection_page.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import '../../constants/AppColors.dart';

class InspectionOnlyPage extends StatefulWidget {
  final String propertyId;

  const InspectionOnlyPage({super.key, required this.propertyId});

  @override
  State<InspectionOnlyPage> createState() => _InspectionOnlyPageState();
}

class _InspectionOnlyPageState extends State<InspectionOnlyPage> {
  List<File> images = []; // List to store selected images

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to open gallery and select images
  Future<void> pickImageFromGallery() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      final List<XFile>? imageFiles = await _picker.pickMultiImage();
      if (imageFiles != null && imageFiles.isNotEmpty) {
        List<File> newImages =
            imageFiles.map((XFile image) => File(image.path)).toList();

        setState(() {
          images.addAll(newImages);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPrimaryColor,
            content: Text(
              '${imageFiles.length} image(s) selected from gallery',
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
          images.add(File(capturedImage.path));
        });

        // Show a dialog asking if the user wants to capture another image
        bool? shouldContinue = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              'Inspection',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
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
                                  builder: (context) => HomePage()),
                            );
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
                onTap: () {
                  if(images.isNotEmpty){
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
                                'Continue',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Please make sure you have selected the pictures',
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
                                      builder: (context) => PreviewInspectionPage(propertyId: widget.propertyId, images: images)),
                                );
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
                                'Continue',
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
                  else{
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
                                'No Image Selected',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Please make sure you have selected at least a '
                                'picture to generate a report',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          actions: <Widget>[

                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
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
                                'OK',
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
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              )
            ]),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 500,
                  child: images.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 100),
                                Center(
                                  child: Image.asset(
                                    "assets/images/onboarding3.png",
                                    height: 200,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'No Images Selected',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Inter",
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                  child: Image.file(
                                    images[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        images.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: pickImageFromGallery,
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: bWhite,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 2.0,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_sharp,
                            color: kPrimaryColor,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Gallery",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: captureMultipleImagesWithCamera,
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 2.0,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            color: bWhite,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Camera",
                            style: TextStyle(
                              color: bWhite,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MultiImageCapturePage extends StatefulWidget {
  @override
  _MultiImageCapturePageState createState() => _MultiImageCapturePageState();
}

class _MultiImageCapturePageState extends State<MultiImageCapturePage> {
  late CameraController _controller;
  List<File> capturedImages = [];
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> captureImage() async {
    if (!_controller.value.isInitialized) {
      print('Camera not initialized');
      return;
    }

    try {
      final image = await _controller.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/${DateTime.now()}.jpg');

      await File(image.path).copy(imagePath.path);

      setState(() {
        capturedImages.add(imagePath);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Image Capture'),
        actions: [
          if (capturedImages.isNotEmpty)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, capturedImages); // Pass back the images
              },
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isCameraInitialized
                ? CameraPreview(_controller)
                : Center(child: CircularProgressIndicator()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Capture Image'),
                onPressed: captureImage,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.done),
                label: Text('Finish'),
                onPressed: () {
                  Navigator.pop(context, capturedImages); // Finish capturing
                },
              ),
            ],
          ),
          if (capturedImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: capturedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      capturedImages[index],
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
