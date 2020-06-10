import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelloreassignment/Bloc/home_bloc.dart';
import 'package:intelloreassignment/models/movie.dart';
import 'package:intelloreassignment/view/movie_card.dart';
import 'package:intelloreassignment/view/movie_detail_screen.dart';
import 'package:intelloreassignment/view/movie_shimmer_card.dart';
import 'package:shimmer/shimmer.dart';

class MovieSearchPage extends StatefulWidget {
  MovieSearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  HomeBloc _searchBloc;
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    _searchBloc = HomeBloc();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  searchMovie(resetSearch: true);
                },
                decoration: InputDecoration(
                  hintText: 'Movie Name',
                  // Here is key idea
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      Icons.search,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      searchMovie(resetSearch: true);
                    },
                  ),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Expanded(
                child: StreamBuilder<List<Movie>>(
                    stream: _searchBloc.searchMoviesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        List<Movie> popularMovies = snapshot.data;
                        return NotificationListener<ScrollNotification>(
                          // ignore: missing_return
                          onNotification: (ScrollNotification scrollInfo) {
                            if (_searchBloc.isLoadMore() &&
                                !_searchBloc.isLoadingBS.value &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              searchMovie(
                                  page:
                                      (_searchBloc.currentPage + 1).toString());
                              _searchBloc.addIsLoading(true);
                            }
                          },
                          child: GridView.builder(
                            itemCount: popularMovies.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              Movie popularMovie = popularMovies[index];
                              return MovieCard(
                                  width: width, movie: popularMovie);
                            },
                          ),
                        );
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: GridView.builder(
                            itemCount: 8,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return NowPlayingMovieShimmerCard(width);
                            },
                          ),
                        );
                      }
                    }),
              ),
              StreamBuilder<bool>(
                  stream: _searchBloc.isLoadingStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    return Container(
                      height: snapshot.data ? 50.0 : 0,
                      color: Colors.transparent,
                      child: Center(
                        child: new CircularProgressIndicator(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  void searchMovie({String page = "1", bool resetSearch = false}) {
    _searchBloc.totalPages = 1;
    _searchBloc.currentPage = 1;
    if (resetSearch) {
      _searchBloc.addSearchMovies(new List<Movie>());
    }
    _searchBloc.searchMovies(query: searchController.text, page: page);
  }
}
