import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taurgo_inventory/pages/camera_preview_page.dart';
import 'package:taurgo_inventory/pages/conditions/condition_details.dart';
import 'package:taurgo_inventory/pages/edit_report_page.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/AppColors.dart';
import '../../widgets/ConditionItem.dart';
class CapturedImagesPage extends StatelessWidget {
  final List<File> images;

  CapturedImagesPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Captured Images',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 14,
            fontFamily: "Inter",
          ),
        ),
        backgroundColor: bWhite,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.file(images[index]);
        },
      ),
    );
  }
}
