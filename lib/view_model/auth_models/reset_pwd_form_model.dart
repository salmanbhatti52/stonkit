import 'package:flutter/material.dart';
import 'package:stonk_it/view/auth/login_screen.dart';

import '../../api_repository/auth_repo.dart';
import '../../data/response/api_response.dart';
import '../../utils/form_field_manager.dart';
import '../../utils/utils.dart';

class ResetPwdFormModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  final FormFieldManager _formFieldManager = FormFieldManager();

  String _buttonStatus = 'Reset Password';
  String get buttonStatus => _buttonStatus;

  TextEditingController get pwdController => _formFieldManager.pwdController;
  TextEditingController get confirmPwdController =>
      _formFieldManager.confirmPwdController;

  bool get pwdVisibility => _formFieldManager.pwdVisibility;
  bool get confirmPwdVisibility => _formFieldManager.confirmPwdVisibility;

  togglePwdVisibility() {
    _formFieldManager.togglePwdVisibility();
    notifyListeners();
  }

  toggleConfirmPwdVisibility() {
    _formFieldManager.toggleConfirmPwdVisibility();
    notifyListeners();
  }

  String? pwdValidator(String? value) {
    return _formFieldManager.pwdValidator(value);
  }

  String? confirmPwdValidator(String? value) {
    return _formFieldManager.confirmPwdValidator(value);
  }

  setButtonState(ApiResponse response) {
    if (response.status == Status.loading) {
      _buttonStatus = 'Please wait..';
    } else if (response.status == Status.completed ||
        response.status == Status.error) {
      _buttonStatus = 'Reset Password';
    }
    notifyListeners();
  }

  Future setNewPassword(
      GlobalKey<FormState> formKey, BuildContext context, int userId) async {
    if (formKey.currentState!.validate()) {
      Map data = {
        "id": userId,
        "password": pwdController.text,
        "confirm_password": confirmPwdController.text
      };
      setButtonState(ApiResponse.loading());

      try {
        final decodedData = await _authRepo.setNewPassword(data);
        setButtonState(ApiResponse.completed(decodedData));

        debugPrint('decodedData: $decodedData');

        String status = decodedData['status'];
        if (status == 'error') {
          Utils.errorSnackBar(context, decodedData['message']);
        } else {
          Utils.successSnackBar(context, decodedData['message'], 2);
          clearControllers();
          Utils.setFocus(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.id,
            (route) => false,
          );
        }
      } catch (e) {
        setButtonState(ApiResponse.error(e.toString()));
        Utils.errorSnackBar(context, e.toString());
        debugPrint('Error: $e');
      }
    }
  }

  clearControllers() {
    _formFieldManager.clearControllers();
  }
}
