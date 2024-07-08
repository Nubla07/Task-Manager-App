import 'package:flutter/material.dart';
import '../../../../utils/app_route.dart';
import '../../../data/model/network_response.dart';
import '../../../data/network_caller.dart/network_caller.dart';
import '../../../utils/api_url.dart';
import '../../../utils/app_colors.dart';
import '../../utility/on_tap_action.dart';
import '../../utility/validate_checking.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/bottom_rich_text.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/elevated_text_buttons.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/one_button_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loadingInProgress = false;

  bool _obscureText01 = true;
  bool _obscureText02 = true;

  void _toggleObscureText01() {
    setState(() {
      _obscureText01 = !_obscureText01;
    });
  }

  void _toggleObscureText02() {
    setState(() {
      _obscureText02 = !_obscureText02;
    });
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
                ///------Header Text------///
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Set Password",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                ///------Sub Header Text------///
                Text(
                  "Minimum length password 8 character with latter, symbol and number.",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),

                      ///------Password Text Field------///
                      TextFormField(
                        controller: _passwordTextEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: AppColor.themeColor,
                        obscureText: _obscureText01,
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: _toggleObscureText01,
                            icon: Icon(
                              _obscureText01 ? Icons.visibility : Icons.visibility_off,
                              color: AppColor.grey,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          return ValidateCheckingFun.validatePassword(value);
                        },
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      ///------Confirm Password Text Field------///
                      TextFormField(
                        controller: _confirmPasswordTextEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: AppColor.themeColor,
                        obscureText: _obscureText02,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          suffixIcon: IconButton(
                            onPressed: _toggleObscureText02,
                            icon: Icon(
                              _obscureText02 ? Icons.visibility : Icons.visibility_off,
                              color: AppColor.grey,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          return ValidateCheckingFun.validatePassword(value);
                        },
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      ///------Confirm Button------///
                      ElevatedTextButton(
                        text: "Confirm",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_passwordTextEditingController.text !=
                                _confirmPasswordTextEditingController.text) {
                              setCustomToast(
                                "Password not match! Enter same password.",
                                Icons.error_outline,
                                AppColor.red,
                                AppColor.white,
                              ).show(context);
                            } else {
                              _resetPassword();
                            }
                          }
                        },
                      ),

                      const SizedBox(
                        height: 30,
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
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _resetPassword() async {
    _loadingInProgress = true;

    loadingDialog(context);

    Map<String, dynamic> requestInput = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _confirmPasswordTextEditingController.text
    };

    String url = ApiUrl.recoverResetPass;
    NetworkResponse response = await NetworkCaller.postResponse(url, body: requestInput);

    _loadingInProgress = false;

    if (mounted) {
      Navigator.pop(context);
    }

    if (response.responseData['status'] == 'success') {
      _clearTextField();
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.themeColor,
          AppColor.themeColor,
          "Success!",
          "Password reset success.",
          Icons.task_alt,
          () {
            OnTapAction.onTapRemoveUntil(context, AppRoute.loginScreen);
          },
        );
      }
    } else if (response.responseData['status'] == 'fail') {
      _clearTextField();
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Email or otp not valid, try again.",
          Icons.task_alt,
          () {
            Navigator.pop(context);
          },
        );
      }
    } else {
      _clearTextField();
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Something went wrong, try again.",
          Icons.task_alt,
              () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  void _clearTextField() {
    _passwordTextEditingController.clear();
    _confirmPasswordTextEditingController.clear();
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    super.dispose();
  }
}