import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/constants.dart';
import 'package:stonk_it/view_model/bottom_bar_model/bottom_bar_model.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/components/asset_image_md.dart';

class BottomBarMd extends StatefulWidget {
  static const String id = 'bottom_nav_bar';
  final int initialIndex;
  const BottomBarMd({
    super.key,
    required this.initialIndex,
  });

  @override
  State<BottomBarMd> createState() => _BottomBarMdState();
}

class _BottomBarMdState extends State<BottomBarMd> {
  late BottomBarModel _bottomBarModel;

  @override
  void initState() {
    super.initState();
    _bottomBarModel = Provider.of<BottomBarModel>(context, listen: false);
    _bottomBarModel.setCurrentIndex(widget.initialIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bottomBarModel.init(context);
    });
    return SafeArea(
      child: Scaffold(
        body: Consumer<BottomBarModel>(
          builder: (context, value, child) {
            return IndexedStack(
              index: value.currentIndex,
              children: value.pages,
            );
          },
        ),
        bottomNavigationBar: Consumer<BottomBarModel>(
          builder: (context, object, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.115,
                  color: Colors.white,
                  child: BottomNavigationBar(
                    onTap: (value) {
                      object.onBottomNavTap(value, context);
                      object.init(context);
                    },
                    currentIndex: object.currentIndex,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    selectedItemColor: AppColors.primary,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor: AppColors.gray,
                    selectedLabelStyle: kTwelveRegular050B15Poppins.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: kTwelveRegular050B15Poppins.copyWith(
                      color: AppColors.gray,
                    ),
                    items: [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.bookmark),
                        activeIcon: SvgPicture.asset(
                          Assets.bookmarkActive,
                        ),
                        label: ("Watchlist"),
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox(
                            // height: 40,
                            ),
                        activeIcon: SizedBox(
                            // height: 40,
                            ),
                        label: (""),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          Assets.filter,
                        ),
                        activeIcon: SvgPicture.asset(
                          Assets.filterActive,
                        ),
                        label: ("Filter"),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -20,
                  left: width * 0.5 - 26,
                  child: SvgAssetImageMd(
                    onTap: () {
                      object.onBottomNavTap(1, context);
                    },
                    name: object.currentIndex == 1
                        ? Assets.rocketActive
                        : Assets.rocketDim,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
