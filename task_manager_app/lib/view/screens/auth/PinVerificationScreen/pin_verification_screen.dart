import 'dart:async';

import 'package:flutter/material.dart';


import '../../../../data/model/login_model.dart';

import '../../../../data/model/network_response.dart';
import '../../../../data/network_caller.dart/network_caller.dart';
import '../../../../utils/api_url.dart';
import '../../../../utils/app_colors.dart';

import '../../../../utils/app_route.dart';
import '../../../utility/on_tap_action.dart';

import '../../../widgets/background_widget.dart';
import '../../../widgets/bottom_rich_text.dart';
import '../../../widgets/elevated_text_buttons.dart';
import '../../../widgets/loading_dialog.dart';

import '../../../widgets/one_button_dialog.dart';
import 'Inner/custom_pin_code_text_field.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinVerificationTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loadingInProgress = false;
  late Timer _timer;
  int _start = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),

                  ///------Header text------///
                  Text(
                    "PIN Verification",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  ///------Sub Header Text------///
                  Text(
                    "A 6 digit verification pin has sent to your email address.",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  ///------Pin Verification Input Field------///
                  Form(
                    key: _formKey,
                    child: CustomPinCodeTextField(
                      context,
                      _pinVerificationTextEditingController,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ///------Resend otp section------///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$_start s",
                        style: const TextStyle(
                          color: AppColor.themeColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: _isResendEnabled ? _resendOtp : null,
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            color: _isResendEnabled ? AppColor.themeColor : Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ///------Verify Button------///
                  ElevatedTextButton(
                    text: "Verify",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _otpVerification();
                        //OnTapAction.onTapGoResetPasswordScreen(context);
                      }
                    },
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  ///------Sign in text------///
                  Center(
                    child: BottomRichText(
                      text01: "Have account?",
                      text02: "Sign In",
                      onTap: () => OnTapAction.onTapRemoveUntil(context, AppRoute.loginScreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _otpVerification() async {
    _loadingInProgress = true;

    String otp = _pinVerificationTextEditingController.text.trim();

    loadingDialog(context);

    String url = "${ApiUrl.recoverVerifyOTP}/${widget.email}/$otp";
    NetworkResponse response = await NetworkCaller.getResponse(url);

    _loadingInProgress = false;

    if (mounted) {
      Navigator.pop(context);
    }

    if (response.responseData['status'] == 'success') {
      _clearOtpField();
      if (mounted) {
        OnTapAction.onTapGoResetPasswordScreen(
          context,
          widget.email,
          otp,
        );
      }
    } else if (response.responseData['status'] == 'fail') {
      _clearOtpField();
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Please enter valid otp!",
          Icons.error_outline_rounded,
          () {
            Navigator.pop(context);
          },
        );
      }
    } else {
      _clearOtpField();
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Something went wrong!",
          Icons.error_outline_rounded,
          () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  void _resendOtp() async {
    _loadingInProgress = true;

    loadingDialog(context);

    NetworkResponse response = await NetworkCaller.getResponse(
      "${ApiUrl.recoverVerifyEmail}/${widget.email}",
    );

    _loadingInProgress = false;

    if (mounted) {
      Navigator.pop(context);
    }

    if (response.responseData['status'] == 'success') {
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.themeColor,
          AppColor.themeColor,
          "Resend success!",
          "Please check your email and collect otp.",
          Icons.task_alt,
              () {
            Navigator.pop(context);
          },
        );
      }
    }else {
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Otp send failed, Resend again!",
          Icons.task_alt,
              () {
            Navigator.pop(context);
          },
        );
      }
    }
    _startTimer();
  }

  void _startTimer() {
    _isResendEnabled = false;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _clearOtpField() {
    _pinVerificationTextEditingController.clear();
  }

  @override
  void dispose() {
    _pinVerificationTextEditingController.dispose();
    super.dispose();
  }
}