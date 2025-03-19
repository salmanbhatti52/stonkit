import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RichTextMd extends StatelessWidget {
  const RichTextMd(
      {super.key,
      required this.text1,
      required this.text2,
      this.text1style,
      this.text2style,
      this.onTap});
  final String text1;
  final String text2;
  final TextStyle? text1style;
  final TextStyle? text2style;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: text1style ?? kTwelveRegular050B15Poppins,
          ),
          TextSpan(
            text: ' ',
          ),
          TextSpan(
              text: text2,
              style: text2style ??
                  kTwelveRegular050B15Poppins.copyWith(
                    decoration: TextDecoration.underline,
                  ),

              // Add a tap gesture recognizer for the link
              recognizer: TapGestureRecognizer()..onTap = onTap),
        ],
      ),
    );
  }
}
