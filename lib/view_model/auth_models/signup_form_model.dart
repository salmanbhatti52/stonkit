import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/auth_repo.dart';
import 'package:stonk_it/data/response/api_response.dart';
import 'package:stonk_it/storage/user_session.dart';
import 'package:stonk_it/utils/utils.dart';
import 'package:stonk_it/view/bottom_bar/bottom_bar.dart';

import '../../utils/form_field_manager.dart';

class SignUpFormModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  final FormFieldManager _formFieldManager = FormFieldManager();

  TextEditingController get emailController =>
      _formFieldManager.emailController;
  TextEditingController get pwdController => _formFieldManager.pwdController;
  TextEditingController get confirmPwdController =>
      _formFieldManager.confirmPwdController;

  bool get pwdVisibility => _formFieldManager.pwdVisibility;
  bool get confirmPwdVisibility => _formFieldManager.confirmPwdVisibility;

  bool _acceptTermsStatus = true;
  bool get acceptTermsStatus => _acceptTermsStatus;
  String _buttonStatus = 'Sign Up';
  String get buttonStatus => _buttonStatus;

  late UserSession _userSession;

  togglePwdVisibility() {
    _formFieldManager.togglePwdVisibility();
    notifyListeners();
  }

  toggleConfirmPwdVisibility() {
    _formFieldManager.toggleConfirmPwdVisibility();
    notifyListeners();
  }

  String? emailValidator(String? value) {
    return _formFieldManager.emailValidator(value);
  }

  String? pwdValidator(String? value) {
    return _formFieldManager.pwdValidator(value);
  }

  String? confirmPwdValidator(String? value) {
    return _formFieldManager.confirmPwdValidator(value);
  }

  setTermStatus(bool value) {
    _acceptTermsStatus = !_acceptTermsStatus;
    notifyListeners();
  }

  Future signup(GlobalKey<FormState> formKey, BuildContext context) async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    if (formKey.currentState!.validate()) {
      Map data = {
        "email": emailController.text,
        "password": pwdController.text,
        "confirm_password": confirmPwdController.text
      };
      setButtonState(ApiResponse.loading());
      try {
        final decodedData = await _authRepo.signup(data);
        setButtonState(ApiResponse.completed(decodedData));
        debugPrint('decodedData: $decodedData');
        String status = decodedData['status'];
        if (status == 'error') {
          Utils.errorSnackBar(context, decodedData['message']);
        } else {
          await _userSession.saveUserSession(userData: decodedData['data']);
          clearControllers();
          Utils.setFocus(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBarMd(initialIndex: 1),
            ),
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

  void setButtonState(ApiResponse response) {
    if (response.status == Status.loading) {
      _buttonStatus = 'Please wait..';
    } else if (response.status == Status.completed ||
        response.status == Status.error) {
      _buttonStatus = 'Sign Up';
    }
    notifyListeners();
  }

  clearControllers() {
    _formFieldManager.clearControllers();
  }
}
