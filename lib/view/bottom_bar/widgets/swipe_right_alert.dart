import 'package:flutter/material.dart';
import 'package:stonk_it/resources/assets.dart';
import 'package:stonk_it/resources/colors.dart';

import '../../../resources/components/asset_image_md.dart';
import '../../../resources/constants.dart';

class SwipeRightAlert extends StatelessWidget {
  const SwipeRightAlert({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.white,
      // actionsOverflowDirection: ScrollableDetails.vertical(),

      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        height: height * 0.23,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AssetsImageMd(name: Assets.swipeRight),
            SizedBox(
              height: 20,
            ),
            Text(
              'Swipe right to add to the watchlist',
              style: kSixteenMediumWhitePoppins.copyWith(
                  color: AppColors.color050B15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    );
  }
}
