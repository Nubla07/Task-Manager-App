import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/model/network_response.dart';
import '../../../data/model/user_model.dart';
import '../../../data/network_caller.dart/network_caller.dart';
import '../../../utils/api_url.dart';
import '../../../utils/app_colors.dart';
import '../../Controller/auth_controller.dart';
import '../../utility/validate_checking.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/elevated_icon_button.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/one_button_dialog.dart';
import 'inner/photo_picker_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _firstNameTextEditingController = TextEditingController();
  final TextEditingController _lastNameTextEditingController = TextEditingController();
  final TextEditingController _mobileTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final userData = AuthController.userData!;
    _emailTextEditingController.text = userData.email ?? '';
    _firstNameTextEditingController.text = userData.firstName ?? '';
    _lastNameTextEditingController.text = userData.lastName ?? '';
    _mobileTextEditingController.text = userData.mobile ?? '';
  }

  bool _obscureText = true;
  bool _updateProfileInProgress = false;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),

                  ///------Update profile text------///
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      ///------photo picker field------///
                      photoPickerWidget(
                        () => pickImage(),
                        _selectedImage?.name,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      ///------email text form field------///
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailTextEditingController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              enabled: false,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                              validator: (String? value) {
                                return ValidateCheckingFun.validateEmail(value);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///------First text form field------///
                            TextFormField(
                              controller: _firstNameTextEditingController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'First Name',
                              ),
                              validator: (String? value) {
                                return ValidateCheckingFun.validateFirstName(value);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///------Last name text form field------///
                            TextFormField(
                              controller: _lastNameTextEditingController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Last Name',
                              ),
                              validator: (String? value) {
                                return ValidateCheckingFun.validateFirstName(value);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///------Mobile text form field------///
                            TextFormField(
                              controller: _mobileTextEditingController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Mobile',
                              ),
                              validator: (String? value) {
                                return ValidateCheckingFun.validateNumber(value);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      ///------Password text form field------///
                      TextFormField(
                        controller: _passwordTextEditingController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Password (Optional)',
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
                        height: 10,
                      ),

                      ///------Update button------///
                      ElevatedIconButton(
                        icon: Icons.arrow_circle_right_outlined,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updateProfile();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;

    String encodePhoto = AuthController.userData?.photo ?? '';

    if (mounted) {
      setState(() {});
    }

    loadingDialog(context);

    Map<String, dynamic> requestBody = {
      "email": _emailTextEditingController.text.trim(),
      "firstName": _firstNameTextEditingController.text.trim(),
      "lastName": _lastNameTextEditingController.text.trim(),
      "mobile": _mobileTextEditingController.text.trim(),
    };

    if (_passwordTextEditingController.text.isNotEmpty) {
      requestBody["password"] = _passwordTextEditingController.text;
    }

    if (_selectedImage != null) {
      File file = File(_selectedImage!.path);
      encodePhoto = base64Encode(file.readAsBytesSync());
      requestBody["photo"] = encodePhoto;
    }

    final NetworkResponse response =
        await NetworkCaller.postResponse(ApiUrl.profileUpdate, body: requestBody);

    _updateProfileInProgress = false;

    if (mounted) {
      setState(() {});
    }

    if (mounted) {
      Navigator.pop(context);
    }

    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel(
        email: _emailTextEditingController.text.trim(),
        photo: encodePhoto,
        firstName: _firstNameTextEditingController.text.trim(),
        lastName: _lastNameTextEditingController.text.trim(),
        mobile: _mobileTextEditingController.text.trim(),
      );
      await AuthController.saveUserData(userModel);
      if (mounted) {
        oneButtonDialog(
          context,
          AppColor.themeColor,
          AppColor.themeColor,
          "Update Success!",
          "Your profile information update successfully.",
          Icons.task_alt,
          () {
            Navigator.pop(context);
          },
        );
      }
    } else {
      if (mounted) {
        setCustomToast(
          response.errorMessage ?? "Update failed!",
          Icons.error_outline,
          AppColor.red,
          AppColor.white,
        );
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }
}