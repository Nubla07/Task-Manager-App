
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

DelightToastBar setCustomToast(
  String? message,
  IconData? icon,
  Color? backgroundColor,
  Color? foregroundColor,
) {
  return DelightToastBar(
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
    snackbarDuration: Durations.extralong4,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: foregroundColor,
                size: 18,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  message!,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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