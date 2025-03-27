import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/bottom_nav_repo.dart';
import 'package:stonk_it/storage/user_session.dart';
import 'package:stonk_it/utils/utils.dart';

import '../../storage/app_data.dart';

class WatchListViewModel extends ChangeNotifier {
  final BottomNavRepo _bottomNavRepo = BottomNavRepo();
  final UserSession _userSession = UserSession();
  late AppData _appData = AppData();
  List _likedTickers = [];
  List get likedTickers => _likedTickers;

  Future getLikedTickers(BuildContext context) async {
    _appData = Provider.of<AppData>(context, listen: false);
    debugPrint('getLikedTickers called');
    try {
      Map data = {"user_id": _userSession.userId.toString()};
      final response = await _bottomNavRepo.getLikedTickers(data);
      debugPrint('getLikedTickers response: $response');
      if (response['status'] == 'success' && response['data'] != []) {
        _likedTickers = response['data'];
        fetchLikedTickersLikes();
        notifyListeners();
      } else {
        Utils.errorSnackBar(context, response['message']);
      }
    } catch (e) {
      debugPrint('getLikedTickers error: $e');
      Utils.errorSnackBar(context, e.toString());
    }
  }

  void fetchLikedTickersLikes() {
    // Go through each stock in the watchlist
    List<Map<String, dynamic>?> watchlist = _appData.watchlist;
    debugPrint('watchlist given: $watchlist');
    for (int i = 0; i < watchlist.length; i++) {
      // Get the current stock
      var stock = watchlist[i];

      // Skip if the stock is null
      if (stock == null) {
        continue;
      }

      // Get symbol and exchange
      String? symbol = stock['symbol'];
      String? exchange = stock['exchange'];

      // If symbol or exchange is missing, set liked to 0
      if (symbol == null || exchange == null) {
        stock['liked'] = 1;
        continue;
      }

      // Make the ticker (e.g., AAPL.NASDAQ)
      String ticker = '$symbol.$exchange';

      // Look for this ticker in _likedTickers
      bool found = false;
      for (int j = 0; j < _likedTickers.length; j++) {
        if (_likedTickers[j]['tickers_name'] == ticker) {
          stock['liked'] = _likedTickers[j]['tickers_likes'];
          found = true;
          break; // Stop looking once we find a match
        }
      }

      // If no match, set liked to 0
      if (!found) {
        stock['liked'] = 1;
      }
    }
    debugPrint('watchlist updated: $watchlist');
    _appData.setWatchlist(watchlist);
  }
}
