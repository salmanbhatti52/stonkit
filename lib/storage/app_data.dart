import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData with ChangeNotifier {
  List<Map<String, dynamic>> _companies = [];
  List<Map<String, dynamic>> get companies => _companies;
  List<Map<String, dynamic>?> _watchlist = [];
  List<Map<String, dynamic>?> get watchlist => _watchlist;
  // Initialize by loading saved data
  AppData() {
    // loadCompaniesData();
    loadWatchlistData();
  }

  // Save companies to SharedPreferences
  Future<void> saveCompaniesData(List<Map<String, dynamic>> companies) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      // Convert the list to a JSON string
      String jsonString = jsonEncode(companies);
      await preference.setString('companies', jsonString);
      _companies = companies; // Update local list
      // notifyListeners(); // Notify UI to update
    } catch (e) {
      print('Error saving companies: $e');
    }
  }

  // Load companies from SharedPreferences
  Future<void> loadCompaniesData() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      String? jsonString = preference.getString('companies');
      if (jsonString != null) {
        // Decode the JSON string back to a list
        List<dynamic> decoded = jsonDecode(jsonString);
        _companies = decoded.cast<Map<String, dynamic>>();
        debugPrint('loaded data: ${_companies.toString()}');
        // notifyListeners();
      }
    } catch (e) {
      print('Error loading companies: $e');
    }
  }

  Future<void> loadWatchlistData() async {
    // try {
    // SharedPreferences preference = await SharedPreferences.getInstance();
    // String? jsonString = preference.getString('watchlist');
    // if (jsonString != null) {
    //   _watchlist =
    //       (jsonDecode(jsonString) as List).cast<Map<String, dynamic>?>();
    //   notifyListeners();
    // }
    // } catch (e) {
    //   print('Error loading watchlist: $e');
    // }
  }

  Future<bool> addToWatchlistIfNotExists(
      Map<String, dynamic>? tickerQuote, BuildContext context) async {
    String? ticker = tickerQuote?['symbol'];
    bool tickerExists = false;

    if (_watchlist.isNotEmpty) {
      debugPrint('watchlist: $_watchlist');

      tickerExists = _watchlist.any(
        (element) {
          return element?['symbol'] == ticker;
        },
      );
    }

    if (!tickerExists) {
      // adding ticker to watchlist
      debugPrint('Adding ticker to watchlist');
      _watchlist.add(tickerQuote!);
      bool result = await saveWatchlistData();
      return result;
    } else {
      // ticker already exists in watchlist
      debugPrint('Ticker already exists in watchlist');
      return false;
    }
  }

  setWatchlist(List<Map<String, dynamic>?> value) {
    _watchlist = value;
    notifyListeners();
  }

  Future<bool> saveWatchlistData() async {
    try {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // String jsonString = jsonEncode(watchlist);
      // await preferences.setString('watchlist', jsonString);
      _watchlist = watchlist;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving watchlist: $e');
      return false;
    }
  }

  Future deleteWatchlistData(String ticker, BuildContext context) async {
    try {
      bool tickerExists = _watchlist.any(
        (element) => element?['symbol'] == ticker,
      );

      if (tickerExists) {
        _watchlist.removeWhere(
          (element) => element?['symbol'] == ticker,
        );
        await saveWatchlistData();
      }
    } catch (e) {
      debugPrint('Error deleting from watchlist: $e');
    }
  }

  // Optional: Add a company to the list
  // Future<void> addCompany(Map<String, dynamic> company) async {
  //   _companies.add(company);
  //   await saveCompaniesData(_companies);
  // }
}
