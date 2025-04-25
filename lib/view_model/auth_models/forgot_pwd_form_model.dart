import 'package:flutter/cupertino.dart';
import 'package:stonk_it/utils/form_field_manager.dart';

import '../../api_repository/auth_repo.dart';
import '../../data/response/api_response.dart';
import '../../utils/utils.dart';
import '../../view/auth/forgot_pwd_otp_screen.dart';

class ForgotPwdFormModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  final FormFieldManager _formFieldManager = FormFieldManager();

  String _buttonStatus = 'Send OTP';
  String get buttonStatus => _buttonStatus;

  TextEditingController get emailController =>
      _formFieldManager.emailController;

  String? emailValidator(String? value) {
    return _formFieldManager.emailValidator(value);
  }

  setButtonState(ApiResponse response) {
    if (response.status == Status.loading) {
      _buttonStatus = 'Please wait..';
    } else if (response.status == Status.completed ||
        response.status == Status.error) {
      _buttonStatus = 'Send OTP';
    }
    notifyListeners();
  }

  Future getResetPasswordOtp(
      GlobalKey<FormState> formKey, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Map data = {
        "email": emailController.text,
      };
      debugPrint('login data: $data');
      setButtonState(ApiResponse.loading());

      try {
        final decodedData = await _authRepo.getResetPasswordOtp(data);
        setButtonState(ApiResponse.completed(decodedData));
        debugPrint('decodedData: $decodedData');

        String status = decodedData['status'];
        if (status == 'error') {
          Utils.errorSnackBar(context, decodedData['message']);
        } else {
          Utils.successSnackBar(context, "OTP sent to your email.", 2);
          clearControllers();
          Map data = {
            'otp': decodedData['otp'],
            'id': decodedData['user']['id'],
            'email': decodedData['user']['email'],
          };
          Utils.setFocus(context);
          Navigator.pushNamed(context, ForgotPwdOtpScreen.id, arguments: data);
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
