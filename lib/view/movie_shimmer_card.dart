import 'package:flutter/material.dart';

class NowPlayingMovieShimmerCard extends StatelessWidget {
  final double width;

  NowPlayingMovieShimmerCard(this.width);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 300,
        width: width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
