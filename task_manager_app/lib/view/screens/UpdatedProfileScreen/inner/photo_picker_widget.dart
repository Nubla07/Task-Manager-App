import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

Widget photoPickerWidget(VoidCallback? onTap, String? selectedImageName) {
  return Container(
    height: 50,
    width: double.maxFinite,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColor.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: const Text(
              "Photo",
              style: TextStyle(
                color: AppColor.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            selectedImageName??"No image selected",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}