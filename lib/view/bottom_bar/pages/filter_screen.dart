import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/resources/constants.dart';
import 'package:stonk_it/view_model/bottom_bar_model/filter_view_model.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/components/app_bar_md.dart';
import '../../../resources/components/asset_image_md.dart';
import '../../../resources/components/custom_button.dart';
import '../../settings/pages/profile_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterViewModel _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<FilterViewModel>(context, listen: false);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    // double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWithImageMd(
          title: '', onlyTitle: false,
          increaseHeight: 5,
          // backgroundColor: AppColors.primary,
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
        backgroundColor: AppColors.scaffoldBackground,
        body: Padding(
          padding: EdgeInsets.only(bottom: height * 0.055),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sector Selection',
                            style: kEighteenMedBlackPoppins,
                          ),
                          GestureDetector(
                            onTap: () {
                              _viewModel.toggleAllSectorsSelection();
                            },
                            child: Container(
                                height: 20,
                                width: 70,
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  'Select All',
                                  style: kTenMedBluePoppins,
                                ))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // Enables full horizontal scrolling
                        child: Consumer<FilterViewModel>(
                          builder: (context, value, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _viewModel.sectors.every((element) =>
                                        element['selected'] == false)
                                    ? Text(
                                        'Choose at least 1 sector',
                                        style: kTwelveRegular050B15Poppins
                                            .copyWith(
                                                color: AppColors.red,
                                                fontWeight: FontWeight.w600),
                                      )
                                    : SizedBox(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    2,
                                    (rowIndex) {
                                      // Creating 2 rows, now with max 6 items per row
                                      int startIndex = rowIndex * 6;
                                      int endIndex = (startIndex + 6).clamp(
                                          0,
                                          _viewModel.sectors
                                              .length); // Prevents overflow

                                      return SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: _viewModel.sectors.every(
                                                      (element) =>
                                                          element['selected'] ==
                                                          false)
                                                  ? 0
                                                  : 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start, // Align items to the start
                                            children: _viewModel.sectors
                                                .sublist(startIndex, endIndex)
                                                .map((item) {
                                              // bool match = item['name'] == _selectedSector;
                                              return GestureDetector(
                                                onTap: () {
                                                  _viewModel
                                                      .toggleSectorSelection(
                                                          item);
                                                  // item['selected'] = !item['selected'];
                                                  _viewModel
                                                      .toggleIsChangesAdded(
                                                          true);
                                                },
                                                child: Container(
                                                  height: 70,
                                                  width: 100,
                                                  margin: EdgeInsets.only(
                                                      right: 12,
                                                      bottom: 8,
                                                      top: 4,
                                                      left: 0),
                                                  // padding: EdgeInsets.symmetric(
                                                  //     horizontal: 10,
                                                  //     vertical: 7),
                                                  decoration: BoxDecoration(
                                                    color: item['selected']
                                                        ? AppColors.lightBlue
                                                        : AppColors.lightGray,
                                                    boxShadow: item['selected']
                                                        ? [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 5,
                                                              spreadRadius: 2,
                                                            ),
                                                          ]
                                                        : null,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgAssetImageMd(
                                                        name: item['icon'],
                                                        fit: BoxFit.scaleDown,
                                                        colorFilter: item[
                                                                'selected']
                                                            ? ColorFilter.mode(
                                                                Colors.white,
                                                                BlendMode.srcIn)
                                                            : ColorFilter.mode(
                                                                AppColors.gray,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        item['name'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            kNineRegGrayPoppins
                                                                .copyWith(
                                                          color:
                                                              item['selected']
                                                                  ? Colors.white
                                                                  : AppColors
                                                                      .gray,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Asset Type Selection',
                        style: kEighteenMedBlackPoppins,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 14,
                      ),

                      Consumer<FilterViewModel>(
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _viewModel.assetTypes.every(
                                      (element) => element['selected'] == false)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Choose at least 1 asset type',
                                          style: kTwelveRegular050B15Poppins
                                              .copyWith(
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _viewModel.assetTypes.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    bool selected = _viewModel.assetTypes[index]
                                        ['selected'];
                                    return GestureDetector(
                                      onTap: () {
                                        _viewModel.toggleAssetSelection(index);
                                        _viewModel.toggleIsChangesAdded(true);
                                      },
                                      child: Container(
                                        height: 66,
                                        width: 100,
                                        margin: EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? AppColors.lightBlue
                                              : AppColors.lightGray,
                                          boxShadow: selected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 5,
                                                    spreadRadius: 2,
                                                  ),
                                                ]
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _viewModel.assetTypes[index]
                                                ['name'],
                                            textAlign: TextAlign.center,
                                            style: kFourteenRegGrayPoppins
                                                .copyWith(
                                              color: selected
                                                  ? Colors.white
                                                  : AppColors.gray,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Market Capitalisation',
                        style: kEighteenMedBlackPoppins,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 14,
                      ),

                      Consumer<FilterViewModel>(
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              _viewModel.capitalizationTypes.every(
                                      (item) => item['selected'] == false)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Choose at least 1 market capitalisation',
                                          style: kTwelveRegular050B15Poppins
                                              .copyWith(
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      _viewModel.capitalizationTypes.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    bool selected = _viewModel
                                        .capitalizationTypes[index]['selected'];
                                    return GestureDetector(
                                      onTap: () {
                                        _viewModel
                                            .toggleCapitalisationSelection(
                                                index);
                                        _viewModel.toggleIsChangesAdded(true);
                                      },
                                      child: Container(
                                        height: 66,
                                        width: 100,
                                        margin: EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? AppColors.lightBlue
                                              : AppColors.lightGray,
                                          boxShadow: selected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 5,
                                                    spreadRadius: 2,
                                                  ),
                                                ]
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _viewModel
                                                    .capitalizationTypes[index]
                                                ['name'],
                                            textAlign: TextAlign.center,
                                            style: kFourteenRegGrayPoppins
                                                .copyWith(
                                              color: selected
                                                  ? Colors.white
                                                  : AppColors.gray,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Consumer<FilterViewModel>(
                          builder: (context, value, child) {
                            return CustomButton(
                                buttonText: 'Apply Filters',
                                onTap: _viewModel.isChangesAdded
                                    ? () {
                                        _viewModel.toggleIsChangesAdded(false);
                                      }
                                    : null,
                                color: _viewModel.isChangesAdded
                                    ? null
                                    : AppColors.primary.withValues(alpha: 0.5),
                                borderColor: Colors.transparent);
                          },
                        ),
                      ),
                      // SizedBox(
                      //   height: height * 0.2,
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
