import 'package:flutter/material.dart';

import '../../../constants/AppColors.dart';

class SignInCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
          SizedBox(height: 12,),
          Text(
            'Please Sign In to Continue',
            style: TextStyle(
              color: kSecondaryTextColour,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: "Inter",
            ),
          ),
        ],
      ),
    );
  }
}
