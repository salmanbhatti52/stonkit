import 'package:flutter/material.dart';
import 'package:stonk_it/resources/colors.dart';

import '../resources/constants.dart';

class Utils {
  static setFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static errorSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: kToastTextStyle,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
    ));
  }

  static successSnackBar(BuildContext context, String msg, int? seconds) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: kToastTextStyle,
      ),
      duration: Duration(seconds: seconds ?? 2),
      backgroundColor: AppColors.primary,
    ));
  }
}
