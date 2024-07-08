import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';


Future<dynamic> loadingDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          height: 70,
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.white,
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColor.themeColor,
              ),
              SizedBox(
                width: 20,
              ),
              Material(
                color: Colors.transparent,
                child: Text(
                  "Loading",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.themeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}