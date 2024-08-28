import 'package:flutter/material.dart';

import '../../../constants/AppColors.dart';

class SignUpCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 40.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up Now',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
          SizedBox(height: 12,),
          Text(
            'Enter the details and Create an Account',
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
