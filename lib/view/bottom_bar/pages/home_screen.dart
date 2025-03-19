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
                                    if (direction ==
                                        CardSwiperDirection.right) {
                                      debugPrint(
                                          '${_viewModel.companyStockQuote}');
                                      if (_viewModel.companyStockQuote !=
                                          null) {
                                        debugPrint(
                                            'value is not empty: ${_viewModel.companyStockQuote}');
                                        bool result = await _appData
                                            .addToWatchlistIfNotExists(
                                                _viewModel.companyStockQuote,
                                                context);
                                        if (result) {
                                          Utils.successSnackBar(context,
                                              'Stock added to your watchlist.');
                                        }
                                      } else {
                                        // Utils.errorSnackBar(
                                        //     context, 'Payment Required.');
                                        debugPrint(
                                            'value is empty: ${_viewModel.companyStockQuote}');
                                      }
                                    }

                                    _viewModel.setCurrentTopIndex(currentIndex);
                                    _viewModel.updateCards(
                                        context); // Update card colors after swipe
                                    debugPrint(
                                        "Swiped to: ${_viewModel.currentTopIndex}");

                                    //Adding Stock in watchList

                                    // _viewModel.resetStockPrice();
                                    String ticker = _viewModel
                                        .companies[currentIndex!]['ticker'];
                                    debugPrint('ticker: $ticker');
                                    // if (_viewModel.companyStockQuote == null) {
                                    //   debugPrint('abc');
                                    await _viewModel.fetchCompanyStockPrice(
                                        ticker, context);
                                    // }

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
                  onTap: () async {
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
                            maxLines: 4,
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
                    _homeViewModel.setCardChildIndex(0);
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
                                        color: AppColors.red),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4)),
                                  width: 30,
                                  height: 18,
                                  child: Center(
                                    child: Text(
                                      '1D',
                                      style: kElevenRegWhitePoppins,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Container(
                                width: 1,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                              ),
                              Container(
                                  width: 30,
                                  height: 18,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      '1W',
                                      style: kElevenRegBlackPoppins,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Container(
                                width: 1,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                              ),
                              Container(
                                  width: 30,
                                  height: 18,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      '1M',
                                      style: kElevenRegBlackPoppins,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Container(
                                width: 1,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                              ),
                              Container(
                                  width: 30,
                                  height: 18,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      '1Y',
                                      style: kElevenRegBlackPoppins,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Container(
                                width: 1,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                              ),
                              Container(
                                  width: 30,
                                  height: 18,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      'Max',
                                      style: kElevenRegBlackPoppins,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'FMG \n performance',
                                    textAlign: TextAlign.center,
                                    style: kTenRegAEB6B7Poppins.copyWith(
                                        color: AppColors.color3B3B3B),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    '-2.5%',
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    '-2.5%',
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    '7.5%',
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
                        AssetsImageMd(
                            height: height * 0.265, name: Assets.chart),
                        SizedBox(
                          height: 15,
                        ),
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
