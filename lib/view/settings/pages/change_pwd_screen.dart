import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/constants.dart';
import 'package:stonk_it/view_model/settings_model/chang_pwd_form_model.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/components/custom_button.dart';
import '../../../resources/components/text_field_md.dart';
import '../../../utils/utils.dart';

class ChangePwdScreen extends StatefulWidget {
  static const String id = 'change_pwd_screen';
  const ChangePwdScreen({super.key});

  @override
  State<ChangePwdScreen> createState() => _ChangePwdScreenState();
}

class _ChangePwdScreenState extends State<ChangePwdScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBarWithImageMd(
            leadingIcon: SvgAssetImageMd(
              onTap: () {
                Utils.setFocus(context);
                Navigator.of(context).pop();
              },
              name: Assets.arrowLeft,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            title: 'Change Password',
            onlyTitle: true,
            increaseHeight: 5),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Current Password',
                    style: kSixteenReg050B15Poppins,
                  ),
                  Consumer<ChangePwdFormModel>(
                    builder: (context, object, child) {
                      return TextFieldMd(
                        prefixIcon: SvgAssetImageMd(
                          name: Assets.lock,
                          fit: BoxFit.scaleDown,
                        ),
                        hintText: 'Password',
                        controller: object.currentPwdController,
                        validator: object.currentPwdValidator,
                        obscureText: object.currentPwdVisibility,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            object.toggleCurrentPwdVisibility();
                          },
                          child: Icon(
                            object.currentPwdVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.gray,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'New Password',
                    style: kSixteenReg050B15Poppins,
                  ),
                  Consumer<ChangePwdFormModel>(
                    builder: (context, object, child) {
                      return TextFieldMd(
                        prefixIcon: SvgAssetImageMd(
                          name: Assets.lock,
                          fit: BoxFit.scaleDown,
                        ),
                        hintText: 'Password',
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
                            color: AppColors.gray,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Confirm New Password',
                    style: kSixteenReg050B15Poppins,
                  ),
                  Consumer<ChangePwdFormModel>(
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
                            color: AppColors.gray,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: height * 0.2,
                  ),
                  Consumer<ChangePwdFormModel>(
                    builder: (context, value, child) {
                      return CustomButton(
                        onTap: () {
                          Utils.setFocus(context);
                          value.changePassword(_formKey, context);
                        },
                        buttonText: value.buttonStatus,
                        borderColor: Colors.transparent,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
