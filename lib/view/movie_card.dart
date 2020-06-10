import 'package:flutter/material.dart';
import 'package:intelloreassignment/models/movie.dart';
import 'package:intelloreassignment/view/movie_detail_screen.dart';

// ignore: must_be_immutable
class MovieCard extends StatelessWidget {
  Movie movie;
  double width;

  MovieCard({this.movie, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(),
            // Pass the arguments as part of the RouteSettings. The
            // DetailScreen reads the arguments from these settings.
            settings: RouteSettings(
              arguments: movie,
            ),
          ),
        );
      },
      child: SizedBox(
        width: width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 12.0,
              margin: EdgeInsets.all(4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.hardEdge,
              color: Colors.redAccent,
              child: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w185${movie.posterPath}',
                      height: 150,
                      width: width * 0.75,
                      fit: BoxFit.fill,
                    )
                  : SizedBox(
                      height: 150,
                      width: width * 0.75,
                    ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  movie.title,
                  style: TextStyle(
                    decorationStyle: TextDecorationStyle.wavy,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
