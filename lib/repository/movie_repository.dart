import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class MovieRepository {
  Future<Response> searchMovies({String query,String page}) async {
    Map<String, String> queryParameters = {
      "api_key": "ba28060040dc2663465093392b1b1354",
      "language": "en-US",
      "page": page,
      "query": query,
    };

    var uri =
        Uri.https('api.themoviedb.org', '/3/search/movie', queryParameters);
    Response response = await http.get(uri);
    return response;
  }

  Future<Response> getNowPlayingMovies(String page) async {
    Map<String, String> queryParameters = {
      "api_key": "ba28060040dc2663465093392b1b1354",
      "language": "en-US",
      "page": page,
    };

    var uri =
    Uri.https('api.themoviedb.org', '/3/movie/now_playing', queryParameters);
    Response response = await http.get(uri);
    return response;
  }
}
