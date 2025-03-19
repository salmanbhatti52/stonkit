import 'package:flutter/material.dart';
import 'package:stonk_it/routes/routes.dart';
import 'package:stonk_it/view/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      initialRoute: SplashScreen.id,
      routes: Routes.routes,
    );
  }
}
