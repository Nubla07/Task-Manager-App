import 'package:flutter/material.dart';
import '../../../data/model/network_response.dart';
import '../../../data/network_caller.dart/network_caller.dart';
import '../../../utils/api_url.dart';
import '../../../utils/app_colors.dart';
import '../../utility/on_tap_action.dart';
import '../../utility/validate_checking.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/bottom_rich_text.dart';
import '../../widgets/elevated_icon_button.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/one_button_dialog.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _otpSendInProgress = false;

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
                    "Your Email Address",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  ///------Sub Header Text------///
                  Text(
                    "A 6 digit verification pin will send to your email address.",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  ///------Email Text Field------///
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: AppColor.themeColor,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (String? value) {
                        return ValidateCheckingFun.validateEmail(value);
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ///------Button------///
                  ElevatedIconButton(
                    icon: Icons.arrow_circle_right_outlined,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _sendOtp();
                        //OnTapAction.onTapGoPinVerificationScreen(context);
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
                      onTap: () => Navigator.pop(context),
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

  void _sendOtp() async {
    _otpSendInProgress = true;
    loadingDialog(context);

    String email = _emailTextEditingController.text.trim();

    NetworkResponse response = await NetworkCaller.getResponse(
      "${ApiUrl.recoverVerifyEmail}/$email",
    );

    _otpSendInProgress = false;
    if (mounted) {
      Navigator.pop(context);
    }

    if (response.responseData['status'] == 'success') {
      _clearTextField();
      if (mounted) {
        OnTapAction.onTapGoPinVerificationScreen(context, email);
      }
    } else if (response.responseData['status'] == 'fail') {
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "This email is not registered!",
          Icons.error_outline_rounded,
          () {
            Navigator.pop(context);
          },
        );
      }
    } else {
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Something went wrong!",
          Icons.task_alt,
          () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  void _clearTextField() {
    _emailTextEditingController.clear();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    super.dispose();
  }
}