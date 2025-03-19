import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/components/asset_image_md.dart';
import '../../resources/components/custom_button.dart';
import '../../resources/components/text_field_md.dart';
import '../../resources/constants.dart';
import '../../utils/utils.dart';
import '../../view_model/auth_models/forgot_pwd_form_model.dart';

class ForgotPwdEmailScreen extends StatefulWidget {
  static const String id = 'forgot_pwd_email_screen';
  const ForgotPwdEmailScreen({super.key});

  @override
  State<ForgotPwdEmailScreen> createState() => _ForgotPwdEmailScreenState();
}

class _ForgotPwdEmailScreenState extends State<ForgotPwdEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    ForgotPwdFormModel forgotPwdFormModel =
        Provider.of<ForgotPwdFormModel>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int currentIndex = 0;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
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
                      name: Assets.stonkItLogo,
                      height: height * 0.2,
                      width: width * 0.2,
                      color: AppColors.primary,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: height * 0.016,
                    ),
                    Text(
                      'Forgot Password',
                      style: kTwentyEightMediumBlackPoppins,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'No worries, we’ll send you reset Instructions',
                      style: kTwelveRegular050B15Poppins.copyWith(
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.02),
                    TextFieldMd(
                      prefixIcon: SvgAssetImageMd(
                        name: Assets.email,
                        fit: BoxFit.scaleDown,
                      ),
                      hintText: 'Email Address',
                      controller: forgotPwdFormModel.emailController,
                      validator: forgotPwdFormModel.emailValidator,
                      onChanged: (p0) {
                        bool keyOpen = isKeyboardOpen(context);
                        debugPrint(keyOpen.toString());
                      },
                    ),
                    SizedBox(height: 40),
                    Consumer<ForgotPwdFormModel>(
                      builder: (context, value, child) {
                        return CustomButton(
                          onTap: () {
                            Utils.setFocus(context);
                            value.getResetPasswordOtp(_formKey, context);
                          },
                          buttonText: value.buttonStatus,
                          borderColor: Colors.transparent,
                        );
                      },
                    ),
                    SizedBox(
                      height: isKeyboardOpen(context) ? 25 : height * 0.315,
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
      ),
    );
  }
}
