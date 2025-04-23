import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/view_model/bottom_bar_model/home_view_model.dart';
// import 'package:stonk_it/view_model/bottom_bar_model/home_view_model.dart';
import 'package:stonk_it/view_model/bottom_bar_model/watchlist_view_model.dart';

import '../../storage/user_session.dart';
import '../../view/bottom_bar/pages/filter_screen.dart';
import '../../view/bottom_bar/pages/home_screen.dart';
import '../../view/bottom_bar/pages/watchlist_screen.dart';
import '../../view/bottom_bar/widgets/delete_item_alert.dart';
import '../../view/bottom_bar/widgets/swipe_left_alert.dart';
import '../../view/bottom_bar/widgets/swipe_right_alert.dart';

class BottomBarModel with ChangeNotifier {
  late UserSession _userSession;
  late WatchListViewModel _watchListViewModel;
  late HomeViewModel _homeViewModel;
  int get currentIndex => _currentIndex;
  late int _currentIndex;

  final List<Widget> _pages = [
    WatchlistScreen(),
    HomeScreen(),
    FilterScreen(),
  ];

  List<Widget> get pages => _pages;

  void setCurrentIndex(int index, BuildContext context, bool? isFilterUpdated) {
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _currentIndex = index;
    if (index == 1 && isFilterUpdated == true) {
      debugPrint('isFilterUpdated: $isFilterUpdated');
      _homeViewModel.resetCompaniesAndCards(context: context, notify: false);
    }
  }

  void onBottomNavTap(int index, BuildContext context) {
    debugPrint('user id: ${_userSession.userId}');
    if (index == 0) {
      _watchListViewModel.getLikedTickers(context);
      _homeViewModel.setCardChildIndex(0);
    } else if (index == 1) {
      _homeViewModel.setCardChildIndex(0);
    }
    _currentIndex = index;
    notifyListeners();
  }

  void init(BuildContext context) {
    _userSession = Provider.of<UserSession>(context, listen: false);
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _watchListViewModel =
        Provider.of<WatchListViewModel>(context, listen: false);

    if (_currentIndex == 1 &&
        _userSession.homeAlertShown == false &&
        _userSession.isEmailAlreadyExist == false) {
      homeScreenAlert(context);
    }
    if (_currentIndex == 0 &&
        _userSession.watchListAlertShown == false &&
        _userSession.isEmailAlreadyExist == false) {
      watchlistAlert(context);
    }
  }

  void homeScreenAlert(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await showDialog(
          context: context,
          builder: (context) {
            return SwipeRightAlert();
          },
        );
        await showDialog(
          context: context,
          builder: (context) {
            return SwipeLeftAlert();
          },
        );
        await _userSession.setHomeAlertStatus();
      },
    );
  }

  void watchlistAlert(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await showDialog(
          context: context,
          builder: (context) {
            return DeleteItemAlert();
          },
        );
        await _userSession.setWatchListAlertStatus();
      },
    );
  }
}
