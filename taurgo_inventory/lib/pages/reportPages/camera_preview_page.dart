import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/constants/AppColors.dart';

class CameraPreviewPage extends StatefulWidget {
  final CameraDescription camera;
  final Function(String) onPictureTaken;

  CameraPreviewPage({required this.camera, required this.onPictureTaken});

  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            widget.onPictureTaken(image.path);
            Navigator.pop(context);
          } catch (e) {
            print(e);
          }
        },
        backgroundColor: kPrimaryColor, // Use your app's primary color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded shape to match app style
        ),


        child: Icon(
          Icons.camera_alt_outlined,
          size: 30, // You can adjust the size based on your app's style
          color: Colors.white, // Make the icon color white to contrast with the background
        ),
        elevation: 5, // Add a slight shadow effect if it fits your design
      ),
    );
  }
}
