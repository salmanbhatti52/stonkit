import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/home_repo.dart';
import 'package:stonk_it/storage/app_data.dart';
import 'package:stonk_it/utils/utils.dart';

import '../../resources/colors.dart';
import '../../view/bottom_bar/pages/home_screen.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepo _repo = HomeRepo();
  // final List<Map<String, dynamic>> _companies = [
  //   {
  //     "companyName": "TechNova Solutions",
  //     "registeredName": "TechNova Pvt Ltd",
  //     "description":
  //         "TechNova Solutions is a leader in the tech industry, providing innovative software solutions and IT consulting services. "
  //             "With a focus on cutting-edge technologies, we help businesses optimize their digital transformation journey.",
  //     "logoUrl": "https://dummyimage.com/150x150/000/fff&text=TechNova"
  //   },
  //   {
  //     "companyName": "NextGen Innovations",
  //     "registeredName": "NextGen Innovations Ltd",
  //     "description":
  //         "NextGen Innovations specializes in AI-driven automation, offering smart solutions for businesses looking to integrate AI into their workflows. "
  //             "We believe in pushing the boundaries of technology to make work smarter, not harder.",
  //     "logoUrl": "https://dummyimage.com/150x150/ff4500/fff&text=NextGen"
  //   },
  //   {
  //     "companyName": "Skyline Software",
  //     "registeredName": "Skyline Software Inc.",
  //     "description":
  //         "Skyline Software develops enterprise-level cloud-based applications, making business operations more scalable and efficient. "
  //             "Our mission is to provide robust, high-performance software solutions tailored to the needs of modern enterprises.",
  //     "logoUrl": "https://dummyimage.com/150x150/008080/fff&text=Skyline"
  //   },
  //   {
  //     "companyName": "BlueWave Technologies",
  //     "registeredName": "BlueWave Tech LLC",
  //     "description":
  //         "BlueWave Technologies is dedicated to cybersecurity and network protection. "
  //             "We provide state-of-the-art security solutions to protect businesses from data breaches, cyber threats, and online vulnerabilities.",
  //     "logoUrl": "https://dummyimage.com/150x150/4169e1/fff&text=BlueWave"
  //   },
  //   {
  //     "companyName": "Quantum Dynamics",
  //     "registeredName": "Quantum Dynamics Ltd",
  //     "description":
  //         "Quantum Dynamics is at the forefront of blockchain technology and decentralized finance (DeFi). "
  //             "We aim to revolutionize financial systems by offering secure and transparent blockchain-based solutions for businesses and individuals.",
  //     "logoUrl": "https://dummyimage.com/150x150/800080/fff&text=Quantum"
  //   }
  // ];
  List<Map<String, dynamic>> _companies = [];
  List<Map<String, dynamic>> get companies => _companies;
  late List<String> _tickersList;
  late List<Widget> _cards;
  List<Widget> get cards => _cards;

  int _currentTopIndex = 0; // Tracks the top card index
  int get currentTopIndex => _currentTopIndex; // Tracks the top card index
  late AppData _appData;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  int _cardChildIndex = 0;
  int get cardChildIndex => _cardChildIndex;
  Map<String, dynamic>? _companyStockQuote;
  Map<String, dynamic>? get companyStockQuote => _companyStockQuote;

  setCardChildIndex(int index) {
    _cardChildIndex = index;
    notifyListeners();
  }

  setCurrentTopIndex(int? currentIndex) {
    _currentTopIndex = currentIndex ?? 0;
    notifyListeners();
  }

  resetStockPrice() {
    _companyStockQuote = null;
    notifyListeners();
  }

  init(BuildContext context) async {
    _appData = Provider.of<AppData>(context, listen: false);
    await _appData.loadCompaniesData();
    if (_appData.companies.isNotEmpty) {
      _companies = _appData.companies;
      updateCards(context);
    } else {
      await fetchTickersAndCompanies(context);
    }
    fetchCompanyStockPrice(_companies[0]['ticker'], context);
  }

  // Function to update card list with dynamic background colors
  void updateCards(BuildContext context) {
    _cards = List.generate(companies.length, (index) {
      // Top card gets white, others get gray
      Color bgColor =
          (index == _currentTopIndex) ? Colors.white : AppColors.lightGray;
      return FirstCardWidget(
        backgroundColor: bgColor,
        companyName: companies[index]['companyName'],
        ticker: companies[index]['ticker'],
        description: companies[index]['description'],
        // registeredName: companies[index]['registeredName'],
        logoUrl: companies[index]['logoUrl'],
        exchange: companies[index]['exchange'],
        sector: companies[index]['sector'],
        isLargeCap: companies[index]['isLargeCap'],
        // exchange: '',
        // sector: '',
        // isLargeCap: false,
      );
    });
    notifyListeners();
  }

  Future fetchTickersAndCompanies(BuildContext context) async {
    try {
      String params =
          '&limit=3&sectors=Materials&marketCapMoreThan=10000000000&isActivelyTrading=true';
      List tickers = await _repo.fetchTickersFromStockScreener(params);
      _tickersList = tickers.map((item) => item['symbol'] as String).toList();
      debugPrint(_tickersList.toString());

      for (String ticker in _tickersList) {
        Map<String, dynamic> company = await fetchCompanyProfile(ticker);
        _companies.add(company);
      }
      for (var company in companies) {
        debugPrint(
            'Ticker: ${company['ticker']}, Name: ${company['companyName']}, Sector: ${company['sector']}, Image: ${company['exchange']}');
      }
      //saving data in shared prefs.
      await _appData.saveCompaniesData(companies);
      updateCards(context);
      // fetchCompanyStockPrice(_companies[0]['ticker'], context);
    } catch (e) {
      debugPrint(e.toString());
      Utils.errorSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchCompanyProfile(String ticker) async {
    String param = '&symbol=$ticker';
    List decodedData = await _repo.fetchCompanyProfile(param);
    Map companyData = decodedData[0];
    final double? marketCap = companyData['marketCap']?.toDouble();
    Map<String, dynamic> company = {
      'ticker': companyData['symbol'],
      'companyName': companyData['companyName'],
      'exchange': companyData['exchange'],
      'logoUrl': companyData['image'],
      'description': companyData['description'] ?? 'No Description',
      'sector': companyData['sector'] ?? 'Unknown',
      'isLargeCap': marketCap! > 10000000000,
    };
    return company;
  }

  Future fetchCompanyStockPrice(String ticker, BuildContext context) async {
    try {
      _isFetching = true;
      String param = '&symbol=$ticker';
      final companyStockQuote = await _repo.fetchCompanyStockPrice(param);
      _companyStockQuote = companyStockQuote[0];
    } catch (e) {
      Utils.errorSnackBar(context, e.toString());
      _companyStockQuote = null;
    }
    _isFetching = false;
    notifyListeners();
    debugPrint('Company Stock Quote: $_companyStockQuote');
  }
}
