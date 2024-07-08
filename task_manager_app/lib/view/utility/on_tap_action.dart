import 'package:flutter/cupertino.dart';
import '../../utils/app_route.dart';

class OnTapAction {
  //auth part
  static void onTapGoForgotPasswordScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.forgetScreen);
  }

  static void onTapGoSignUpScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.signupScreen);
  }

  static void onTapGoPinVerificationScreen(BuildContext context, String email) {
    Navigator.pushNamed(context, AppRoute.pinVerificationScreen, arguments: email);
  }

  static void onTapGoResetPasswordScreen(BuildContext context, String email, String otp) {
    Navigator.pushNamed(
      context,
      AppRoute.resetPasswordScreen,
      arguments: {
        'email': email,
        'otp': otp,
      },
    );
  }

  //main part
  static void onTapGoMainBottomBar(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoute.mainBottomBar);
  }

  static void onTapGoUpdateProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.updateProfileScreen);
  }

  static void onTapGoAddNewTaskScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.addNewTaskScreen);
  }

  static void onTapRemoveUntil(BuildContext context, String screen) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      screen,
      (Route<dynamic> route) => false,
    );
  }
}