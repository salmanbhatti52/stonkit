import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future fetchGetApiResponse({required String url}) async {
    try {
      http.Response response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      return checkResponse(response);
    } on SocketException {
      throw FetchDataException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  @override
  Future fetchPostApiResponse({required String url, data}) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      return checkResponse(response);
    } on SocketException {
      throw FetchDataException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  dynamic checkResponse(http.Response response) {
    try {
      var decodedResponse = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          return decodedResponse;
        case 400:
          throw BadRequestException();
        case 405:
          throw InvalidMethodException();
        case 408:
          throw RequestTimeoutException();
        case 429:
          throw TooManyRequestsException();
        case 500:
          throw InternalServerErrorException();
        case 502:
          throw BadGatewayException();
        case 503:
          throw ServiceUnavailableException();
        case 504:
          throw GatewayTimeoutException();
        default:
          throw FetchDataException();
      }
    } catch (e) {
      throw FetchDataException(response.reasonPhrase);
      // throw FetchDataException('Server error. Please try again later.');
    }
  }
}
