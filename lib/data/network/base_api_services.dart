abstract class BaseApiServices{
  Future fetchGetApiResponse({required String url});
  Future fetchPostApiResponse({required String url, required dynamic data});
}