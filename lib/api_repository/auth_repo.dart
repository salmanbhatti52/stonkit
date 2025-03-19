import 'package:stonk_it/data/network/base_api_services.dart';
import 'package:stonk_it/data/network/network_api_services.dart';
import 'package:stonk_it/resources/app_urls.dart';

class AuthRepo {
  final BaseApiServices _baseApiServices = NetworkApiServices();

  Future signup(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.signupWithApp, data: data);
  }

  Future login(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.loginWithApp, data: data);
  }

  Future loginAsGuest() async {
    return await _baseApiServices.fetchGetApiResponse(
        url: AppUrls.loginAsGuest);
  }

  Future getResetPasswordOtp(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.resetPasswordOtp, data: data);
  }

  Future setNewPassword(dynamic data) async {
    return await _baseApiServices.fetchPostApiResponse(
        url: AppUrls.setNewPassword, data: data);
  }
}
