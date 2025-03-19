import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/view/auth/forgot_pwd_reset_screen.dart';
import 'package:stonk_it/view_model/auth_models/verify_otp_model.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/components/asset_image_md.dart';
import '../../resources/components/custom_button.dart';
import '../../resources/components/pinput_otp_md.dart';
import '../../resources/components/rich_text_md.dart';
import '../../resources/constants.dart';
import '../../utils/utils.dart';

class ForgotPwdOtpScreen extends StatefulWidget {
  static const String id = 'forgot_pwd_otp_screen';
  const ForgotPwdOtpScreen({super.key});

  @override
  State<ForgotPwdOtpScreen> createState() => _ForgotPwdOtpScreenState();
}

class _ForgotPwdOtpScreenState extends State<ForgotPwdOtpScreen> {
  late Map _userData;
  String _otp = '';

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _userData = ModalRoute.of(context)?.settings.arguments as Map;
  }

  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int currentIndex = 1;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Utils.setFocus(context);
                      Navigator.pop(context);
                    },
                    child: SvgAssetImageMd(
                      name: Assets.arrowLeft,
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  AssetsImageMd(
                    name: Assets.stonkItHz,
                    height: height * 0.06,
                    width: width * 0.011,
                    // color: AppColors.primary,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    'Password Reset',
                    style: kTwentyEightMediumBlackPoppins,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'A code is forwarded to',
                    style: kTwelveRegular050B15Poppins.copyWith(
                      color: AppColors.gray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _userData['email'],
                    style: kTwelveRegular050B15Poppins.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: height * 0.05),
                  PinPutOtpMd(
                    onCompleted: (value) {
                      debugPrint(value);
                      _otp = value;
                    },
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    onTap: () {
                      Utils.setFocus(context);
                      debugPrint('OTP: $_otp');
                      if (_otp.isEmpty) {
                        Utils.errorSnackBar(context, 'Enter OTP');
                      } else if (_userData['otp'].toString() != _otp) {
                        Utils.errorSnackBar(context, 'Invalid OTP');
                      } else {
                        Navigator.pushNamed(context, ForgotPwdResetScreen.id,
                            arguments: _userData);
                      }
                    },
                    buttonText: 'Verify OTP',
                    borderColor: Colors.transparent,
                  ),

                  SizedBox(
                    height: 19,
                  ),
                  Consumer<VerifyOtpModel>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichTextMd(
                            text1: 'Don’t Received Email?',
                            text2: 'Resend',
                            text1style: kSixteenRegularBlackPoppins,
                            text2style: kSixteenRegularBlackPoppins.copyWith(
                              color: AppColors.green,
                            ),
                            onTap: () async {
                              Map? response = await value.getResetPasswordOtp(
                                  context, _userData['email']);
                              if (response != null) {
                                _userData['otp'] = response['otp'];
                                debugPrint('userData with new OTP: $_userData');
                              }
                            },
                          ),
                          value.loader
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox()
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: isKeyboardOpen(context) ? 50 : height * 0.34,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration:
                            Duration(milliseconds: 300), // Smooth transition
                        width: 60, // Slim width
                        height: 4, // Slim height
                        margin: EdgeInsets.symmetric(
                            horizontal: 4), // Space between indicators
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? AppColors.green
                              : AppColors.gray, // Highlight current index
                          borderRadius:
                              BorderRadius.circular(4), // Rounded edges
                        ),
                      );
                    }),
                  ),
                  // SizedBox(height: keyboardHeight > 0 ? keyboardHeight : 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
