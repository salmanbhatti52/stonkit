import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession with ChangeNotifier {
  int? _userId;
  int? get userId => _userId;
  String? _email;
  String? get email => _email;
  bool _homeAlertShown = false;
  bool get homeAlertShown => _homeAlertShown;
  bool _watchListAlertShown = false;
  bool get watchListAlertShown => _watchListAlertShown;
  bool _isEmailAlreadyExist = false;
  bool get isEmailAlreadyExist => _isEmailAlreadyExist;

  UserSession() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();

    _userId = preferences.getInt('userId');
    _email = preferences.getString('email');
    _homeAlertShown = preferences.getBool('homeAlertStatus') ?? false;
    _watchListAlertShown = preferences.getBool('watchListAlertStatus') ?? false;
    _isEmailAlreadyExist = preferences.getBool('isEmailAlreadyExist') ?? false;
    debugPrint('UserSession: $_userId, $_email');
  }

  Future<void> saveUserSession({required Map userData}) async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();

    preferences.setInt('userId', userData['id']);
    preferences.setString('email', userData['email']);
    // update session model
    _userId = userData['id'];
    _email = userData['email'];

    // save email to savedEmails list
    List<String> savedEmails = [];
    if (preferences.getStringList('savedEmails') != null) {
      savedEmails = preferences.getStringList('savedEmails')!;
    }
    if (!savedEmails.contains(userData['email'])) {
      savedEmails.add(userData['email']);
      preferences.setStringList('savedEmails', savedEmails);
      preferences.setBool('isEmailAlreadyExist', false);
      _isEmailAlreadyExist = false;
    } else {
      preferences.setBool('isEmailAlreadyExist', true);
      _isEmailAlreadyExist = true;
    }
  }

  Future setHomeAlertStatus() async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();
    preferences.setBool('homeAlertStatus', true);
    _homeAlertShown = true;
  }

  Future setWatchListAlertStatus() async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();
    preferences.setBool('watchListAlertStatus', true);
    _watchListAlertShown = true;
  }

  Future<void> clearUserData({bool? delAccount}) async {
    SharedPreferences? preferences = await SharedPreferences.getInstance();
    // Don't use preferences.clear() because we need savedEmails to track same user.
    preferences.remove('userId');
    preferences.remove('email');
    preferences.remove('homeAlertStatus');
    preferences.remove('watchListAlertStatus');
    preferences.remove('isEmailAlreadyExist');
    preferences.remove('watchlist');
    //if deleting account
    if (delAccount == true) {
      List<String>? savedEmails = [];
      savedEmails = preferences.getStringList('savedEmails');
      savedEmails?.remove(_email);
      preferences.setStringList('savedEmails', savedEmails!);
    }

    _userId = null;
    _email = null;
    _homeAlertShown = false;
    _watchListAlertShown = false;
  }
}
