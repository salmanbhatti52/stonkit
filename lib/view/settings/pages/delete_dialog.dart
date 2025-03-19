import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/view_model/settings_model/profile_model.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/components/custom_button.dart';
import '../../../resources/constants.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 81,
            width: 81,
            decoration: BoxDecoration(
                color: AppColors.red, borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: SvgAssetImageMd(
                name: Assets.delete,
                alignment: Alignment.center,
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            'Are you sure, you want to delete your Account?',
            style:
                kSixteenReg050B15Poppins.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 18,
          ),
          Consumer<ProfileModel>(
            builder: (context, value, child) {
              return CustomButton(
                onTap: () {
                  value.deleteAccount(context);
                },
                buttonText: value.buttonStatus,
                borderColor: Colors.transparent,
                color: AppColors.red,
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          CustomButton(
            onTap: () {
              Navigator.pop(context);
            },
            buttonText: 'NO',
            borderColor: Colors.transparent,
            color: Colors.black,
          )
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
    );
  }
}
