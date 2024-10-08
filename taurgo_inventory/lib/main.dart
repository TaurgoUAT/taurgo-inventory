// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taurgo_inventory/pages/authentication/controller/authController.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';

import 'constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await MongoDatabase.connect();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
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
      home: const HomePage(),
      // home: const Homepage(),
    );
  }
}
