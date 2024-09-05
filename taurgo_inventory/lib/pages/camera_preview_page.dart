import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taurgo_inventory/pages/reportPages/schedule_of_condition.dart';
import '../../constants/AppColors.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';

class CameraPreviewPage extends StatefulWidget {
  final CameraController cameraController;
  const CameraPreviewPage({super.key, required this.cameraController});

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  late CameraController _cameraController;
  final ImagePicker _picker = ImagePicker();
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the camera in the initState
    _initializeControllerFuture = _initializeCamera();
  }


  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    await _cameraController.initialize();
  }

  List<File> capturedImages = [];


  Future<void> _capturePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {

        final image = await _cameraController!.takePicture();
        setState(() {
          capturedImages.add(File(image.path));
          print('Image Captured: ${image.path}');
          // Save the captured image
        });
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Image picked from gallery: ${pickedFile.path}');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameraController.description.lensDirection ==
        CameraLensDirection.back) {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front);
      if (frontCamera != null) {
        setState(() {
          _cameraController =
              CameraController(frontCamera, ResolutionPreset.high);
          _initializeControllerFuture = _cameraController.initialize();
        });
      }
    } else {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
      if (backCamera != null) {
        setState(() {
          _cameraController =
              CameraController(backCamera, ResolutionPreset.high);
          _initializeControllerFuture = _cameraController.initialize();
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule of Condition',
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EditReportPage(propertyId: '',),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: kPrimaryColor,
            size: 24,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ScheduleOfCondition(capturedImages: capturedImages, propertyId: '',),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Done',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 14,
                  fontFamily: "Inter",
                ),
              ),
            ),
          )

        ],

      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
                // Optional: add other widgets on top of the preview if needed
              ],
            );
          } else {
            return Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                  strokeWidth: 6.0,
                  strokeCap: StrokeCap.square,
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.cameraswitch_sharp, color: kPrimaryColor),
              onPressed: () {
                _switchCamera();
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, color: kPrimaryColor),
              onPressed: () {
                _capturePhoto();
              },
            ),
            IconButton(
              icon: Icon(Icons.photo_library, color: kPrimaryColor),
              onPressed: () {
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }
}
