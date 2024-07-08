import 'package:flutter/cupertino.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    this.text01,
    this.text02,
    this.firstTextSize,
    this.secondTextSize,
    this.firstTxtColor,
    this.secondTextColor,
  });

  final String? text01;
  final String? text02;
  final double? firstTextSize;
  final double? secondTextSize;
  final Color? firstTxtColor;
  final Color? secondTextColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text01,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: firstTextSize,
          color: firstTxtColor,
        ),
        children: [
          TextSpan(
            text: text02,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: secondTextSize,
              color: secondTextColor,
            ),
          ),
        ],
      ),
    );
  }
}