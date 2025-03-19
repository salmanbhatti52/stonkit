import 'package:flutter/material.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/constants.dart';

class TermsScreen extends StatefulWidget {
  static const String id = 'terms_screen';
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBarWithImageMd(
            leadingIcon: SvgAssetImageMd(
              onTap: () {
                Navigator.of(context).pop();
              },
              name: Assets.arrowLeft,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            title: 'Terms of Service',
            onlyTitle: true,
            increaseHeight: 5),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '1. Clause 1',
                style: kTwentyBoldBlackLato,
              ),
              SizedBox(
                height: 9,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
                style: kSixteenRegularGrayLato,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '2. Clause 2',
                style: kTwentyBoldBlackLato,
              ),
              SizedBox(
                height: 9,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem. \n \n Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque.',
                style: kSixteenRegularGrayLato,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
