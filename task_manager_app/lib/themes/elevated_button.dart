import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

ElevatedButtonThemeData getElevatedButtonThemeData() => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.themeColor,
        foregroundColor: AppColor.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );