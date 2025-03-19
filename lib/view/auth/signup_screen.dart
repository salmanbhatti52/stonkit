import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/constants.dart';
import 'package:stonk_it/view/auth/widgets/terms_dialog.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/components/asset_image_md.dart';
import '../../resources/components/custom_button.dart';
import '../../resources/components/rich_text_md.dart';
import '../../resources/components/text_field_md.dart';
import '../../utils/utils.dart';
import '../../view_model/auth_models/guest_login_model.dart';
import '../../view_model/auth_models/signup_form_model.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    SignUpFormModel signUpFormModel =
        Provider.of<SignUpFormModel>(context, listen: false);
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
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Sign Up',
                      style: kTwentyFourMediumBlackPoppins,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFieldMd(
                      prefixIcon: SvgAssetImageMd(
                        name: Assets.email,
                        fit: BoxFit.scaleDown,
                      ),
                      controller: signUpFormModel.emailController,
                      validator: signUpFormModel.emailValidator,
                      hintText: 'Email Address',
                    ),
                    Consumer<SignUpFormModel>(
                      builder: (context, object, child) {
                        return TextFieldMd(
                          prefixIcon: SvgAssetImageMd(
                            name: Assets.lock,
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'Password',
                          controller: object.pwdController,
                          validator: signUpFormModel.pwdValidator,
                          obscureText: object.pwdVisibility,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              object.togglePwdVisibility();
                            },
                            child: Icon(
                              object.pwdVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.gray,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer<SignUpFormModel>(
                      builder: (context, object, child) {
                        return TextFieldMd(
                          prefixIcon: SvgAssetImageMd(
                            name: Assets.lock,
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'Confirm Password',
                          controller: object.confirmPwdController,
                          validator: signUpFormModel.confirmPwdValidator,
                          obscureText: object.confirmPwdVisibility,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              object.toggleConfirmPwdVisibility();
                            },
                            child: Icon(
                              object.confirmPwdVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.gray,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<SignUpFormModel>(
                          builder: (context, object, child) {
                            return SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                activeColor: AppColors.green,
                                checkColor: Colors.white,
                                side: BorderSide(
                                    width: 1.5,
                                    color: AppColors.green,
                                    style: BorderStyle.solid),
                                value: object.acceptTermsStatus,
                                onChanged: (value) {
                                  object.setTermStatus(value!);
                                  // Handle checkbox logic here
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        RichTextMd(
                          text1: 'I Agree with',
                          text2: 'terms and conditions',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => TermsDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Consumer<SignUpFormModel>(
                      builder: (context, object, child) {
                        return CustomButton(
                            color: object.acceptTermsStatus
                                ? null
                                : AppColors.primary.withValues(alpha: 0.5),
                            onTap: object.acceptTermsStatus
                                ? () {
                                    Utils.setFocus(context);
                                    object.signup(_formKey, context);
                                  }
                                : null,
                            buttonText: object.buttonStatus,
                            borderColor: Colors.transparent);
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                        child: RichTextMd(
                      text1: 'Already have an account?',
                      text2: 'Log In',
                      text1style: kFourteenRegBlackPoppins,
                      text2style: kFourteenRegBlackPoppins.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                      onTap: () {
                        Utils.setFocus(context);
                        signUpFormModel.clearControllers();
                        Navigator.pushNamed(context, LoginScreen.id);
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
                            signUpFormModel.clearControllers();
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
