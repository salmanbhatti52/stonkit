import 'package:flutter/material.dart';

class FormFieldManager {
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get pwdController => _pwdController;
  TextEditingController get confirmPwdController => _confirmPwdController;

  bool _pwdVisibility = false;
  bool get pwdVisibility => _pwdVisibility;
  bool _confirmPwdVisibility = false;
  bool get confirmPwdVisibility => _confirmPwdVisibility;

  togglePwdVisibility() {
    _pwdVisibility = !_pwdVisibility;
  }

  toggleConfirmPwdVisibility() {
    _confirmPwdVisibility = !_confirmPwdVisibility;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? pwdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? confirmPwdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    if (value != _pwdController.text) {
      return "The confirm password must match the password.";
    }
    return null;
  }

  clearControllers() {
    _emailController.clear();
    _pwdController.clear();
    _confirmPwdController.clear();
  }
}
