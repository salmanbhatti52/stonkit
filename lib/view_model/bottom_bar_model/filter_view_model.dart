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
  String _selectedSector = '';
  String get selectedSector => _selectedSector;
  final BottomNavRepo _bottomNavRepo = BottomNavRepo();
  final List _assetTypes = [
    {'name': 'ETFs'},
    {'name': 'Companies'},
  ];

  List get assetTypes => _assetTypes;
  String _selectedAsset = 'Companies';
  String get selectedAsset => _selectedAsset;

  final List _capitalizationTypes = [
    {'name': 'Small Cap'},
    {'name': 'Mid Cap'},
    {'name': 'Large Cap'},
  ];
  List get capitalizationTypes => _capitalizationTypes;
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
            // 'selected': false,
          };
        },
      ).toList();
      // Set the first sector as selected by default
      if (_sectors.isNotEmpty && _selectedSector.isEmpty) {
        _selectedSector = _sectors[0]['name'];
        // _sectors[0]['selected'] = true;
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
    bool allSelected = _sectors.every((element) => element['selected']);

    for (var element in _sectors) {
      element['selected'] = !allSelected;
    }
    _isChangesAdded = true;
    notifyListeners();
  }

  toggleSectorSelection(dynamic sector) {
    // sector['selected'] = !sector['selected'];
    if (_selectedSector != sector['name']) {
      _selectedSector = sector['name'];
    } else {
      _selectedSector = '';
    }
    _isChangesAdded = true;
    notifyListeners();
  }

  toggleAssetSelection(Map asset) {
    // _assetTypes[index]['selected'] = !_assetTypes[index]['selected'];
    if (_selectedAsset != asset['name']) {
      _isChangesAdded = true;
    }
    _selectedAsset = asset['name'];
    notifyListeners();
  }

  toggleCapitalisationSelection(Map cap) {
    // _capitalizationTypes[index]['selected'] =
    //     !_capitalizationTypes[index]['selected'];
    if (_selectedCap != cap['name']) {
      _isChangesAdded = true;
    }
    _selectedCap = cap['name'];
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
