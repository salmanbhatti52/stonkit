import 'package:stonk_it/data/network/base_api_services.dart';
import 'package:stonk_it/data/network/network_api_services.dart';
import 'package:stonk_it/resources/app_urls.dart';

class SettingsRepo {
  final BaseApiServices _baseApiServices = NetworkApiServices();

  Future changePassword(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.changePassword, data: data);
  }

  Future deleteAccount(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.deleteAccount, data: data);
  }
}
