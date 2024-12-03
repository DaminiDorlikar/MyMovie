import 'package:movie/Model/movie_model.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class Favorite extends MovieState {}

class MovieLoaded extends MovieState {
  final List<MovieModel> movies;
  MovieLoaded(this.movies);
}

class MovieFiltered extends MovieState {
  final List<MovieModel> filteredMovies;
  MovieFiltered(this.filteredMovies);
}

class MovieError extends MovieState {
  final String error;
  MovieError(this.error);
}

class FavoritesUpdated extends MovieState {
  final List<MovieModel> favoriteMovies;
  FavoritesUpdated(this.favoriteMovies);
}
