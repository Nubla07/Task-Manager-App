import 'package:flutter/material.dart';
import '../utils/app_colors.dart';


TextTheme getTextTheme() => const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColor.black,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );