import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/utils/utils.dart';
import 'package:stonk_it/view/auth/signup_screen.dart';
import 'package:stonk_it/view_model/auth_models/guest_login_model.dart';
import 'package:stonk_it/view_model/auth_models/login_form_model.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/components/asset_image_md.dart';
import '../../resources/components/custom_button.dart';
import '../../resources/components/rich_text_md.dart';
import '../../resources/components/text_field_md.dart';
import '../../resources/constants.dart';
import 'forgot_pwd_email_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    LoginFormModel loginFormModel =
        Provider.of<LoginFormModel>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height * 0.06,
                    ),
                    AssetsImageMd(
                      name: Assets.stonkItLogo,
                      height: height * 0.2,
                      width: width * 0.2,
                      color: AppColors.primary,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: height * 0.016),
                    Text(
                      'Log In',
                      style: kTwentyFourMediumBlackPoppins,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),
                    TextFieldMd(
                      prefixIcon: SvgAssetImageMd(
                        name: Assets.email,
                        fit: BoxFit.scaleDown,
                      ),
                      controller: loginFormModel.emailController,
                      validator: loginFormModel.emailValidator,
                      hintText: 'Email Address',
                    ),
                    Consumer<LoginFormModel>(
                      builder: (context, value, child) {
                        return TextFieldMd(
                          prefixIcon: SvgAssetImageMd(
                            name: Assets.lock,
                            fit: BoxFit.scaleDown,
                          ),
                          validator: loginFormModel.pwdValidator,
                          hintText: 'Password',
                          controller: value.pwdController,
                          obscureText: value.pwdVisibility,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                value.togglePwdVisibility();
                              },
                              child: Icon(
                                value.pwdVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.gray,
                              )),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Utils.setFocus(context);
                        loginFormModel.clearControllers();
                        Navigator.pushNamed(context, ForgotPwdEmailScreen.id);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: kFourteenRegBlackPoppins.copyWith(
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Consumer<LoginFormModel>(
                      builder: (context, object, child) {
                        return CustomButton(
                            onTap: () {
                              Utils.setFocus(context);
                              object.login(_formKey, context);
                            },
                            buttonText: object.buttonStatus,
                            borderColor: Colors.transparent);
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                        child: RichTextMd(
                      text1: 'Don\'t have an account?',
                      text2: 'Sign Up',
                      text1style: kFourteenRegBlackPoppins,
                      text2style: kFourteenRegBlackPoppins.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                      onTap: () {
                        Utils.setFocus(context);
                        loginFormModel.clearControllers();
                        Navigator.pushNamed(context, SignupScreen.id);
                      },
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<GuestLoginModel>(
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            Utils.setFocus(context);
                            loginFormModel.clearControllers();
                            value.guestLogin(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue as a guest',
                                style: kFourteenRegBlackPoppins.copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline),
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
                          ),
                        );
                      },
                    ),
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
