import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/Screen/MovieScreen/movie_cubit.dart';
import 'package:movie/Screen/MovieScreen/movie_state.dart';
import 'package:movie/Screen/favratorscreen_view.dart';
import 'package:movie/constant/constant_widget.dart';
import '../detailsscreen_view.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyMovies',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<MovieCubit>(),
                    child: const FavoriteListScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MovieCubit>().checkInitialConnectivity();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: context.read<MovieCubit>().searchController,
                decoration: InputDecoration(
                  hintText: "Search Movies",
                  contentPadding: const EdgeInsets.all(6),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                style: const TextStyle(fontSize: 15),
                onChanged: (query) {
                  context.read<MovieCubit>().searchMovies(query);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Movie List
              Expanded(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return const ShimmerLoader();
                    } else if (state is MovieLoaded || state is MovieFiltered) {
                      final movies = (state is MovieLoaded)
                          ? state.movies
                          : (state as MovieFiltered).filteredMovies;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          final isFavorite =
                              context.read<MovieCubit>().isFavorite(movie);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MovieDetailsScreen(movie: movie),
                                ),
                              );
                            },
                            child: MovieCard(
                              isFavorite: isFavorite,
                              title: movie.title ?? "",
                              description: 'ImdbId',
                              imdbId: movie.imdbId ?? "",
                              imageUrl: movie.posterURL ?? "",
                              movie: movie,
                            ),
                          );
                        },
                      );
                    } else if (state is MovieError) {
                      return const Center(
                          child: Text(
                        'Error: Something Went Wrong',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ));
                    }
                    return const Center(
                        child: Text(
                      'No movies available.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
