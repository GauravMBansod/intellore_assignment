import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelloreassignment/models/movie.dart';


class MovieDetailScreen extends StatefulWidget {
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie movie;
  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          movieCroppedPoster(posterPath: movie.posterPath ?? ''),
          SafeArea(
            child: Container(
              color: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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

                        Icon(
                          Icons.favorite_border,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 270.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 36.0, left: 24.0),
                          child: Icon(
                            Icons.add,
                            size: 24.0,
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.play_arrow,
                            size: 36.0,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 36.0, right: 24.0),
                          child: Icon(
                            Icons.share,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[

                          ratingStarBar(rating: movie.voteAverage.floor()),
                          tagDetail(
                              tag: 'Year',
                              detail: movie.releaseDate.split('-')[0]),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie.overview,
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget movieCroppedPoster({@required String posterPath}) {
    return SizedBox(
      width: double.infinity,
      height: 400.0,
      child: ClipPath(
        clipper: BottonRoundClipper(),
        child: Image.network(
          'https://image.tmdb.org/t/p/w185${movie.posterPath}',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget ratingStarBar({int rating = 8}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ratingStar(index: 1, rating: rating),
        ratingStar(index: 2, rating: rating),
        ratingStar(index: 3, rating: rating),
        ratingStar(index: 4, rating: rating),
        ratingStar(index: 5, rating: rating),
      ],
    );
  }

  Widget ratingStar({@required index, int rating}) {
    return Icon(
      // Based on passwordVisible state choose the icon
      Icons.star,
      color: index <= (rating / 2) ? Colors.red.shade700 : Colors.black,
    );
  }

  Widget tagDetail({@required String tag, @required String detail}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            tag,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
          Text(
            detail,
            style: Theme.of(context).textTheme.body2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class BottonRoundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottonRoundClipper oldClipper) => false;
}
