import 'package:flutter/material.dart';
import '../utils/app_colors.dart';


AppBarTheme getAppBarTheme() => const AppBarTheme(
      backgroundColor: AppColor.themeColor,
      foregroundColor: AppColor.white,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
    );