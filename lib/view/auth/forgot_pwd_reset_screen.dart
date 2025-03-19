import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/view_model/auth_models/reset_pwd_form_model.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/components/asset_image_md.dart';
import '../../resources/components/custom_button.dart';
import '../../resources/components/text_field_md.dart';
import '../../resources/constants.dart';
import '../../utils/utils.dart';

class ForgotPwdResetScreen extends StatefulWidget {
  static const String id = 'forgot_pwd_reset_screen';
  const ForgotPwdResetScreen({super.key});

  @override
  State<ForgotPwdResetScreen> createState() => _ForgotPwdResetScreenState();
}

class _ForgotPwdResetScreenState extends State<ForgotPwdResetScreen> {
  late Map _userData;
  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _userData = ModalRoute.of(context)?.settings.arguments as Map;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ResetPwdFormModel formModel =
    //     Provider.of<ResetPwdFormModel>(context, listen: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int currentIndex = 2;
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
                      'Set New Password',
                      style: kTwentyEightMediumBlackPoppins,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Must be at least 8 Chracters',
                      style: kTwelveRegular050B15Poppins.copyWith(
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.033),
                    Consumer<ResetPwdFormModel>(
                      builder: (context, object, child) {
                        return TextFieldMd(
                          prefixIcon: SvgAssetImageMd(
                            name: Assets.lock,
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'Create New Password',
                          controller: object.pwdController,
                          validator: object.pwdValidator,
                          obscureText: object.pwdVisibility,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              object.togglePwdVisibility();
                            },
                            child: Icon(
                              object.pwdVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.green,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer<ResetPwdFormModel>(
                      builder: (context, object, child) {
                        return TextFieldMd(
                          prefixIcon: SvgAssetImageMd(
                            name: Assets.lock,
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'Confirm Password',
                          controller: object.confirmPwdController,
                          validator: object.confirmPwdValidator,
                          obscureText: object.confirmPwdVisibility,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              object.toggleConfirmPwdVisibility();
                            },
                            child: Icon(
                              object.confirmPwdVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.green,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40),
                    Consumer<ResetPwdFormModel>(
                      builder: (context, value, child) {
                        return CustomButton(
                          onTap: () {
                            Utils.setFocus(context);
                            value.setNewPassword(
                                _formKey, context, _userData['id']);
                          },
                          buttonText: value.buttonStatus,
                          borderColor: Colors.transparent,
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
      ),
    );
  }
}
