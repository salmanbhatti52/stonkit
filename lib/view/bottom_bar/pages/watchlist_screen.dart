import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/assets.dart';
import 'package:stonk_it/resources/colors.dart';
import 'package:stonk_it/resources/constants.dart';
import 'package:stonk_it/storage/app_data.dart';
import 'package:stonk_it/view/bottom_bar/pages/home_screen.dart';

import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../view_model/bottom_bar_model/watchlist_view_model.dart';
import '../../settings/pages/profile_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late WatchListViewModel _viewModel;
  late AppData _appData;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<WatchListViewModel>(context, listen: false);
    _appData = Provider.of<AppData>(context, listen: false);
    init();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _viewModel.getLikedTickers(context);
    }
  }

  init() {
    _appData.loadWatchlistData();
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
              height: height * 0.0738,
              width: width,
              color: AppColors.primary,
            ),
            Container(
              height: height * 0.697,
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
                        child: Consumer<AppData>(
                          builder: (context, object, child) {
                            debugPrint('watchlist: ${_appData.watchlist}');
                            return _appData.watchlist.isNotEmpty
                                ? Column(
                                    children: List.generate(
                                        _appData.watchlist.length, (index) {
                                      final Map<String, dynamic>? data =
                                          _appData.watchlist[index];
                                      return Slidable(
                                        key: Key(data?['symbol']! +
                                            index.toString()), // Unique key
                                        endActionPane: ActionPane(
                                          motion: ScrollMotion(),
                                          dragDismissible: true,
                                          extentRatio: 0.25,
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) {
                                                _appData.deleteWatchlistData(
                                                    data?['symbol'], context);
                                                // _viewModel.removeItem(index);
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
                                          onTap: () {
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
                                                              FirstCardWidget(
                                                            ticker: 'FMG',
                                                            exchange: 'ASX',
                                                            isLargeCap: true,
                                                            sector: 'Materials',
                                                            backgroundColor:
                                                                Colors.white,
                                                            companyName:
                                                                'TechNova Pvt Ltd',
                                                            // registeredName:
                                                            //     'TechNova Pvt Ltd',
                                                            logoUrl:
                                                                "https://dummyimage.com/150x150/000/fff&text=TechNova",
                                                            description:
                                                                'TechNova Solutions is a leader in the tech industry, providing innovative software solutions and IT consulting services.With a focus on cutting-edge technologies, we help businesses optimize their digital transformation journey.',
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              DataCell(
                                                data?['symbol']!,
                                                kTwelveRegular050B15Poppins
                                                    .copyWith(
                                                  color: AppColors.darkGray,
                                                ),
                                              ),
                                              DataCell(
                                                "${(data!['changePercentage']).toStringAsFixed(1)}%",
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
                                                '\$${(data['price']).toString()}',
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
