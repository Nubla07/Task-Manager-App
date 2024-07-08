import 'package:flutter/material.dart';
import '../../../data/model/network_response.dart';
import '../../../data/network_caller.dart/network_caller.dart';
import '../../../utils/api_url.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_route.dart';
import '../../utility/on_tap_action.dart';
import '../../utility/validate_checking.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/bottom_rich_text.dart';
import '../../widgets/elevated_icon_button.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/one_button_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _firstNameTextEditingController = TextEditingController();
  final TextEditingController _lastNameTextEditingController = TextEditingController();
  final TextEditingController _mobileTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _registerInProgress = false;

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
                    "Join With Us",
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

                        ///------First Name Text Field------///
                        TextFormField(
                          controller: _firstNameTextEditingController,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: AppColor.themeColor,
                          decoration: const InputDecoration(
                            hintText: "First Name",
                          ),
                          validator: (String? value) {
                            return ValidateCheckingFun.validateFirstName(value);
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ///------Last Name Text Field------///
                        TextFormField(
                          controller: _lastNameTextEditingController,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: AppColor.themeColor,
                          decoration: const InputDecoration(
                            hintText: "Last Name",
                          ),
                          validator: (String? value) {
                            return ValidateCheckingFun.validateLastName(value);
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        ///------Mobile Text Field------///
                        TextFormField(
                          controller: _mobileTextEditingController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: AppColor.themeColor,
                          decoration: const InputDecoration(
                            hintText: "Mobile",
                          ),
                          validator: (String? value) {
                            return ValidateCheckingFun.validateNumber(value);
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

                        const SizedBox(
                          height: 12,
                        ),

                        ///------Sign Up Button------///
                        ElevatedIconButton(
                          icon: Icons.arrow_circle_right_outlined,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        ///------Sign In Text------///
                        Center(
                          child: BottomRichText(
                            text01: "Have account?",
                            text02: "Sign In",
                            onTap: () => Navigator.pop(context),
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

  void _registerUser() async {
    _registerInProgress = true;

    loadingDialog(context);

    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestInput = {
      "email": _emailTextEditingController.text.trim(),
      "firstName": _firstNameTextEditingController.text.trim(),
      "lastName": _lastNameTextEditingController.text.trim(),
      "mobile": _mobileTextEditingController.text.trim(),
      "password": _passwordTextEditingController.text,
      "photo": ""
    };

    NetworkResponse response = await NetworkCaller.postResponse(
      ApiUrl.registration,
      body: requestInput,
    );
    _registerInProgress = false;
    if (mounted) {
      Navigator.pop(context);
    }

    if (response.isSuccess) {
      _clearTextField();
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.themeColor,
          AppColor.themeColor,
          "Success!",
          "Registration success. Now login!",
          Icons.task_alt,
          () {
            OnTapAction.onTapRemoveUntil(context, AppRoute.loginScreen);
          },
        );
      } else {
        if (mounted) {
          oneButtonDialog(
            context,
            AppColor.red,
            AppColor.themeColor,
            "Failed!",
            "Registration failed, try again!",
            Icons.task_alt,
            () {
              Navigator.pop(context);
            },
          );
        }
      }
    }
  }

  void _clearTextField() {
    _emailTextEditingController.clear();
    _firstNameTextEditingController.clear();
    _lastNameTextEditingController.clear();
    _mobileTextEditingController.clear();
    _passwordTextEditingController.clear();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _firstNameTextEditingController.dispose();
    _lastNameTextEditingController.dispose();
    _mobileTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }
}