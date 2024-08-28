import 'package:flutter/material.dart';

import '../../../constants/AppColors.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle update password logic here
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          child: Text('Sign Up', style: TextStyle(fontSize: 18)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
