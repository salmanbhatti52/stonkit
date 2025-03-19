import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:stonk_it/resources/constants.dart';

import '../colors.dart';

class PinPutOtpMd extends StatelessWidget {
  const PinPutOtpMd({super.key, this.onCompleted});
  final void Function(String)? onCompleted;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Pinput(
      length: 4,
      onCompleted: onCompleted,
      defaultPinTheme: PinTheme(
        width: 52,
        height: 52,
        // padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
        textStyle: kFourteenRegBlackPoppins,
        decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(
              BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: AppColors.red,
              ),
            )),
      ),
    );
  }
}
