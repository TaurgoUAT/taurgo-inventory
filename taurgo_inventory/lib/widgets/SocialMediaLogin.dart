import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taurgo_inventory/pages/authentication/controller/authController.dart';



class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialIconButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
      ),
      child: IconButton(
        icon: FaIcon(icon),
        color: color,
        iconSize: 30.0,
        onPressed: onPressed,
      ),
    );
  }
}

class SocialMediaLogin extends StatelessWidget {
  const SocialMediaLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google Sign-In Button
        SocialIconButton(
          icon: FontAwesomeIcons.google,
          color: Colors.red,
          onPressed: () async {
            try {
              await AuthController.instance.signInWithGoogle();
              print("Google login successful");
              // Navigate to the next screen or update the UI accordingly
            } catch (e) {
              print("Google login failed: $e");
              // Optionally, display an error message to the user
            }
          },
        ),

        // Facebook Sign-In Button
        SocialIconButton(
          icon: FontAwesomeIcons.facebook,
          color: Colors.blue,
          onPressed: () {
            print("Facebook login");
            // Implement Facebook login functionality
          },
        ),

        // Apple Sign-In Button
        SocialIconButton(
          icon: FontAwesomeIcons.apple,
          color: Colors.black,
          onPressed: () async {
            try {
              await AuthController.instance.signInWithApple();
              print("Apple login successful");
              // Navigate to the next screen or update the UI accordingly
            } catch (e) {
              print("Apple login failed: $e");
              // Optionally, display an error message to the user
            }
          },
        ),
      ],
    );
  }
}