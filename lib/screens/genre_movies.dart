import 'package:flutter/material.dart';
import 'package:flutter_flixandchill/api/endpoints.dart';
import 'package:flutter_flixandchill/model_class/genres.dart';
import 'package:flutter_flixandchill/screens/widgets.dart';

class GenreMovies extends StatelessWidget {
  final ThemeData themeData;
  final Genres genre;
  final List<Genres> genres;

  GenreMovies(
      {required this.themeData, required this.genre, required this.genres});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.primaryColor,
        title: Text(
          genre.name!,
          style: themeData.textTheme.headline5,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeData.accentColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ParticularGenreMovies(
        themeData: themeData,
        api: Endpoints.getMoviesForGenre(genre.id!, 1),
        genres: genres,
      ),
    );
  }
}
