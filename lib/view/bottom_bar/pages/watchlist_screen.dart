import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/assets.dart';
import 'package:stonk_it/resources/colors.dart';
import 'package:stonk_it/resources/constants.dart';

import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/components/custom_button.dart';
import '../../../resources/components/network_image_md.dart';
import '../../../view_model/bottom_bar_model/watchlist_view_model.dart';
import '../../settings/pages/profile_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late WatchListViewModel _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('watch list initState called');
    _viewModel = Provider.of<WatchListViewModel>(context, listen: false);
    init();
  }

  init() {
    debugPrint('init called');
    _viewModel.getLikedTickers(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
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
        body: Stack(
          children: [
            Container(
              height: height * 0.07,
              width: width,
              color: AppColors.primary,
            ),
            Container(
              height: height * 0.64,
              margin: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              padding: EdgeInsets.only(bottom: 19),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          HeaderCell('Ticker'),
                          HeaderCell('Daily Change'),
                          HeaderCell('Share Price'),
                          HeaderCell('Liked'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Consumer<WatchListViewModel>(
                          builder: (context, object, child) {
                            debugPrint(
                                'watchlist view side: ${object.watchlist}');
                            return object.watchlist.isNotEmpty
                                ? Column(
                                    children: List.generate(
                                        object.watchlist.length, (index) {
                                      final Map<String, dynamic> data =
                                          object.watchlist[index];
                                      return Slidable(
                                        key: Key(data['symbol']! +
                                            index.toString()), // Unique key
                                        endActionPane: ActionPane(
                                          motion: ScrollMotion(),
                                          dragDismissible: true,
                                          extentRatio: 0.25,
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) {
                                                object.deleteWatchlistData(
                                                    data['symbol'], context);
                                                object.dislikeThisTicker(
                                                    context, data);
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              padding: EdgeInsets.zero,

                                              // spacing: 10,
                                              // label: 'Delete',
                                            ),
                                            // Icon(Icons.delete)
                                          ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () async {
                                            debugPrint(
                                                'Ticker: ${data['symbol']}');
                                            _viewModel.setCardChildIndex(0);
                                            String tickerName = data['symbol']!;
                                            Map companyData = await _viewModel
                                                .fetchCompanyProfile(
                                                    tickerName);
                                            showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                print('stateful 1');
                                                return StatefulBuilder(
                                                  builder: (context,
                                                      setDialogState) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setDialogState(() {});
                                                      },
                                                      child: AlertDialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        insetPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: SizedBox(
                                                          height: MediaQuery
                                                                      .sizeOf(
                                                                          context)
                                                                  .height *
                                                              0.65, // Use dynamic height
                                                          width: MediaQuery
                                                                      .sizeOf(
                                                                          context)
                                                                  .width *
                                                              0.9, // Optional: dynamic width
                                                          child:
                                                              WatchListScreenCard(
                                                            ticker: companyData[
                                                                'ticker'],
                                                            exchange:
                                                                companyData[
                                                                    'exchange'],
                                                            isLargeCap:
                                                                companyData[
                                                                    'isLargeCap'],
                                                            sector: companyData[
                                                                'sector'],
                                                            backgroundColor:
                                                                Colors.white,
                                                            companyName:
                                                                companyData[
                                                                    'companyName'],
                                                            // registeredName:
                                                            //     'TechNova Pvt Ltd',
                                                            logoUrl:
                                                                companyData[
                                                                    'logoUrl'],
                                                            description:
                                                                companyData[
                                                                    'description'],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                            if (companyData.isNotEmpty) {
                                              await _viewModel
                                                  .fetchCompanyStockPriceForCard(
                                                      companyData['ticker'],
                                                      context);
                                              _viewModel
                                                  .fetchHistoricalStockPrice(
                                                      companyData['ticker'],
                                                      context);
                                              _viewModel
                                                  .fetchHistoricalSectorPerformance(
                                                      companyData['exchange'],
                                                      context);
                                              _viewModel.fetchCompanyDividends(
                                                  companyData['ticker'],
                                                  context);
                                              _viewModel
                                                  .fetchHistoricalStockPriceForChart(
                                                      companyData['ticker'],
                                                      context);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              DataCell(
                                                data['symbol']!,
                                                kTwelveRegular050B15Poppins
                                                    .copyWith(
                                                  color: AppColors.darkGray,
                                                ),
                                              ),
                                              DataCell(
                                                "${(data['changePercentage']).toStringAsFixed(1)}%",
                                                kTwelveRegular050B15Poppins
                                                    .copyWith(
                                                  color:
                                                      data['changePercentage']
                                                              .toString()
                                                              .startsWith('-')
                                                          ? AppColors.red
                                                          : AppColors.green,
                                                ),
                                              ),
                                              DataCell(
                                                '\$${(data['price']).toStringAsFixed(1)}',
                                                kTwelveRegular050B15Poppins
                                                    .copyWith(
                                                  color: AppColors.darkGray,
                                                ),
                                              ),
                                              LikedCell(
                                                  data['liked'].toString()),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  )
                                : SizedBox();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCell extends StatelessWidget {
  final String text;

  const HeaderCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: kFourteenRegBlackPoppins.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class DataCell extends StatelessWidget {
  final String text;
  final TextStyle style;

  const DataCell(this.text, this.style, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(11.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}

class LikedCell extends StatelessWidget {
  final String text;

  const LikedCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(11.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text == '100+' ? SvgAssetImageMd(name: Assets.rocket) : SizedBox(),
            SizedBox(width: 4),
            Text(
              text,
              style: kTwelveRegular050B15Poppins.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchListScreenCard extends StatefulWidget {
  final Color backgroundColor;
  final String? companyName;
  final String? ticker;
  final String? description;
  final String? logoUrl;
  final String exchange;
  final String sector;
  final bool isLargeCap;

  const WatchListScreenCard(
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
  WatchListScreenCardState createState() => WatchListScreenCardState();
}

class WatchListScreenCardState extends State<WatchListScreenCard> {
  late WatchListViewModel _watchListViewModel;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _watchListViewModel =
        Provider.of<WatchListViewModel>(context, listen: false);
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
      child: Consumer<WatchListViewModel>(
        builder: (context, value, child) {
          return _watchListViewModel.cardChildIndex == 0
              ? GestureDetector(
                  onTap: () {
                    _watchListViewModel.setCardChildIndex(1);
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
                          widget.companyName ?? 'Lorem Ipsum',
                          textAlign: TextAlign.center,
                          style: kSixteenMediumWhitePoppins.copyWith(
                              color: Colors.black),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.description ??
                                'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem IpsumLorem IpsumLorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
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
                                _watchListViewModel.setCardChildIndex(index);
                              },
                              child: Container(
                                width: 14.0,
                                height: 14.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _watchListViewModel.cardChildIndex ==
                                          index
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
                    // _watchListViewModel.setCardChildIndex(0);
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
                        Consumer<WatchListViewModel>(
                          builder: (context, value, child) {
                            return value.isFetching == false
                                ? Text(
                                    value.companyStockQuote != null
                                        ? '\$${value.companyStockQuote?['price'].toStringAsFixed(1)}'
                                        : '\$',
                                    style: kTwentyEightSbGreenPoppins.copyWith(
                                        color: _watchListViewModel
                                                .stockPerformance
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
                              _watchListViewModel.timeFrames.length,
                              (index) {
                                bool isSelected =
                                    _watchListViewModel.timeFrames[index] ==
                                        _watchListViewModel.selectedTimeRange;
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _watchListViewModel
                                            .setSelectedTimeFrame(
                                                _watchListViewModel
                                                    .timeFrames[index]);
                                        _watchListViewModel
                                            .fetchHistoricalStockPrice(
                                                widget.ticker!, context);
                                        _watchListViewModel
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
                                          _watchListViewModel.timeFrames[index],
                                          style: isSelected
                                              ? kElevenRegWhitePoppins
                                              : kElevenRegBlackPoppins,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    if (index !=
                                        _watchListViewModel.timeFrames.length -
                                            1)
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
                            _watchListViewModel.setCardChildIndex(0);
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
                                          '${_watchListViewModel.stockPerformance.toStringAsFixed(1)}%',
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
                                          '${_watchListViewModel.materialSectorPerformance.toStringAsFixed(1)}%',
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
                                          '${_watchListViewModel.dividendYield.toStringAsFixed(1)}%',
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
                                height: height * 0.258,
                                child: _watchListViewModel.isFetchingChart ==
                                        true
                                    ? Center(child: CircularProgressIndicator())
                                    : _watchListViewModel.isFetchingChart ==
                                                false &&
                                            _watchListViewModel
                                                    .errorMsgForChart !=
                                                ''
                                        ? Center(
                                            child: Text(
                                              '${_watchListViewModel.errorMsgForChart} to view this stock chart.',
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: LineChart(
                                              LineChartData(
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    spots: _watchListViewModel
                                                        .chartSpots!,
                                                    isCurved: true,
                                                    color: AppColors.primary,
                                                    dotData:
                                                        FlDotData(show: false),
                                                    belowBarData: BarAreaData(
                                                      show: true,
                                                      color: Colors.blue
                                                          .withValues(
                                                              alpha: 0.2),
                                                    ),
                                                  ),
                                                ],
                                                minY: _watchListViewModel.minY!,
                                                maxY: _watchListViewModel.maxY!,
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        if (_watchListViewModel.monthLabels ==
                                                                null ||
                                                            _watchListViewModel
                                                                .monthLabels!
                                                                .isEmpty ||
                                                            _watchListViewModel
                                                                    .chartSpots ==
                                                                null) {
                                                          return const SizedBox
                                                              .shrink();
                                                        }

                                                        final totalPoints =
                                                            _watchListViewModel
                                                                .chartSpots!
                                                                .length
                                                                .toDouble();
                                                        final numMonths =
                                                            _watchListViewModel
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
                                                              _watchListViewModel
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
                                                      interval: (_watchListViewModel
                                                                  .chartSpots!
                                                                  .length /
                                                              (_watchListViewModel
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
                                                      interval: _watchListViewModel
                                                          .calculateYInterval(
                                                              _watchListViewModel
                                                                  .minY!,
                                                              _watchListViewModel
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
                                                      _watchListViewModel
                                                          .calculateYInterval(
                                                              _watchListViewModel
                                                                  .minY!,
                                                              _watchListViewModel
                                                                  .maxY!),
                                                  getDrawingHorizontalLine:
                                                      (value) {
                                                    return FlLine(
                                                      color: Colors.grey
                                                          .withValues(
                                                              alpha: 0.2),
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
                              // SizedBox(
                              //   height: 12.2,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  2,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _watchListViewModel
                                          .setCardChildIndex(index);
                                    },
                                    child: Container(
                                      width: 14.0,
                                      height: 14.0,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _watchListViewModel
                                                    .cardChildIndex ==
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
