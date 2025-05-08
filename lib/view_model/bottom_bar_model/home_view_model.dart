import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/bottom_nav_repo.dart';
import 'package:stonk_it/storage/user_session.dart';
import 'package:stonk_it/utils/utils.dart';

import '../../resources/colors.dart';
import '../../view/bottom_bar/pages/home_screen.dart';

class HomeViewModel extends ChangeNotifier {
  final BottomNavRepo _repo = BottomNavRepo();
  List<Map<String, dynamic>> _companies = [];
  List<Map<String, dynamic>> _bufferCompaniesData = [];
  List<Map<String, dynamic>> get companies => _companies;

  List<String> _tickersList = [];
  List<String> get tickersList => _tickersList;

  List<Widget> _cards = [];
  List<Widget> get cards => _cards;

  int _currentTopIndex = 0; // Tracks the top card index
  int get currentTopIndex => _currentTopIndex; // Tracks the top card index
  late UserSession _userSession;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  bool _isFetchingChart = false;
  bool get isFetchingChart => _isFetchingChart;

  int _cardChildIndex = 0;
  int get cardChildIndex => _cardChildIndex;
  Map<String, dynamic>? _companyStockQuote;
  Map<String, dynamic>? get companyStockQuote => _companyStockQuote;

  List _dislikedTickers = [];
  List get dislikedTickers => _dislikedTickers;
  List _likedTickers = [];
  List get likedTickers => _likedTickers;

  int _currentTickerIndex = 0; // Tracks position in _tickersList
  int get currentTickerIndex =>
      _currentTickerIndex; // Tracks position in _tickersList
  final int _batchSize = 5; // Fetch 5 tickers at a time

  final List<String> _timeFrames = ['1D', '1W', '1M', '1Y', 'Max'];
  List<String> get timeFrames => _timeFrames;
  String _selectedTimeRange = '1D';
  String get selectedTimeRange => _selectedTimeRange;
  double _stockPerformance = 0.0;
  double get stockPerformance => _stockPerformance;
  double _materialSectorPerformance = 0.0;
  double get materialSectorPerformance => _materialSectorPerformance;
  double _dividendYield = 0.0;
  double get dividendYield => _dividendYield;
  List _historicalStockDataForChart = [];
  List get historicalStockDataForChart => _historicalStockDataForChart;
  List<FlSpot>? _chartSpots;
  List<FlSpot>? get chartSpots => _chartSpots;
  List<String>? _monthLabels;
  List<String>? get monthLabels => _monthLabels;
  List<double>? _monthLabelPositions;
  List<double>? get monthLabelPositions => _monthLabelPositions;
  double? _minY; // Add minY to state
  double? get minY => _minY;
  double? _maxY;
  double? get maxY => _maxY;
  String? _errorMsgForChart = '';
  String? get errorMsgForChart => _errorMsgForChart;

  Map<String, String> get selectedTimeRangeData {
    final now = DateTime.now(); // Current date and time
    final toDate =
        now.toString().split(' ')[0]; // Format: YYYY-MM-DD (e.g., 2025-03-21)
    DateTime fromDate;

    switch (_selectedTimeRange) {
      case '1D':
        fromDate = now.subtract(Duration(days: 1)); // 1 day ago
        break;
      case '1W':
        fromDate = now.subtract(Duration(days: 7)); // 1 week ago
        break;
      case '1M':
        fromDate = now.subtract(Duration(days: 30)); // Approx 1 month ago
        break;
      case '1Y':
        fromDate = now.subtract(Duration(days: 365)); // 1 year ago
        break;
      case 'Max':
        fromDate = DateTime(2022, 1, 1); // Earliest possible date for "Max"
        break;
      default:
        fromDate = now.subtract(Duration(days: 30)); // Default to 1 month
    }

    final fromDateString =
        fromDate.toString().split(' ')[0]; // Format: YYYY-MM-DD
    return {'from': fromDateString, 'to': toDate};
  }

  setCardChildIndex(int index) {
    _cardChildIndex = index;
    notifyListeners();
  }

  setSelectedTimeFrame(String selectedRange) {
    _selectedTimeRange = selectedRange;
    notifyListeners();
  }

  setCurrentTopIndex(int currentIndex) {
    debugPrint('Current Index test: $currentIndex');
    _currentTopIndex = currentIndex;
    notifyListeners();
  }

  resetStockPrice() {
    _companyStockQuote = null;
    notifyListeners();
  }

  resetCompaniesAndCards(
      {required BuildContext context, required bool notify}) {
    _companies = [];
    _cards = [];
    _currentTopIndex = 0;
    _cardChildIndex = 0;
    if (notify) {
      notifyListeners();
    }
  }

  init({required BuildContext context}) async {
    _userSession = Provider.of<UserSession>(context, listen: false);
    // hide liked tickers
    await getLikedTickers(context);
    await fetchTickers(context: context);
  }

  // Function to update card list with dynamic background colors
  Future<void> updateCards(BuildContext context) async {
    debugPrint('updateCards called');
    _cards = List.generate(companies.length, (index) {
      // Top card gets white, others get gray
      Color bgColor =
          (index == _currentTopIndex) ? Colors.white : AppColors.lightGray;
      return HomeScreenCard(
        backgroundColor: bgColor,
        companyName: companies[index]['companyName'],
        ticker: companies[index]['ticker'],
        description: companies[index]['description'],
        logoUrl: companies[index]['logoUrl'],
        exchange: companies[index]['exchange'],
        sector: companies[index]['sector'],
        isLargeCap: companies[index]['isLargeCap'],
        isMidCap: companies[index]['isMidCap'],
        isSmallCap: companies[index]['isSmallCap'],
      );
    });
    notifyListeners();
  }

  Future fetchTickers({required BuildContext context}) async {
    try {
      String params = '&limit=1000&isActivelyTrading=true';

      // Set the asset type parameter (ETFs or Companies)
      if (_userSession.selectedAsset == 'ETFs') {
        params += '&isEtf=true';
      } else {
        params += '&isEtf=false';
      }

      // Set the sector parameter
      if (_userSession.selectedSector.isNotEmpty) {
        params += '&sector=${_userSession.selectedSector}';
      } else {
        params += '&sector=Basic Materials';
      }

      // Set the market cap parameters
      int? marketCapMoreThan;
      int? marketCapLowerThan;
      if (_userSession.selectedCap.isNotEmpty) {
        if (_userSession.selectedCap == "Small Cap") {
          marketCapMoreThan = null;
          marketCapLowerThan = 2000000000; // Less than $2 billion
          params += '&marketCapLowerThan=$marketCapLowerThan';
        } else if (_userSession.selectedCap == "Mid Cap") {
          marketCapMoreThan = 2000000000; // More than $2 billion
          marketCapLowerThan = 10000000000; // Less than $10 billion
          params +=
              '&marketCapMoreThan=$marketCapMoreThan&marketCapLowerThan=$marketCapLowerThan';
        } else if (_userSession.selectedCap == "Large Cap") {
          marketCapMoreThan = 10000000000; // More than $10 billion
          marketCapLowerThan = null;
          params += '&marketCapMoreThan=$marketCapMoreThan';
        }
      } else {
        // params += '&marketCapMoreThan=10000000000';
      }

      List tickers = await _repo.fetchTickersFromStockScreener(params);
      _tickersList = tickers.map((item) => item['symbol'] as String).toList();
      debugPrint('tickers list: $_tickersList');
      if (_tickersList.isEmpty) {
        Utils.errorSnackBar(
            context, 'No Stocks found for the selected filters');
        return;
      } else {
        fetchCompaniesData(context);
      }
    } catch (e) {
      debugPrint(e.toString());
      Utils.errorSnackBar(context, e.toString());
    }
  }

  // Updated function to fetch company data in batches
  Future<void> fetchCompaniesData(BuildContext context) async {
    // If ticker list is empty, return early
    if (_tickersList.isEmpty) {
      debugPrint('Ticker list is empty, no data to fetch.');
      init(context: context);
      return;
    }

    // Calculate how many tickers to fetch (up to _batchSize or remaining)
    int remainingTickers = _tickersList.length - _currentTickerIndex;
    int batchSize =
        remainingTickers >= _batchSize ? _batchSize : remainingTickers;

    // Fetch company profiles for the batch
    for (int i = 0; i < batchSize; i++) {
      String ticker = _tickersList[_currentTickerIndex];

      // Check if ticker is liked
      bool isLikedTicker = _likedTickers.any(
          (likedTicker) => likedTicker['tickers_name'].split('.')[0] == ticker);
      if (isLikedTicker) {
        debugPrint('Ticker $ticker is liked, skipping...');
        _currentTickerIndex = (_currentTickerIndex + 1) % _tickersList.length;
        if (_currentTickerIndex == 0) {
          debugPrint('Reached end of ticker list, resetting to start.');
          resetTickersList();
        }
        continue; // Skip liked ticker
      }

      // Fetch company profile
      try {
        Map<String, dynamic> company = await fetchCompanyProfile(ticker);
        _companies.add(company);
        debugPrint(
            'Fetched: Ticker: ${company['ticker']}, Name: ${company['companyName']}, '
            'Sector: ${company['sector']}, Exchange: ${company['exchange']}');
      } catch (e) {
        debugPrint('Error fetching profile for $ticker: $e');
      }

      // Move to next ticker
      _currentTickerIndex = (_currentTickerIndex + 1) % _tickersList.length;
      if (_currentTickerIndex == 0) {
        debugPrint('Reached end of ticker list, resetting to start.');
        resetTickersList();
      }
    }

    // Update UI after batch
    if (_companies.isNotEmpty) {
      await updateCards(context);
      await fetchCompanyStockPrice(_companies[0]['ticker'], context);
      fetchHistoricalStockPrice(_companies[0]['ticker'], context);
      fetchHistoricalSectorPerformance(_companies[0]['exchange'], context);
      fetchCompanyDividends(_companies[0]['ticker'], context);
      fetchHistoricalStockPriceForChart(_companies[0]['ticker'], context);
    } else {
      fetchCompaniesData(context);
      debugPrint('No new companies fetched (all skipped or errors).');
    }
  }

  // Updated function to fetch company data in batches
  Future<void> fetchCompaniesDataAsBuffer(BuildContext context) async {
    _bufferCompaniesData = [];
    // If ticker list is empty, return early
    if (_tickersList.isEmpty) {
      debugPrint('Ticker list is empty, no data to fetch.');
      init(context: context);
      return;
    }

    // Calculate how many tickers to fetch (up to _batchSize or remaining)
    int remainingTickers = _tickersList.length - _currentTickerIndex;
    int batchSize =
        remainingTickers >= _batchSize ? _batchSize : remainingTickers;

    // Fetch company profiles for the batch
    for (int i = 0; i < batchSize; i++) {
      String ticker = _tickersList[_currentTickerIndex];

      // Check if ticker is liked
      bool isLikedTicker = _likedTickers.any(
          (likedTicker) => likedTicker['tickers_name'].split('.')[0] == ticker);
      if (isLikedTicker) {
        debugPrint('Ticker $ticker is liked, skipping...');
        _currentTickerIndex = (_currentTickerIndex + 1) % _tickersList.length;
        if (_currentTickerIndex == 0) {
          debugPrint('Reached end of ticker list, resetting to start.');
          resetTickersList();
        }
        continue; // Skip liked ticker
      }

      // Fetch company profile
      try {
        Map<String, dynamic> company = await fetchCompanyProfile(ticker);
        _bufferCompaniesData.add(company);
        debugPrint(
            'Fetched: Ticker: ${company['ticker']}, Name: ${company['companyName']}, '
            'Sector: ${company['sector']}, Exchange: ${company['exchange']}');
      } catch (e) {
        debugPrint('Error fetching profile for $ticker: $e');
      }

      // Move to next ticker
      _currentTickerIndex = (_currentTickerIndex + 1) % _tickersList.length;
      if (_currentTickerIndex == 0) {
        debugPrint('Reached end of ticker list, resetting to start.');
        resetTickersList();
      }
    }
  }

  getBufferCompaniesData(BuildContext context) async {
    _companies = _bufferCompaniesData;

    // Update UI after batch
    if (_companies.isNotEmpty) {
      await updateCards(context);
      await fetchCompanyStockPrice(_companies[0]['ticker'], context);
      fetchHistoricalStockPrice(_companies[0]['ticker'], context);
      fetchHistoricalSectorPerformance(_companies[0]['exchange'], context);
      fetchCompanyDividends(_companies[0]['ticker'], context);
      fetchHistoricalStockPriceForChart(_companies[0]['ticker'], context);
    } else {
      fetchCompaniesDataAsBuffer(context);
      debugPrint('No new companies fetched (all skipped or errors).');
    }
  }

  // For testing: Set tickers list
  void resetTickersList() {
    _tickersList = [];
  }

  Future<Map<String, dynamic>> fetchCompanyProfile(String ticker) async {
    String param = '&symbol=$ticker';
    List decodedData = await _repo.fetchCompanyProfile(param);
    Map companyData = decodedData[0];
    final double marketCap = companyData['marketCap'].toDouble();
    Map<String, dynamic> company = {
      'ticker': companyData['symbol'],
      'companyName': companyData['companyName'],
      'exchange': companyData['exchange'],
      'logoUrl': companyData['image'],
      'description': companyData['description'] ?? 'No Description',
      'sector': companyData['sector'] ?? 'Unknown',
      'isLargeCap': marketCap > 10000000000, // More than $10 billion,
      'isMidCap': marketCap > 2000000000 &&
          marketCap <
              10000000000, // More than $2 billion && Less than $10 billion,
      'isSmallCap': marketCap < 2000000000 // Less than $2 billion,
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

  Future fetchHistoricalStockPrice(String ticker, BuildContext context) async {
    Map timeRangeData = selectedTimeRangeData;
    debugPrint('Selected Time Range: $timeRangeData');
    debugPrint('ticker: $ticker');
    try {
      // _isFetching = true;
      String param =
          '&symbol=$ticker&from=${timeRangeData['from']}&to=${timeRangeData['to']}';
      final List historicalStockData =
          await _repo.fetchHistoricalStockPrice(param);
      debugPrint('Historical Stock Data: $historicalStockData');

      if (historicalStockData.isNotEmpty) {
        _stockPerformance = calculateStockPerformance(historicalStockData);
      } else {
        _stockPerformance = 0.0;
      }
    } catch (e) {
      Utils.errorSnackBar(context, e.toString());
      _stockPerformance = 0.0;
    }
    // _isFetching = false;
    notifyListeners();
    debugPrint('Company Stock Performance: $_stockPerformance');
  }

  Future fetchHistoricalSectorPerformance(
      String exchange, BuildContext context) async {
    Map timeRangeData = selectedTimeRangeData;
    debugPrint('Selected Time Range: $timeRangeData');
    debugPrint('exchange: $exchange');
    try {
      // _isFetching = true;
      String param =
          '&sector=Basic Materials&exchange=$exchange&from=${timeRangeData['from']}&to=${timeRangeData['to']}';
      debugPrint('sector Param: $param');
      final List historicalSectorData =
          await _repo.fetchHistoricalSectorPerformance(param);

      debugPrint('Historical Sector Data: $historicalSectorData');
      if (historicalSectorData.isNotEmpty) {
        _materialSectorPerformance =
            calculateMaterialsSectorPerformance(historicalSectorData);
      } else {
        _materialSectorPerformance = 0.0;
      }
    } catch (e) {
      Utils.errorSnackBar(context, e.toString());
      _materialSectorPerformance = 0.0;
    }
    // _isFetching = false;
    notifyListeners();
    debugPrint('Material Sector Performance: $_materialSectorPerformance');
  }

  Future fetchCompanyDividends(String ticker, BuildContext context) async {
    // try {
    String param = '&symbol=$ticker';
    final List dividendData = await _repo.fetchCompanyDividends(param);

    // Get the most recent dividend (first entry, assuming newest to oldest)
    if (dividendData.isNotEmpty) {
      final recentDividend = dividendData.first;
      final lastDividend = recentDividend['dividend'].toDouble();
      final frequency = recentDividend['frequency'];
      _dividendYield = calculateDividendYield(
          frequency, lastDividend, _companyStockQuote!['price'].toDouble());
    } else {
      _dividendYield = 0.0;
    }

    // } catch (e) {
    //   Utils.errorSnackBar(context, e.toString());
    //   _dividendYield = 0.0;
    // }
    notifyListeners();
    debugPrint('Dividend Yield: $_dividendYield');
  }

  Future likeThisTicker(BuildContext context, Map company) async {
    try {
      final data = {
        'user_id': _userSession.userId,
        'ticker_name':
            '${company['symbol']}.${company['exchange']}', // e.g., AAPL.NASDAQ
      };
      debugPrint('Like Ticker Data: $data');
      final response = await _repo.likeTicker(data);
      debugPrint('Like Ticker Response: $response');
      // Utils.successSnackBar(context, 'Ticker added to watchlist');
    } catch (e) {
      // Utils.errorSnackBar(context, e.toString());
      debugPrint('Like Ticker Error: $e');
    }
  }

  Future dislikeThisTicker(BuildContext context, Map company) async {
    try {
      final data = {
        'user_id': _userSession.userId,
        'ticker_name':
            '${company['symbol']}.${company['exchange']}', // e.g., AAPL.NASDAQ
      };
      debugPrint('Dislike Ticker Data: $data');
      final response = await _repo.dislikeTicker(data);
      debugPrint('DisLike Ticker Response: $response');
    } catch (e) {
      // Utils.errorSnackBar(context, e.toString());
      debugPrint('Dislike Ticker Error: $e');
    }
  }

  updateCompaniesList(BuildContext context, int prevIndex) {
    debugPrint('updateCompaniesList called');
    debugPrint('prevIndex: $prevIndex');
    if (_companies.length > 1) {
      _companies.removeAt(prevIndex);
    }
    notifyListeners();
  }

  Future getDislikedTickers(BuildContext context) async {
    debugPrint('getDislikedTickers called');
    try {
      Map data = {"user_id": _userSession.userId};
      final response = await _repo.getDislikedTickers(data);
      debugPrint('getDislikedTickers response: $response');
      if (response['status'] == true && response['data'] != []) {
        _dislikedTickers = response['data'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('getDislikedTickers error: $e');
      Utils.errorSnackBar(context, e.toString());
    }
  }

  Future getLikedTickers(BuildContext context) async {
    debugPrint('getLikedTickers called');
    try {
      Map data = {"user_id": _userSession.userId};
      final response = await _repo.getLikedTickers(data);
      debugPrint('getLikedTickers response: $response');
      if (response['status'] == 'success' && response['data'] != []) {
        _likedTickers = response['data'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('getLikedTickers error: $e');
      Utils.errorSnackBar(context, e.toString());
    }
  }

  resetChartData() {
    _isFetchingChart = true;
    _historicalStockDataForChart = [];
    _chartSpots = null;
    _monthLabels = null;
    _minY = null;
    _maxY = null;
    notifyListeners();
  }

  Future fetchHistoricalStockPriceForChart(
      String ticker, BuildContext context) async {
    resetChartData();
    final now = DateTime.now();
    final toDate =
        now.toString().split(' ')[0]; // YYYY-MM-DD (e.g., 2025-03-25)
    final fromDate =
        now.subtract(Duration(days: 150)); // Approx 5 months (30 days * 5)
    final fromDateString = fromDate.toString().split(' ')[0];
    debugPrint('fromDate: $fromDateString, toDate: $toDate');
    debugPrint('ticker: $ticker');
    try {
      String param = '&symbol=$ticker&from=$fromDateString&to=$toDate';
      _historicalStockDataForChart =
          await _repo.fetchHistoricalStockPrice(param);

      if (_historicalStockDataForChart.isNotEmpty) {
        debugPrint(
            'Historical Stock Data for chart: ${historicalStockDataForChart.first}, ${historicalStockDataForChart.last}');
      }

      // Process chart data
      final chartHistorical = _historicalStockDataForChart;
      final reversedHistorical = chartHistorical.reversed.toList();
      final spots = <FlSpot>[];
      final monthLabels = <String>[];
      double minPrice = double.infinity;
      double maxPrice = double.negativeInfinity;

      // Determine the date range (150 days)
      if (reversedHistorical.isEmpty) {
        print('No historical data available');
        return;
      }

      // Get the end date (most recent date) and calculate the start date (150 days ago)
      final endDate = DateTime.parse(reversedHistorical.last['date']);
      final startDate = endDate.subtract(Duration(days: 150));

      // Generate month labels for the period
      DateTime currentDate = DateTime(startDate.year, startDate.month, 1);
      while (
          currentDate.isBefore(endDate) || currentDate.month == endDate.month) {
        final formattedDate =
            '${monthAbbr(currentDate.month)} ${currentDate.year.toString().substring(2)}';
        monthLabels.add(formattedDate);
        // Move to the next month
        currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
      }

      // Create spots for the chart
      for (int i = 0; i < reversedHistorical.length; i++) {
        final entry = reversedHistorical[i] as Map<String, dynamic>;
        final price = entry['close'].toDouble();
        spots.add(FlSpot(i.toDouble(), price));

        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;
      }

      _isFetchingChart = false;
      _errorMsgForChart = '';
      // Add padding to minY and maxY
      // final priceRange = maxPrice - minPrice;
      // final padding = priceRange * 0.05;
      // final calculatedMinY = (minPrice - padding).floorToDouble();
      // final calculatedMaxY = (maxPrice + padding).ceilToDouble();
      final calculatedMinY = minPrice.floorToDouble();
      final calculatedMaxY = maxPrice.ceilToDouble();

      print('Total data points: ${reversedHistorical.length}');
      print('Month Labels: $monthLabels');

      _chartSpots = spots;
      _monthLabels = monthLabels;
      _minY = calculatedMinY;
      _maxY = calculatedMaxY;
    } catch (e) {
      _isFetchingChart = false;
      _errorMsgForChart = e.toString();
      Utils.errorSnackBar(context, e.toString());
      debugPrint('Error fetching historical stock data for chart: $e');
    }
    notifyListeners();

    // debugPrint('Historical Stock Data for chart: $_historicalStockDataForChart');
  }

  String monthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  double calculateYInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 50) {
      return 10;
    } else if (range <= 200) {
      return 20;
    } else if (range <= 500) {
      return 50;
    } else if (range <= 2000) {
      return 100;
    } else {
      return 500;
    }
  }

  calculateDividendYield(String? frequency, double lastDividend, double price) {
    // Calculate annual dividend based on frequency
    double annualDividend;
    switch (frequency) {
      case 'Quarterly':
        annualDividend = lastDividend * 4;
        break;
      case 'Semi-Annually':
        annualDividend = lastDividend * 2;
        break;
      case 'Annually':
        annualDividend = lastDividend;
        break;
      case 'Monthly':
        annualDividend = lastDividend * 12;
        break;
      default:
        annualDividend = 0.0; // Unknown or irregular frequency
    }

    // Calculate Dividend Yield
    if (price == 0.0 || annualDividend == 0.0) {
      return 0.0;
    }

    final dividendYield = (annualDividend / price) * 100;
    return dividendYield;
  }

  calculateStockPerformance(List historicalStockData) {
    if (historicalStockData.isEmpty || historicalStockData.length < 2) {
      return 0.0; // Not enough data to calculate performance
    }

    // First and last close prices (newest to oldest) i.e 21-03-2025 to 20-03-2025
    final firstClose = historicalStockData.last['close'].toDouble();
    final lastClose = historicalStockData.first['close'].toDouble();

    // Calculate percentage change
    return ((lastClose - firstClose) / firstClose) * 100;
  }

  calculateMaterialsSectorPerformance(List historicalStockData) {
    if (historicalStockData.isEmpty || historicalStockData.length < 2) {
      return 0.0; // Not enough data to calculate performance
    }

    // First and last close prices (oldest to newest) i.e 20-03-2025 to 21-03-2025
    final firstClose = historicalStockData.first['averageChange'].toDouble();
    final lastClose = historicalStockData.last['averageChange'].toDouble();

    // Calculate percentage change
    return ((lastClose - firstClose) / firstClose) * 100;
  }
}
