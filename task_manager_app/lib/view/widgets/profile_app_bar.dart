import 'package:flutter/material.dart';
import '../Controller/auth_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_route.dart';
import '../utility/on_tap_action.dart';
import 'custom_circle_avatar.dart';

AppBar profileAppBar(BuildContext context) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.only(left: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.profileInfo);
        },
        child: CustomCircleAvatar(
          imageString: AuthController.userData?.photo ?? '',
          imageWidth: 40,
          imageHeight: 40,
          imageRadius: 50,
        ),
      ),
    ),
    title: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.profileInfo);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: AppColor.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          AuthController.clearAllData();
          OnTapAction.onTapRemoveUntil(context, AppRoute.loginScreen);
        },
        icon: const Icon(Icons.logout),
      ),
    ],
  );
}