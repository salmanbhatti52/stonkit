import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/settings_repo.dart';
import 'package:stonk_it/storage/user_session.dart';
import 'package:stonk_it/utils/form_field_manager.dart';

import '../../data/response/api_response.dart';
import '../../utils/utils.dart';

class ChangePwdFormModel with ChangeNotifier {
  final SettingsRepo _settingsRepo = SettingsRepo();
  final FormFieldManager _formFieldManager = FormFieldManager();

  TextEditingController get pwdController => _formFieldManager.pwdController;

  TextEditingController get confirmPwdController =>
      _formFieldManager.confirmPwdController;

  final _currentPwdController = TextEditingController();
  TextEditingController get currentPwdController => _currentPwdController;

  bool get pwdVisibility => _formFieldManager.pwdVisibility;
  bool get confirmPwdVisibility => _formFieldManager.confirmPwdVisibility;

  bool _currentPwdVisibility = false;
  bool get currentPwdVisibility => _currentPwdVisibility;

  String _buttonStatus = 'Update Password';
  String get buttonStatus => _buttonStatus;

  late UserSession _userSession;

  toggleCurrentPwdVisibility() {
    _currentPwdVisibility = !_currentPwdVisibility;
    notifyListeners();
  }

  togglePwdVisibility() {
    _formFieldManager.togglePwdVisibility();
    notifyListeners();
  }

  toggleConfirmPwdVisibility() {
    _formFieldManager.toggleConfirmPwdVisibility();
    notifyListeners();
  }

  String? currentPwdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Current Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? pwdValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "New Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (value == currentPwdController.text) {
      return "New Password must be different";
    }
    return null;
  }

  String? confirmPwdValidator(String? value) {
    return _formFieldManager.confirmPwdValidator(value);
  }

  setButtonState(ApiResponse response) {
    if (response.status == Status.loading) {
      _buttonStatus = 'Please wait..';
    } else if (response.status == Status.completed ||
        response.status == Status.error) {
      _buttonStatus = 'Update Password';
    }
    notifyListeners();
  }

  Future changePassword(
      GlobalKey<FormState> formKey, BuildContext context) async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    if (formKey.currentState!.validate()) {
      Map data = {
        "id": _userSession.userId,
        "previous_password": currentPwdController.text,
        "new_password": pwdController.text,
        "confirm_password": confirmPwdController.text
      };
      setButtonState(ApiResponse.loading());

      try {
        final decodedData = await _settingsRepo.changePassword(data);
        setButtonState(ApiResponse.completed(decodedData));
        debugPrint('decodedData: $decodedData');

        String status = decodedData['status'];
        if (status == 'error') {
          Utils.errorSnackBar(context, decodedData['message']);
        } else {
          Utils.successSnackBar(context, decodedData['message'], 2);
          clearControllers();
          Utils.setFocus(context);
          Navigator.pop(context);
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
    currentPwdController.clear();
  }
}
