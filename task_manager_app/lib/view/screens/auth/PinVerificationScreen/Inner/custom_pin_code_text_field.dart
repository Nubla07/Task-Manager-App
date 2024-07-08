import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../utility/validate_checking.dart';


PinCodeTextField CustomPinCodeTextField(
  BuildContext context,
  TextEditingController pinVerificationTextEditingController,
) {
  return PinCodeTextField(
    length: 6,
    obscureText: false,
    animationType: AnimationType.fade,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 40,
      activeFillColor: Colors.white,
      selectedFillColor: AppColor.white,
      inactiveFillColor: AppColor.white,
      selectedColor: AppColor.themeColor,
      inactiveColor: Colors.grey,
    ),
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: Colors.transparent,
    enableActiveFill: true,
    controller: pinVerificationTextEditingController,
    keyboardType: TextInputType.number,
    appContext: context,
    validator: (String? value) {
      return ValidateCheckingFun.validatePinVerification(value);
    },
  );
}