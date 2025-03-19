import 'package:stonk_it/data/network/base_api_services.dart';
import 'package:stonk_it/data/network/network_api_services.dart';

import '../resources/app_urls.dart';

class HomeRepo {
  final BaseApiServices _baseApiServices = NetworkApiServices();

  Future fetchTickersFromStockScreener(String params) async {
    return await _baseApiServices.fetchGetApiResponse(
        url: '${AppUrls.stockScreener}$params');
  }

  Future fetchCompanyProfile(String param) async {
    return await _baseApiServices.fetchGetApiResponse(
        url: '${AppUrls.companyProfile}$param');
  }

  Future fetchCompanyStockPrice(String param) async {
    return await _baseApiServices.fetchGetApiResponse(
        url: '${AppUrls.companyStockPrice}$param');
  }
}
