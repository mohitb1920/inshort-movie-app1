import 'package:flutflix/models/movie_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'tmdb_api_service.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TMDBApiService {
  factory TMDBApiService(Dio dio, {String baseUrl}) = _TMDBApiService;

  @GET("trending/movie/day")
  Future<HttpResponse<MovieResponse>> getTrendingMovies(
    @Query("api_key") String apiKey,
  );

  @GET("movie/now_playing")
  Future<HttpResponse<MovieResponse>> getNowPlayingMovies(
    @Query("api_key") String apiKey,
  );

  @GET("search/movie")
  Future<HttpResponse<MovieResponse>> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );
}
