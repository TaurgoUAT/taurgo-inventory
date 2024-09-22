import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/authentication/controller/authController.dart';


class SocialMediaLogin extends StatelessWidget {
  const SocialMediaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // crossAxisAlignment: CrossAxisAlignment.start,// Center the icons horizontally
      children: [
        // Google Icon with Rounded Container
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,                 // Rounded shape
            color: Colors.red.withOpacity(0.1),     // Light red background color
          ),
          child: IconButton(
            icon: const FaIcon(FontAwesomeIcons.google),   // Google icon
            color: Colors.red,                       // Google brand color
            iconSize: 30.0,                          // Icon size
            onPressed: () async {
              await AuthController.instance.signInWithGoogle();
              print("Google login");
            },
          ),
        ),

        // Facebook Icon with Rounded Container
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,                 // Rounded shape
            color: Colors.blue.withOpacity(0.1),    // Light blue background color
          ),
          child: IconButton(
            icon: const FaIcon(FontAwesomeIcons.facebook), // Facebook icon
            color: Colors.blue,                      // Facebook brand color
            iconSize: 30.0,                          // Icon size
            onPressed: () {
              print("Facebook login");
            },
          ),
        ),

        // Apple Icon with Rounded Container
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,                 // Rounded shape
            color: Colors.black.withOpacity(0.1),   // Light black background color
          ),
          child: IconButton(
            icon: const FaIcon(FontAwesomeIcons.apple),    // Apple icon
            color: Colors.black,                     // Apple brand color
            iconSize: 30.0,                          // Icon size
            onPressed: () {
              print("Apple login");
            },
          ),
        ),
      ],
    );
  }
}
