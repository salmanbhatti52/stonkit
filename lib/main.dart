import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/storage/app_data.dart';
import 'package:stonk_it/storage/user_session.dart';
import 'package:stonk_it/view_model/auth_models/forgot_pwd_form_model.dart';
import 'package:stonk_it/view_model/auth_models/guest_login_model.dart';
import 'package:stonk_it/view_model/auth_models/login_form_model.dart';
import 'package:stonk_it/view_model/auth_models/reset_pwd_form_model.dart';
import 'package:stonk_it/view_model/auth_models/signup_form_model.dart';
import 'package:stonk_it/view_model/auth_models/verify_otp_model.dart';
import 'package:stonk_it/view_model/bottom_bar_model/bottom_bar_model.dart';
import 'package:stonk_it/view_model/bottom_bar_model/filter_view_model.dart';
import 'package:stonk_it/view_model/bottom_bar_model/home_view_model.dart';
import 'package:stonk_it/view_model/bottom_bar_model/watchlist_view_model.dart';
import 'package:stonk_it/view_model/settings_model/chang_pwd_form_model.dart';
import 'package:stonk_it/view_model/settings_model/profile_model.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserSession()),
        ChangeNotifierProvider(create: (context) => AppData()),
        ChangeNotifierProvider(create: (context) => SignUpFormModel()),
        ChangeNotifierProvider(create: (context) => LoginFormModel()),
        ChangeNotifierProvider(create: (context) => ForgotPwdFormModel()),
        ChangeNotifierProvider(create: (context) => ChangePwdFormModel()),
        ChangeNotifierProvider(create: (context) => ResetPwdFormModel()),
        ChangeNotifierProvider(create: (context) => ProfileModel()),
        ChangeNotifierProvider(create: (context) => GuestLoginModel()),
        ChangeNotifierProvider(create: (context) => VerifyOtpModel()),
        ChangeNotifierProvider(create: (context) => BottomBarModel()),
        ChangeNotifierProvider(create: (context) => WatchListViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => FilterViewModel()),
      ],
      child: const MyApp(),
    ),
  );

  // runApp(
  //   DevicePreview(
  //     builder: (context) {
  //       return MultiProvider(
  //         providers: [
  //           ChangeNotifierProvider(create: (context) => AuthViewsModel()),
  //         ],
  //         child: const MyApp(),
  //       );
  //     },
  //   ),
  // );
}
