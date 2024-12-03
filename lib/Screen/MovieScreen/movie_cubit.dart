import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movie/Api_auth/api_integration.dart';
import 'package:movie/Model/movie_model.dart';
import 'package:movie/Screen/MovieScreen/movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final TextEditingController searchController = TextEditingController();
  final Box<int> _favoritesBox = Hive.box<int>('favorites');
  final Box<MovieModel> _moviesBox = Hive.box<MovieModel>('movies');
  final MovieRepository movieRepository;
  final Connectivity _connectivity = Connectivity();

  List<MovieModel> _allMovies = [];
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  MovieCubit(this.movieRepository) : super(MovieInitial()) {
    checkInitialConnectivity();
  }

  /// Initial connectivity check
  Future<void> checkInitialConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.first == ConnectivityResult.mobile ||
        connectivityResult.first == ConnectivityResult.wifi) {
      syncWithBackend();
    } else if (connectivityResult.first == ConnectivityResult.none) {
      loadCachedMovies();
    }
  }

  /// Load cached movies
  void loadCachedMovies() {
    if (_moviesBox.isNotEmpty) {
      _allMovies = _moviesBox.values.toList();
      emit(MovieLoaded(_allMovies));
    }
  }

  /// Fetch movies from the API
  Future<void> fetchMoviesN() async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.fetchMovies();
      _allMovies = movies;
      await _moviesBox.clear();
      for (var movie in movies) {
        _moviesBox.put(movie.id, movie);
      }
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> syncWithBackend() async {
    try {
      fetchMoviesN();
    } catch (e) {
      emit(MovieError('Failed to sync: $e'));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  /// Search movies locally
  void searchMovies(String query) {
    if (query.isEmpty) {
      emit(MovieLoaded(_allMovies));
    } else {
      final filteredMovies = _allMovies
          .where((movie) =>
              movie.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(MovieFiltered(filteredMovies));
    }
  }

  Future<void> toggleFavorite(MovieModel movie) async {
    if (_favoritesBox.containsKey(movie.id)) {
      _favoritesBox.delete(movie.id);
    } else {
      _favoritesBox.put(movie.id, movie.id ?? 0);
    }
    emit(MovieLoaded(_allMovies));
  }

  List<MovieModel> getFavoriteMovies() {
    final favoriteIds = _favoritesBox.keys.cast<int>().toSet();
    return _allMovies.where((movie) => favoriteIds.contains(movie.id)).toList();
  }

  bool isFavorite(MovieModel movie) {
    return _favoritesBox.containsKey(movie.id);
  }
}
