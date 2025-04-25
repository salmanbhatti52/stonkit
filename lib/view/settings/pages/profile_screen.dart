import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/constants.dart';
import 'package:stonk_it/storage/user_session.dart';
import 'package:stonk_it/utils/utils.dart';
import 'package:stonk_it/view/settings/pages/terms_screen.dart';
import 'package:stonk_it/view_model/bottom_bar_model/home_view_model.dart';
import 'package:stonk_it/view_model/bottom_bar_model/watchlist_view_model.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/components/divider_md.dart';
import '../../auth/login_screen.dart';
import 'change_pwd_screen.dart';
import 'delete_dialog.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserSession _userSession;
  late HomeViewModel _homeViewModel;
  late WatchListViewModel _watchListViewModel;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _watchListViewModel =
        Provider.of<WatchListViewModel>(context, listen: false);
  }

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
            title: 'Profile',
            onlyTitle: true,
            increaseHeight: 5),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AssetsImageMd(
                name: Assets.profileAvatar,
                height: 128,
                width: 128,
                alignment: Alignment.center,
              ),
              Text(
                _userSession.email ?? '',
                style: kFourteenSbBluePoppins,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 44,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, TermsScreen.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgAssetImageMd(name: Assets.setting),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Terms of Service',
                          style: kSixteenReg050B15Poppins,
                        )
                      ],
                    ),
                    SvgAssetImageMd(name: Assets.arrowRight),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: DividerMd()),
              GestureDetector(
                onTap: () {
                  if (_userSession.email!.contains('guestuser')) {
                    String message = "Guests can't change passwords.";
                    Utils.errorSnackBar(context, message);
                  } else {
                    Navigator.pushNamed(context, ChangePwdScreen.id);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgAssetImageMd(name: Assets.lock),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Change Password',
                          style: kSixteenReg050B15Poppins,
                        )
                      ],
                    ),
                    SvgAssetImageMd(name: Assets.arrowRight),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: DividerMd()),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteDialog(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgAssetImageMd(name: Assets.trash),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Delete Account',
                          style: kSixteenReg050B15Poppins,
                        )
                      ],
                    ),
                    SvgAssetImageMd(name: Assets.arrowRight),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: DividerMd()),
              GestureDetector(
                onTap: () async {
                  await _userSession.clearUserData();
                  _homeViewModel.resetCompaniesAndCards(
                      context: context, notify: true);
                  _watchListViewModel.resetWatchlist();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.id,
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgAssetImageMd(name: Assets.logout),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Log out',
                          style: kSixteenReg050B15Poppins.copyWith(
                              color: AppColors.red),
                        )
                      ],
                    ),
                    SvgAssetImageMd(name: Assets.arrowRight),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: DividerMd()),
            ],
          ),
        ),
      ),
    );
  }
}
