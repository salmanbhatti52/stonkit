import 'package:flutter/material.dart';
import 'package:stonk_it/resources/constants.dart';

import '../../utils/utils.dart';
import '../assets.dart';
import '../colors.dart';
import 'asset_image_md.dart';

class AppBarMd extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMd({super.key, this.onTap, this.backgroundColor});
  final void Function()? onTap;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: AppColors.scaffoldBackground,
      //   statusBarIconBrightness: Brightness.dark,
      // ),
      backgroundColor: backgroundColor ?? AppColors.scaffoldBackground,
      // forceMaterialTransparency: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: GestureDetector(
          onTap: onTap ??
              () {
                Utils.setFocus(context);
                Navigator.pop(context);
              },
          child: SvgAssetImageMd(
            name: Assets.arrowLeft,
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ================= App Bar with DropDown ==============

class AppBarWithImageMd extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithImageMd({
    super.key,
    this.backgroundColor,
    required this.title,
    this.leadingIcon,
    this.suffixIcon,
    this.titleStyle,
    this.subtitleStyle,
    this.subtitle,
    required this.onlyTitle,
    this.titleImg,
    required this.increaseHeight,
  });
  final Color? backgroundColor;
  final String title;
  final String? subtitle;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool onlyTitle;
  final String? titleImg;
  final num increaseHeight;
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: AppColors.primary,
      //   statusBarIconBrightness: Brightness.light,
      // ),
      backgroundColor: AppColors.primary,
      // forceMaterialTransparency: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: leadingIcon,
      ),
      leadingWidth: 80,
      title: onlyTitle
          ? Text(
              title,
              style: kTwentyFourSbWhitePoppins,
            )
          : AssetsImageMd(
              width: 86,
              height: 34,
              name: Assets.stonkItHz,
              color: Colors.white,
            ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: suffixIcon,
        )
      ],
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight + increaseHeight);
}
