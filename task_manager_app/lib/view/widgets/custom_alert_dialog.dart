import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';


Future<dynamic> customAlertDialog(
  BuildContext context,
  String title,
  VoidCallback noButton,
  VoidCallback yesButton,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: AppColor.white,
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () {
              noButton();
            },
            child: const Text(
              'No',
              style: TextStyle(color: AppColor.themeColor),
            ),
          ),
          TextButton(
            onPressed: () {
              yesButton();
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: AppColor.themeColor),
            ),
          ),
        ],
      );
    },
  );
}