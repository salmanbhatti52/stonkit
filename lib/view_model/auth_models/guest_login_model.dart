import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/storage/user_session.dart';

import '../../api_repository/auth_repo.dart';
import '../../utils/utils.dart';
import '../../view/bottom_bar/bottom_bar.dart';

class GuestLoginModel with ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  bool _loader = false;
  bool get loader => _loader;
  late UserSession _userSession;

  setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }

  Future guestLogin(BuildContext context) async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    setLoader(true);
    try {
      final decodedData = await _authRepo.loginAsGuest();
      setLoader(false);
      debugPrint('decodedData: $decodedData');

      String status = decodedData['status'];
      if (status == 'error') {
        Utils.errorSnackBar(context, decodedData['message']);
      } else {
        await _userSession.saveUserSession(userData: decodedData['data']);
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
      setLoader(false);
      Utils.errorSnackBar(context, e.toString());
      debugPrint('Error: $e');
    }
  }
}
