import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';

import 'constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taurgo',
      theme: ThemeData(
        scaffoldBackgroundColor: bWhite,
        appBarTheme: AppBarTheme(
          backgroundColor: bWhite,
          iconTheme:
          IconThemeData(color: kPrimaryColor),
        ),
      ),
      home: const LandingScreen(),
      // home: const Homepage(),
    );
  }
}
