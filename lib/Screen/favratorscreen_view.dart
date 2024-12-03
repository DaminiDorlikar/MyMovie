import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/Screen/MovieScreen/movie_cubit.dart';
import 'package:movie/Screen/MovieScreen/movie_state.dart';
import 'package:movie/constant/constant_widget.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Favorite Movies',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          final favoriteMovies = context.read<MovieCubit>().getFavoriteMovies();
          if (favoriteMovies.isEmpty) {
            return const Center(
              child: Text(
                'No favorite movies yet.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 0.7,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return FavoriteCard(
                  title: movie.title ?? "",
                  description: 'ImdbId',
                  imdbId: movie.imdbId ?? "",
                  imageUrl: movie.posterURL ?? "",
                  movie: movie,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
