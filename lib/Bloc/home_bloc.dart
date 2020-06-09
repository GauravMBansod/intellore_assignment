import 'dart:convert';


import 'package:http/http.dart';
import 'package:intelloreassignment/models/genres.dart';
import 'package:intelloreassignment/models/movie.dart';
import 'package:intelloreassignment/repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  MovieRepository _movieRepository;
  int totalPages = 1,
  currentPage = 1;

  HomeBloc() {
    _movieRepository = MovieRepository();
  }


  final nowPlayingMoviesBS = BehaviorSubject<List<Movie>>.seeded(new List<Movie>());

  Stream<List<Movie>> get nowPlayingMoviesStream => nowPlayingMoviesBS.stream;

  Function(List<Movie>) get addNowPlayingMovies => nowPlayingMoviesBS.sink.add;

  final searchMoviesBS = BehaviorSubject<List<Movie>>.seeded(new List<Movie>());

  Stream<List<Movie>> get searchMoviesStream => searchMoviesBS.stream;

  Function(List<Movie>) get addSearchMovies => searchMoviesBS.sink.add;



  final isLoadingBS = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoadingStream => isLoadingBS.stream;

  Function(bool) get addIsLoading => isLoadingBS.sink.add;

  void getNowPlayingMovies(String page) async {
    Response response = await _movieRepository.getNowPlayingMovies(page);
    if (response.statusCode == 200) {
      Map nowPlayingMoviesMap = jsonDecode(response.body);
      currentPage = nowPlayingMoviesMap['page'] ??= 1;
      totalPages = nowPlayingMoviesMap['total_pages'] ??= 1;
      if (nowPlayingMoviesMap['results'] != null) {
        List<Movie> popularMovies = nowPlayingMoviesBS.value;
        nowPlayingMoviesMap['results'].forEach((v) {
          Movie nowPlayingMovie = new Movie.fromJson(v);
          popularMovies.add(nowPlayingMovie);
        });
        addNowPlayingMovies(popularMovies);
        addIsLoading(false);
      }
    }
  }

  void searchMovies({String query,String page}) async {
    Response response = await _movieRepository.searchMovies(query: query,page: page);
    if (response.statusCode == 200) {
      Map searchedMoviesMap = jsonDecode(response.body);
      currentPage = searchedMoviesMap['page'] ??= 1;
      totalPages = searchedMoviesMap['total_pages'] ??= 1;
      if (searchedMoviesMap['results'] != null) {
        List<Movie> searchedMovies = searchMoviesBS.value;
        searchedMoviesMap['results'].forEach((v) {
          Movie nowPlayingMovie = new Movie.fromJson(v);
          searchedMovies.add(nowPlayingMovie);
        });
        addSearchMovies(searchedMovies);
        addIsLoading(false);
      }
    }
  }

  bool isLoadMore(){
    return currentPage <= totalPages;
  }

  /*close beahviour subjects*/
  void dispose() {
    nowPlayingMoviesBS.close();
    isLoadingBS.close();
    searchMoviesBS.close();
  }
}
