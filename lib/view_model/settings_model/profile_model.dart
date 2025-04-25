import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/settings_repo.dart';
import 'package:stonk_it/view/auth/login_screen.dart';

import '../../data/response/api_response.dart';
import '../../storage/user_session.dart';
import '../../utils/utils.dart';

class ProfileModel with ChangeNotifier {
  String _buttonStatus = 'YES';
  String get buttonStatus => _buttonStatus;
  late UserSession _userSession;
  final SettingsRepo _settingsRepo = SettingsRepo();

  Future deleteAccount(BuildContext context) async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    Map data = {"id": _userSession.userId};
    setButtonState(ApiResponse.loading());
    try {
      final decodedData = await _settingsRepo.deleteAccount(data);
      setButtonState(ApiResponse.completed(decodedData));
      debugPrint('decodedData: $decodedData');
      String status = decodedData['status'];
      if (status == 'error') {
        Utils.errorSnackBar(context, decodedData['message']);
      } else {
        Utils.successSnackBar(context, decodedData['message'], 2);
        await _userSession.clearUserData(delAccount: true);
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

  void setButtonState(ApiResponse response) {
    if (response.status == Status.loading) {
      _buttonStatus = 'Please wait..';
    } else if (response.status == Status.completed ||
        response.status == Status.error) {
      _buttonStatus = 'YES';
    }
    notifyListeners();
  }
}
