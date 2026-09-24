import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';

class ValidatorService {
  static bool validateAndSave(globalFormKey) {
    final FormState form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //<============================================= Full Name Validator
  static String? validateFullName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) {
      return Strings.fieldRequired.tr;
    }

    // Remove leading and trailing whitespace
    final trimmedName = fullName.trim();

    // Check if the name has at least two words
    final words = trimmedName.split(' ');

    if (words.length < 2) {
      return Strings.fullNameAtLeastTwoWords.tr;
    }

    // Check if the name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmedName)) {
      return Strings.fullNameLettersAndSpaces.tr;
    }

    // Validation passed, return null (no error)
    return null;
  }

  //<<================= bangladeshi phone number validator
  static String? validateEmailAddress(String? email) {
    if (email == null || email.trim().isEmpty) {
      return Strings.emailAddressRequired.tr;
    }

    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    if (!regExp.hasMatch(email.trim())) {
      return Strings.invalidEmailAddress.tr;
    }

    // Validation passed, return null (no error)
    return null;
  }

  //<======= Password validator
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return Strings.passwordIsRequired.tr;
    }

    if (password.length < 7) {
      return Strings.passwordMinLength.tr;
    }

    // At least 1 uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return Strings.passwordCapitalLetter.tr;
    }

    // At least 1 number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return Strings.passwordMustContainNumber.tr;
    }

    // At least 1 special character
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return Strings.passwordSpecialCharacter.tr;
    }

    // All validations passed
    return null;
  }

  // Confirm Password Validator
  static String? validateConfirmPassword(
    String? confirmPassword,
    String originalPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return Strings.confirmPasswordRequired.tr;
    }

    if (confirmPassword != originalPassword) {
      return Strings.passwordsDoNotMatch.tr;
    }

    // Validation passed, return null (no error)
    return null;
  }

  static String? validateSimpleField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.fieldRequired.tr;
    }
    return null;
  }
}
