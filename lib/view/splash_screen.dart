import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/view/bottom_bar/bottom_bar.dart';

import '../resources/assets.dart';
import '../resources/colors.dart';
import '../resources/components/asset_image_md.dart';
import '../storage/user_session.dart';
import 'auth/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToNextScreen(context);
  }

  void goToNextScreen(BuildContext context) {
    final userSession = Provider.of<UserSession>(context, listen: false);

    Future.delayed(
      Duration(seconds: 2),
      () {
        if (userSession.userId != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBarMd(initialIndex: 1),
              ));
        } else {
          Navigator.pushReplacementNamed(
            context,
            SignupScreen.id,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Center(
            child: AssetsImageMd(
                height: height * 0.55,
                width: width * 0.55,
                name: Assets.stonkItLogo),
          ),
        ),
      ),
    );
  }
}
