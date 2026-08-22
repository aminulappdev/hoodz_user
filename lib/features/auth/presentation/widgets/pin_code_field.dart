import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/validator_services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppPinCodeField extends StatelessWidget {
  const AppPinCodeField({
    super.key,
    required this.controller,
    this.length = 6,
    this.validator,
    this.onChanged,

  });

  final TextEditingController controller;
  final int length;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length,
      obscureText: false,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      controller: controller,
      validator: validator ?? ValidatorService.validateSimpleField,
      animationDuration: const Duration(milliseconds: 300),
      onChanged: onChanged ?? (_) {},
      pinTheme: PinTheme(
        selectedColor: Colors.white,
        activeColor: const Color(0xffEDF1F3),
        borderWidth: 0.2,
        shape: PinCodeFieldShape.circle,
        inactiveColor: LightThemeColors.lightBrown,
        fieldHeight: 47,
        fieldWidth: 47,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
    );
  }
}
