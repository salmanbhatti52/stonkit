import 'package:flutter/cupertino.dart';

import '../../api_repository/auth_repo.dart';
import '../../utils/utils.dart';

class VerifyOtpModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  bool _loader = false;
  bool get loader => _loader;

  setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }

  Future<Map?> getResetPasswordOtp(BuildContext context, String email) async {
    Map data = {
      "email": email,
    };
    debugPrint('login data: $data');
    setLoader(true);
    try {
      final decodedData = await _authRepo.getResetPasswordOtp(data);
      setLoader(false);
      debugPrint('decodedData: $decodedData');

      String status = decodedData['status'];
      if (status == 'error') {
        Utils.errorSnackBar(context, decodedData['message']);
        return null;
      } else {
        Utils.successSnackBar(context, "OTP sent to your email.", 2);
        Map data = {
          'otp': decodedData['otp'],
          'id': decodedData['user']['id'],
          'email': decodedData['user']['email'],
        };
        return data;
      }
    } catch (e) {
      setLoader(false);
      Utils.errorSnackBar(context, e.toString());
      debugPrint('Error: $e');
      return null;
    }
  }
}
