import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/auth_repo.dart';
import 'package:stonk_it/utils/form_field_manager.dart';

import '../../data/response/api_response.dart';
import '../../storage/user_session.dart';
import '../../utils/utils.dart';
import '../../view/bottom_bar/bottom_bar.dart';

class LoginFormModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  final FormFieldManager _formFieldManager = FormFieldManager();
  String _buttonStatus = 'Log In';

  String get buttonStatus => _buttonStatus;

  late UserSession _userSession;

  TextEditingController get emailController =>
      _formFieldManager.emailController;
  TextEditingController get pwdController => _formFieldManager.pwdController;

  bool get pwdVisibility => _formFieldManager.pwdVisibility;

  togglePwdVisibility() {
    _formFieldManager.togglePwdVisibility();
    notifyListeners();
  }

  String? emailValidator(String? value) {
    return _formFieldManager.emailValidator(value);
  }

  String? pwdValidator(String? value) {
    return _formFieldManager.pwdValidator(value);
  }

  setButtonState(ApiResponse response) {
    if (response.status == Status.loading) {
      _buttonStatus = 'Please wait..';
    } else if (response.status == Status.completed ||
        response.status == Status.error) {
      _buttonStatus = 'Log In';
    }
    notifyListeners();
  }

  Future login(GlobalKey<FormState> formKey, BuildContext context) async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    if (formKey.currentState!.validate()) {
      Map data = {
        "email": emailController.text,
        "password": pwdController.text,
      };
      debugPrint('login data: $data');
      setButtonState(ApiResponse.loading());

      try {
        final decodedData = await _authRepo.login(data);
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

  clearControllers() {
    _formFieldManager.clearControllers();
  }
}
