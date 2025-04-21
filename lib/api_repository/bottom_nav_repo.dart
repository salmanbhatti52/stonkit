import 'package:stonk_it/data/network/base_api_services.dart';
import 'package:stonk_it/data/network/network_api_services.dart';

import '../resources/app_urls.dart';

class BottomNavRepo {
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

  Future fetchHistoricalStockPrice(String param) async {
    return await _baseApiServices.fetchGetApiResponse(
        url: '${AppUrls.historicalStockPrice}$param');
  }

  Future fetchHistoricalSectorPerformance(String param) async {
    return await _baseApiServices.fetchGetApiResponse(
        url: '${AppUrls.historicalSectorPerformance}$param');
  }

  Future fetchCompanyDividends(String param) async {
    return await _baseApiServices.fetchGetApiResponse(
        url: '${AppUrls.companyDividends}$param');
  }

  Future likeTicker(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.likeTicker, data: data);
  }

  Future dislikeTicker(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.dislikeTicker, data: data);
  }

  Future getLikedTickers(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.getLikedTickers, data: data);
  }

  Future getDislikedTickers(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.getDislikedTickers, data: data);
  }
}
