import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelloreassignment/view/movie_card.dart';
import 'package:intelloreassignment/view/movie_detail_screen.dart';
import 'package:intelloreassignment/view/movie_shimmer_card.dart';
import 'package:intelloreassignment/view/movie_shimmer_card.dart';
import 'package:intelloreassignment/view/search_movie_screen.dart';

import 'package:shimmer/shimmer.dart';

import 'Bloc/home_bloc.dart';
import 'models/movie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intellore Assignment',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    _homeBloc.getNowPlayingMovies("1");
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
                  Icon(
                    Icons.menu,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieSearchPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Now Playing',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Expanded(
                child: StreamBuilder<List<Movie>>(
                    stream: _homeBloc.nowPlayingMoviesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        List<Movie> popularMovies = snapshot.data;
                        return NotificationListener<ScrollNotification>(
                          // ignore: missing_return
                          onNotification: (ScrollNotification scrollInfo) {
                            if (_homeBloc.isLoadMore() &&
                                !_homeBloc.isLoadingBS.value &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              _homeBloc.getNowPlayingMovies(
                                  (_homeBloc.currentPage + 1).toString());
                              _homeBloc.addIsLoading(true);
                            }
                          },
                          child:

                              GridView.builder(
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
                  stream: _homeBloc.isLoadingStream,
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
    _homeBloc.dispose();
    super.dispose();
  }
}
