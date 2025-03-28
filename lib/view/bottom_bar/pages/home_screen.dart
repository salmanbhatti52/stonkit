import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stonk_it/resources/components/network_image_md.dart';
import 'package:stonk_it/storage/app_data.dart';
import 'package:stonk_it/view_model/bottom_bar_model/home_view_model.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/components/custom_button.dart';
import '../../../resources/constants.dart';
import '../../../utils/utils.dart';
import '../../settings/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _cardSwiperController = CardSwiperController();
  late HomeViewModel _viewModel;
  late AppData _appData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    _appData = Provider.of<AppData>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _viewModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBarWithImageMd(
          title: '',
          onlyTitle: false,
          increaseHeight: 20,
          suffixIcon: SvgAssetImageMd(
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.id);
            },
            name: Assets.profileIcon,
            width: 24,
            height: 24,
            alignment: Alignment.center,
          ),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                value.companies.isNotEmpty
                    ? Expanded(
                        child: Stack(
                          children: [
                            // Background Container
                            Container(
                              height: height * 0.065,
                              width: width,
                              color: AppColors.primary,
                            ),
                            //
                            // CardSwiper with Bottom Padding
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: SizedBox(
                                height: height * 0.7,
                                child: CardSwiper(
                                  controller: _cardSwiperController,
                                  cardsCount: value.cards.length,
                                  allowedSwipeDirection:
                                      AllowedSwipeDirection.symmetric(
                                    horizontal: true,
                                    vertical: false,
                                  ),
                                  isLoop: true,
                                  onSwipe: (previousIndex, currentIndex,
                                      direction) async {
                                    Map companyData =
                                        _viewModel.companies[currentIndex!];
                                    Map<String, dynamic>? companyStockQuote =
                                        _viewModel.companyStockQuote;
                                    if (direction ==
                                        CardSwiperDirection.right) {
                                      debugPrint('$companyStockQuote');
                                      if (companyStockQuote != null) {
                                        debugPrint(
                                            'value is not empty: $companyStockQuote');
                                        bool result = await _appData
                                            .addToWatchlistIfNotExists(
                                                companyStockQuote, context);
                                        if (result) {
                                          Utils.successSnackBar(context,
                                              'Stock added to your watchlist.');
                                          await _viewModel.likeThisTicker(
                                              context, companyStockQuote);
                                        }
                                      } else {
                                        // Utils.errorSnackBar(
                                        //     context, 'Payment Required.');
                                        debugPrint(
                                            'value is empty: $companyStockQuote');
                                      }
                                    }
                                    if (direction == CardSwiperDirection.left) {
                                      if (companyStockQuote != null) {
                                        debugPrint(
                                            'value is not empty: $companyStockQuote');
                                        // bool result = await _appData
                                        //     .addToWatchlistIfNotExists(
                                        //     companyStockQuote, context);
                                        // if (result) {
                                        //   Utils.successSnackBar(context,
                                        //       'Stock added to your watchlist.');
                                        await _viewModel.dislikeThisTicker(
                                            context, companyStockQuote);
                                        // }
                                      } else {
                                        // Utils.errorSnackBar(
                                        //     context, 'Payment Required.');
                                        debugPrint(
                                            'value is empty: $companyStockQuote');
                                      }
                                    }
                                    _viewModel.setCurrentTopIndex(currentIndex);
                                    _viewModel.updateCards(
                                        context); // Update card colors after swipe
                                    debugPrint(
                                        "Swiped to: ${_viewModel.currentTopIndex}");

                                    //Adding Stock in watchList

                                    // _viewModel.resetStockPrice();
                                    String ticker = companyData['ticker'];
                                    debugPrint('ticker: $ticker');
                                    // if (companyStockQuote == null) {
                                    //   debugPrint('abc');
                                    await _viewModel.fetchCompanyStockPrice(
                                        ticker, context);
                                    _viewModel.fetchHistoricalStockPrice(
                                        companyData['ticker'], context);
                                    _viewModel.fetchHistoricalSectorPerformance(
                                        companyData['exchange'], context);
                                    _viewModel.fetchCompanyDividends(
                                        companyData['ticker'], context);
                                    // }
                                    _viewModel
                                        .fetchHistoricalStockPriceForChart(
                                            companyData['ticker'], context);

                                    print(currentIndex);

                                    return true;
                                  },
                                  onUndo:
                                      (previousIndex, currentIndex, direction) {
                                    return false;
                                  },
                                  numberOfCardsDisplayed: 3,
                                  backCardOffset: const Offset(0, 40),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                  cardBuilder: (
                                    context,
                                    index,
                                    horizontalThresholdPercentage,
                                    verticalThresholdPercentage,
                                  ) {
                                    return value.cards[index];
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: Stack(
                        children: [
                          Container(
                            height: height * 0.065,
                            width: width,
                            color: AppColors.primary,
                          ),
                          // value.companies.isEmpty
                          //     ? Container(
                          //         height: height * 0.69,
                          //         margin: EdgeInsets.symmetric(horizontal: 51),
                          //         decoration: BoxDecoration(
                          //             color: AppColors.lightGray,
                          //             borderRadius: BorderRadius.circular(8),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                   color: Colors.black.withValues(
                          //                       alpha: (0.1 * 255).toDouble()),
                          //                   blurRadius: 4,
                          //                   offset: Offset(0, 3))
                          //             ]),
                          //       )
                          //     : SizedBox(),
                          Container(
                            height: height * 0.662,
                            margin: EdgeInsets.symmetric(horizontal: 35),
                            decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withValues(
                                          alpha: (0.1 * 255).toDouble()),
                                      blurRadius: 4,
                                      offset: Offset(0, 3))
                                ]),
                          ),

                          Container(
                            height: height * 0.64,
                            width: width,
                            margin: EdgeInsets.symmetric(horizontal: 19),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.color4B4B4B.withValues(
                                          alpha: (0.1 * 255).toDouble()),
                                      blurRadius: 4,
                                      offset: Offset(0, 3))
                                ]),
                            child: Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [],
                                  ),
                                )),
                          )
                        ],
                      ))
              ],
            );
          },
        ),
      ),
    );
  }
}

class FirstCardWidget extends StatefulWidget {
  final Color backgroundColor;
  final String? companyName;
  final String? ticker;
  final String? description;
  final String? logoUrl;
  final String exchange;
  final String sector;
  final bool isLargeCap;

  const FirstCardWidget(
      {super.key,
      required this.backgroundColor,
      required this.companyName,
      required this.ticker,
      required this.description,
      this.logoUrl,
      required this.exchange,
      required this.sector,
      required this.isLargeCap});

  @override
  FirstCardWidgetState createState() => FirstCardWidgetState();
}

class FirstCardWidgetState extends State<FirstCardWidget> {
  late HomeViewModel _homeViewModel;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Consumer<HomeViewModel>(
        builder: (context, value, child) {
          return _homeViewModel.cardChildIndex == 0
              ? GestureDetector(
                  onTap: () {
                    _homeViewModel.setCardChildIndex(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.exchange,
                          style: kTwentySbPrimaryPoppins,
                          textAlign: TextAlign.right,
                        ),
                        Spacer(),
                        // AssetsImageMd(
                        //   name: Assets.fmgLtd,
                        //   width: 170,
                        //   height: 146.2,
                        //   alignment: Alignment.center,
                        // ),
                        Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: NetworkImageMd(
                                name: widget.logoUrl ?? '',
                                height: 100,
                                width: 100,
                                // width: 150,
                                // height: ,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),

                        Spacer(),
                        Text(
                          widget.companyName ?? 'FORTSCUE METALS GROUP LTD',
                          textAlign: TextAlign.center,
                          style: kSixteenMediumWhitePoppins.copyWith(
                              color: Colors.black),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.description ??
                                'Fortescue is a global leader in the iron ore industry, recognised for our innovation and development of world class infrastructure and mining assets',
                            textAlign: TextAlign.center,
                            style: kFourteenRegBlackPoppins.copyWith(
                                color: AppColors.darkGray),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.isLargeCap
                                ? CustomButton(
                                    margin: EdgeInsets.symmetric(horizontal: 9),
                                    height: 35,
                                    width: 120,
                                    buttonText: 'Large Cap',
                                    textStyle: kTwelveRegular050B15Poppins
                                        .copyWith(color: Colors.white),
                                    color: AppColors.primary,
                                    prefixIcon: Assets.tag,
                                    borderColor: Colors.transparent)
                                : SizedBox(),
                            // SizedBox(
                            //   width: 18,
                            // ),
                            widget.sector.isNotEmpty ||
                                    widget.sector != 'Unknown'
                                ? CustomButton(
                                    margin: EdgeInsets.symmetric(horizontal: 9),
                                    height: 35,
                                    width: 120,
                                    buttonText: 'Materials',
                                    textStyle: kTwelveRegular050B15Poppins
                                        .copyWith(color: Colors.white),
                                    color: AppColors.lightBlue,
                                    prefixIcon: Assets.tag,
                                    borderColor: Colors.transparent)
                                : SizedBox()
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            2,
                            (index) => GestureDetector(
                              onTap: () {
                                _homeViewModel.setCardChildIndex(index);
                              },
                              child: Container(
                                width: 14.0,
                                height: 14.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _homeViewModel.cardChildIndex == index
                                      ? AppColors.primary
                                      : AppColors.colorD9D9D9,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Spacer(),
                        SizedBox(
                          height: 14,
                        )
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    // _homeViewModel.setCardChildIndex(0);
                  },
                  child: Container(
                    // width: width * 1.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.3, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${widget.exchange}: ${widget.ticker}',
                          style: kThirtyBoldBluePjs,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Consumer<HomeViewModel>(
                          builder: (context, value, child) {
                            return value.isFetching == false
                                ? Text(
                                    value.companyStockQuote != null
                                        ? '\$${value.companyStockQuote?['price']}'
                                        : '\$',
                                    style: kTwentyEightSbGreenPoppins.copyWith(
                                        color: _homeViewModel.stockPerformance
                                                .toString()
                                                .startsWith('-')
                                            ? AppColors.red
                                            : null),
                                    textAlign: TextAlign.center,
                                  )
                                : CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: width * 0.7,
                          height: 25,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.76),
                              borderRadius: BorderRadius.circular(7.55)),
                          child: Row(
                            children: List.generate(
                              _homeViewModel.timeFrames.length,
                              (index) {
                                bool isSelected =
                                    _homeViewModel.timeFrames[index] ==
                                        _homeViewModel.selectedTimeRange;
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _homeViewModel.setSelectedTimeFrame(
                                            _homeViewModel.timeFrames[index]);
                                        _homeViewModel
                                            .fetchHistoricalStockPrice(
                                                widget.ticker!, context);
                                        _homeViewModel
                                            .fetchHistoricalSectorPerformance(
                                                widget.exchange, context);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 18,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.transparent,
                                            borderRadius: isSelected
                                                ? BorderRadius.circular(4)
                                                : null),
                                        child: Text(
                                          _homeViewModel.timeFrames[index],
                                          style: isSelected
                                              ? kElevenRegWhitePoppins
                                              : kElevenRegBlackPoppins,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    if (index !=
                                        _homeViewModel.timeFrames.length - 1)
                                      Container(
                                        width: 1,
                                        color: Colors.black,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 9, vertical: 4),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            _homeViewModel.setCardChildIndex(0);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    constraints:
                                        BoxConstraints(minWidth: width * 0.23),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.ticker} \n performance',
                                          textAlign: TextAlign.center,
                                          style: kTenRegAEB6B7Poppins.copyWith(
                                              color: AppColors.color3B3B3B),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          '${_homeViewModel.stockPerformance.toStringAsFixed(1)}%',
                                          style: kTwentyMedRedPoppins,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    constraints:
                                        BoxConstraints(minWidth: width * 0.29),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Materials Sector \n performance',
                                          textAlign: TextAlign.center,
                                          style: kTenRegAEB6B7Poppins.copyWith(
                                              color: AppColors.color3B3B3B),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          '${_homeViewModel.materialSectorPerformance.toStringAsFixed(1)}%',
                                          style: kTwentyMedRedPoppins,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    constraints:
                                        BoxConstraints(minWidth: width * 0.23),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Dividend \n Yield',
                                          textAlign: TextAlign.center,
                                          style: kTenRegAEB6B7Poppins.copyWith(
                                              color: AppColors.color3B3B3B),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          '${_homeViewModel.dividendYield.toStringAsFixed(1)}%',
                                          style: kTwentyMedRedPoppins.copyWith(
                                              color: AppColors.green),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              SizedBox(
                                height: height * 0.28,
                                child: _homeViewModel.isFetchingChart == true
                                    ? Center(child: CircularProgressIndicator())
                                    : _homeViewModel.isFetchingChart == false &&
                                            _homeViewModel.errorMsgForChart !=
                                                ''
                                        ? Center(
                                            child: Text(
                                              '${_homeViewModel.errorMsgForChart} for this stock',
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: LineChart(
                                              LineChartData(
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    spots: _homeViewModel
                                                        .chartSpots!,
                                                    isCurved: true,
                                                    color: AppColors.primary,
                                                    dotData:
                                                        FlDotData(show: false),
                                                    belowBarData: BarAreaData(
                                                      show: true,
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                ],
                                                minY: _homeViewModel.minY!,
                                                maxY: _homeViewModel.maxY!,
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        if (_homeViewModel
                                                                    .monthLabels ==
                                                                null ||
                                                            _homeViewModel
                                                                .monthLabels!
                                                                .isEmpty ||
                                                            _homeViewModel
                                                                    .chartSpots ==
                                                                null) {
                                                          return const SizedBox
                                                              .shrink();
                                                        }

                                                        final totalPoints =
                                                            _homeViewModel
                                                                .chartSpots!
                                                                .length
                                                                .toDouble();
                                                        final numMonths =
                                                            _homeViewModel
                                                                .monthLabels!
                                                                .length;

                                                        final monthPositions =
                                                            <double>[];
                                                        for (int i = 0;
                                                            i < numMonths;
                                                            i++) {
                                                          final position = (i *
                                                                  totalPoints) /
                                                              (numMonths - 1);
                                                          monthPositions
                                                              .add(position);
                                                        }

                                                        int closestIndex = 0;
                                                        double minDistance =
                                                            double.infinity;
                                                        for (int i = 0;
                                                            i <
                                                                monthPositions
                                                                    .length;
                                                            i++) {
                                                          final distance = (value -
                                                                  monthPositions[
                                                                      i])
                                                              .abs();
                                                          if (distance <
                                                              minDistance) {
                                                            minDistance =
                                                                distance;
                                                            closestIndex = i;
                                                          }
                                                        }

                                                        if (closestIndex < 0 ||
                                                            closestIndex >=
                                                                numMonths) {
                                                          return const SizedBox
                                                              .shrink();
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child:
                                                              Transform.rotate(
                                                            angle: -45 *
                                                                3.14159 /
                                                                180, // Rotate 45 degrees
                                                            child: Text(
                                                              _homeViewModel
                                                                      .monthLabels![
                                                                  closestIndex],
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      reservedSize: 40,
                                                      interval: (_homeViewModel
                                                                  .chartSpots!
                                                                  .length /
                                                              (_homeViewModel
                                                                      .monthLabels!
                                                                      .length -
                                                                  1))
                                                          .ceilToDouble(),
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Text(
                                                          value
                                                              .toInt()
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                        );
                                                      },
                                                      reservedSize: 40,
                                                      interval: _homeViewModel
                                                          .calculateYInterval(
                                                              _homeViewModel
                                                                  .minY!,
                                                              _homeViewModel
                                                                  .maxY!),
                                                    ),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  rightTitles: const AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                ),
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawVerticalLine: false,
                                                  horizontalInterval:
                                                      _homeViewModel
                                                          .calculateYInterval(
                                                              _homeViewModel
                                                                  .minY!,
                                                              _homeViewModel
                                                                  .maxY!),
                                                  getDrawingHorizontalLine:
                                                      (value) {
                                                    return FlLine(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      strokeWidth: 0,
                                                    );
                                                  },
                                                ),
                                                borderData:
                                                    FlBorderData(show: false),
                                              ),
                                            ),
                                          ),
                              ),
                              SizedBox(),
                              // AssetsImageMd(
                              //     height: height * 0.265, name: Assets.chart),
                              // SizedBox(
                              //   height: 12.2,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  2,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _homeViewModel.setCardChildIndex(index);
                                    },
                                    child: Container(
                                      width: 14.0,
                                      height: 14.0,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _homeViewModel.cardChildIndex ==
                                                index
                                            ? AppColors.primary
                                            : AppColors.colorD9D9D9,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 15,
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
