import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonk_it/api_repository/bottom_nav_repo.dart';
import 'package:stonk_it/services/filter_view_service.dart';
import 'package:stonk_it/storage/user_session.dart';

import '../../utils/utils.dart';

class FilterViewModel extends ChangeNotifier {
  bool _isChangesAdded = false;
  bool get isChangesAdded => _isChangesAdded;

  List<Map<String, dynamic>> _sectors = [];
  List<Map<String, dynamic>> get sectors => _sectors;
  bool _isAllSectorsSelected = false;
  bool get isAllSectorsSelected => _isAllSectorsSelected;

  String _selectedSector = '';
  String get selectedSector => _selectedSector;
  final BottomNavRepo _bottomNavRepo = BottomNavRepo();
  final List _assetTypes = [
    {'name': 'ETFs', 'selected': true},
    {'name': 'Companies', 'selected': true},
  ];
  bool _isAllAssetsSelected = true;
  bool get isAllAssetsSelected => _isAllAssetsSelected;

  List get assetTypes => _assetTypes;
  String _selectedAsset = 'Companies';
  String get selectedAsset => _selectedAsset;

  final List _capitalizationTypes = [
    {'name': 'Small Cap', 'selected': true},
    {'name': 'Mid Cap', 'selected': true},
    {'name': 'Large Cap', 'selected': true},
  ];
  List get capitalizationTypes => _capitalizationTypes;
  bool _isAllCapitalizationSelected = true;
  bool get isAllCapitalizationSelected => _isAllCapitalizationSelected;
  String _selectedCap = 'Mid Cap';
  String get selectedCap => _selectedCap;
  late UserSession _userSession;

  setFilters(BuildContext context) {
    _userSession = Provider.of<UserSession>(context, listen: false);
    _selectedSector = _userSession.selectedSector;
    _selectedAsset = _userSession.selectedAsset;
    _selectedCap = _userSession.selectedCap;
  }

  Future fetchAvailableSectors(BuildContext context) async {
    try {
      // _isFetching = true;
      List<dynamic> availableSectors =
          await _bottomNavRepo.fetchAvailableSectors();
      _sectors = availableSectors.map(
        (e) {
          // String sectorName = sectorNameMapping[e['sector']] ?? e['sector'];
          String sectorName = e['sector'];
          return {
            'name': sectorName,
            'icon': sectorIcons[sectorName] ?? '',
            'selected': true,
          };
        },
      ).toList();

      if (_sectors.isNotEmpty) {
        _isAllSectorsSelected = true;
      }
      notifyListeners();
    } catch (e) {
      Utils.errorSnackBar(context, e.toString());
    }
    // _isFetching = false;
    notifyListeners();
    debugPrint('Company Stock Quote: $sectors');
  }

  toggleAllSectorsSelection() {
    // check and toggle all sectors
    bool allSelected = _sectors.every((element) => element['selected']);

    for (var element in _sectors) {
      element['selected'] = !allSelected;
    }

    // update allSelected
    _isAllSectorsSelected = !allSelected;

    _isChangesAdded = true;
    notifyListeners();
  }

  toggleSectorSelection(dynamic sector) {
    // unselect all other sectors except the one selected
    if (_isAllSectorsSelected) {
      for (var element in _sectors) {
        if (element['name'] == sector['name']) {
          continue;
        }
        element['selected'] = false;
      }
    } else {
      // toggle the selected sector
      for (var element in _sectors) {
        if (element['name'] == sector['name']) {
          continue;
        }
        element['selected'] = false;
      }
      Map sectorToToggle = _sectors.firstWhere(
        (element) => element['name'] == sector['name'],
      );
      sectorToToggle['selected'] = !sectorToToggle['selected'];
    }
    _isAllSectorsSelected =
        _sectors.every((element) => element['selected'] == true);

    _isChangesAdded = true;
    notifyListeners();
  }

  toggleAllAssetsSelection() {
    // check and toggle all assets
    bool allSelected = _assetTypes.every((element) => element['selected']);

    for (var element in _assetTypes) {
      element['selected'] = !allSelected;
    }

    // update allSelected
    _isAllAssetsSelected = !allSelected;

    _isChangesAdded = true;
    notifyListeners();
  }

  toggleAssetSelection(Map asset) {
    // unselect all other assets except the one selected
    for (var element in _assetTypes) {
      if (element['name'] == asset['name']) {
        continue;
      }
      element['selected'] = false;
    }

    // toggle the selected asset
    Map assetToToggle = _assetTypes.firstWhere(
      (element) => element['name'] == asset['name'],
    );
    assetToToggle['selected'] = !assetToToggle['selected'];

    _isAllAssetsSelected =
        _assetTypes.every((element) => element['selected'] == false);

    _isChangesAdded = true;
    notifyListeners();
  }

  toggleAllCapitalisationSelection() {
    // check and toggle all capitalization
    bool allSelected =
        _capitalizationTypes.every((element) => element['selected']);

    for (var element in _capitalizationTypes) {
      element['selected'] = !allSelected;
    }

    // update allSelected
    _isAllCapitalizationSelected = !allSelected;

    _isChangesAdded = true;
    notifyListeners();
  }

  toggleCapitalisationSelection(Map cap) {
    // unselect all other caps except the one selected
    for (var element in _capitalizationTypes) {
      if (element['name'] == cap['name']) {
        continue;
      }
      element['selected'] = false;
    }

    // toggle the selected cap
    Map capToToggle = _capitalizationTypes.firstWhere(
      (element) => element['name'] == cap['name'],
    );
    capToToggle['selected'] = !capToToggle['selected'];

    _isAllCapitalizationSelected =
        _capitalizationTypes.every((element) => element['selected'] == false);

    _isChangesAdded = true;
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
