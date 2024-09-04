import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ImageStorage {
  static const String _keyCapturedImages = 'capturedImages';

  // Save image path to SharedPreferences
  static Future<void> saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> imagePaths = prefs.getStringList(_keyCapturedImages) ?? [];
    imagePaths.add(imagePath);
    await prefs.setStringList(_keyCapturedImages, imagePaths);
  }

  // Load image paths from SharedPreferences
  static Future<List<File>> loadImagePaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> imagePaths = prefs.getStringList(_keyCapturedImages) ?? [];
    return imagePaths.map((path) => File(path)).toList();
  }
}