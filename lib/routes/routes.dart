import 'package:flutter/material.dart';

import '../view/auth/forgot_pwd_email_screen.dart';
import '../view/auth/forgot_pwd_otp_screen.dart';
import '../view/auth/forgot_pwd_reset_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/auth/signup_screen.dart';
import '../view/settings/pages/change_pwd_screen.dart';
import '../view/settings/pages/profile_screen.dart';
import '../view/settings/pages/terms_screen.dart';
import '../view/splash_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.id: (_) => SplashScreen(),
    SignupScreen.id: (_) => SignupScreen(),
    LoginScreen.id: (_) => LoginScreen(),
    ForgotPwdEmailScreen.id: (_) => ForgotPwdEmailScreen(),
    ForgotPwdOtpScreen.id: (_) => ForgotPwdOtpScreen(),
    ForgotPwdResetScreen.id: (_) => ForgotPwdResetScreen(),
    ProfileScreen.id: (_) => ProfileScreen(),
    TermsScreen.id: (_) => TermsScreen(),
    ChangePwdScreen.id: (_) => ChangePwdScreen(),
  };
}
