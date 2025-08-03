// repository/movie_repository.dart
import 'package:dio/dio.dart';
import 'package:flutflix/api/tmdb_api_service.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movie.dart';

class MovieRepository {
  final TMDBApiService _apiService;

  MovieRepository()
      : _apiService = TMDBApiService(
          Dio(BaseOptions(contentType: "application/json")),
        );

  Future<List<Movie>> getTrendingMovies() async {
    final response = await _apiService.getTrendingMovies(Constants.apiKey);
    return response.data.results;
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await _apiService.getNowPlayingMovies(Constants.apiKey);
    return response.data.results;
  }
}
