import 'package:flutter/material.dart';

import '../../resources/assets.dart';

class FilterViewModel extends ChangeNotifier {
  bool _isChangesAdded = false;
  bool get isChangesAdded => _isChangesAdded;

  List<Map<String, dynamic>> _sectors = [
    {
      'name': 'Technology',
      'icon': Assets.tech,
      'selected': true,
    },
    {
      'name': 'Financials',
      'icon': Assets.finance,
      'selected': true,
    },
    {
      'name': 'Communication \n Services',
      'icon': Assets.chat,
      'selected': true,
    },
    {
      'name': 'Industrials',
      'icon': Assets.factory,
      'selected': true,
    },
    {
      'name': 'Consumer \n Discretionary',
      'icon': Assets.consumerDisc,
      'selected': true,
    },
    {
      'name': 'Utilities',
      'icon': Assets.electric,
      'selected': true,
    },
    {
      'name': 'Materials',
      'icon': Assets.material,
      'selected': true,
    },
    {
      'name': 'Consumer \n Staples',
      'icon': Assets.consumerStaple,
      'selected': true,
    },
    {
      'name': 'Real Estate',
      'icon': Assets.realEstate,
      'selected': true,
    },
    {
      'name': 'Health Care',
      'icon': Assets.healthCare,
      'selected': true,
    },
    {
      'name': 'Energy',
      'icon': Assets.energy,
      'selected': true,
    },
  ];
  List<Map<String, dynamic>> get sectors => _sectors;

  List _assetTypes = [
    {'name': 'ETFs', 'selected': true},
    {'name': 'Companies', 'selected': false},
  ];
  List get assetTypes => _assetTypes;

  List _capitalizationTypes = [
    {'name': 'Small Cap', 'selected': true},
    {'name': 'Mid Cap ', 'selected': false},
    {'name': 'Large Cap', 'selected': false},
  ];
  List get capitalizationTypes => _capitalizationTypes;

  toggleAllSectorsSelection() {
    bool allSelected = _sectors.every((element) => element['selected']);

    for (var element in _sectors) {
      element['selected'] = !allSelected;
    }
    _isChangesAdded = true;
    notifyListeners();
  }

  toggleSectorSelection(dynamic sector) {
    sector['selected'] = !sector['selected'];
    notifyListeners();
  }

  toggleAssetSelection(int index) {
    _assetTypes[index]['selected'] = !_assetTypes[index]['selected'];
    notifyListeners();
  }

  toggleCapitalisationSelection(int index) {
    _capitalizationTypes[index]['selected'] =
        !_capitalizationTypes[index]['selected'];
    notifyListeners();
  }

  toggleIsChangesAdded(bool value) {
    _isChangesAdded = value;
    notifyListeners();
  }

  // reset() {
  //   _assetTypes = [
  //     {'name': 'ETFs', 'selected': true},
  //     {'name': 'Companies', 'selected': false},
  //   ];
  //   _capitalizationTypes = [
  //     {'name': 'Small Cap', 'selected': true},
  //     {'name': 'Mid Cap ', 'selected': false},
  //     {'name': 'Large Cap', 'selected': false},
  //   ];
  //   _sectors = [
  //     {
  //       'name': 'Technology',
  //       'icon': Assets.tech,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Financials',
  //       'icon': Assets.finance,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Communication \n Services',
  //       'icon': Assets.chat,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Industrials',
  //       'icon': Assets.factory,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Consumer \n Discretionary',
  //       'icon': Assets.consumerDisc,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Utilities',
  //       'icon': Assets.electric,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Materials',
  //       'icon': Assets.material,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Consumer \n Staples',
  //       'icon': Assets.consumerStaple,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Real Estate',
  //       'icon': Assets.realEstate,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Health Care',
  //       'icon': Assets.healthCare,
  //       'selected': true,
  //     },
  //     {
  //       'name': 'Energy',
  //       'icon': Assets.energy,
  //       'selected': true,
  //     },
  //   ];
  //   _isChangesAdded = false;
  //   notifyListeners();
  // }
}
