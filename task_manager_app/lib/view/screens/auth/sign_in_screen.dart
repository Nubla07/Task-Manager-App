import 'package:flutter/material.dart';
import '../../../data/model/login_model.dart';
import '../../../data/model/network_response.dart';
import '../../../data/network_caller.dart/network_caller.dart';
import '../../../utils/api_url.dart';
import '../../../utils/app_colors.dart';
import '../../Controller/auth_controller.dart';
import '../../utility/on_tap_action.dart';
import '../../utility/validate_checking.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/bottom_rich_text.dart';
import '../../widgets/elevated_icon_button.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/one_button_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  bool _signInProgress = false;
  bool _isCheckValue = false;

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
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),

                        ///------Email Text Field------///
                        TextFormField(
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

                        const SizedBox(
                          height: 10,
                        ),

                        ///------Password Text Field------///
                        TextFormField(
                          controller: _passwordTextEditingController,
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: AppColor.themeColor,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            return ValidateCheckingFun.validatePassword(value);
                          },
                        ),

                        ///------Remember me section------///
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isCheckValue,
                              activeColor: AppColor.themeColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCheckValue = value!;
                                });
                              },
                            ),
                            const Text(
                              'Remember me?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        ///------Login Button------///
                        ElevatedIconButton(
                          icon: Icons.arrow_circle_right_outlined,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signIn();
                            }
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ///------Forget Password Text------///
                              TextButton(
                                onPressed: () => OnTapAction.onTapGoForgotPasswordScreen(context),
                                child: const Text(
                                  "Forget Password?",
                                  style: TextStyle(
                                    color: AppColor.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              ///------Sign Up Text------///
                              BottomRichText(
                                text01: "Don't have an account?",
                                text02: "Sign Up",
                                onTap: () => OnTapAction.onTapGoSignUpScreen(context),
                              ),
                            ],
                          ),
                        )
                      ],
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

  Future<void> signIn() async {
    _signInProgress = true;
    if (mounted) {
      setState(() {});
    }

    loadingDialog(context);

    Map<String, dynamic> requestData = {
      "email": _emailTextEditingController.text.trim(),
      "password": _passwordTextEditingController.text,
    };

    final NetworkResponse response =
        await NetworkCaller.postResponse(ApiUrl.login, body: requestData);

    _signInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      await AuthController.saveRememberMeStatus(_isCheckValue);

      if (mounted) {
        OnTapAction.onTapGoMainBottomBar(context);
      }
    } else {
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.red,
          AppColor.themeColor,
          "Failed!",
          "Login failed, enter correct information and try again!",
          Icons.task_alt,
          () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }
}