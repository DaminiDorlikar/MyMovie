import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/Model/movie_model.dart';

class AppConstants {
  static const baseUrl = "https://api.sampleapis.com/movies/animation/";
}

class MovieRepository {
  Future<List<MovieModel>> fetchMovies() async {
    String url = AppConstants.baseUrl;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
