import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

InputDecorationTheme getInputDecorationTheme() => const InputDecorationTheme(
      fillColor: AppColor.white,
      filled: true,
      hintStyle: TextStyle(
        color: AppColor.grey,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    );