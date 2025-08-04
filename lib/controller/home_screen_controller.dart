import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutflix/models/bookmarked_movie.dart';
import 'package:flutflix/screens/details_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_links/uni_links.dart';

import '../api/tmdb_api_service.dart';
import '../constants.dart';
import '../models/movie.dart';

class HomeScreenController extends GetxController {
  final TMDBApiService _apiService = TMDBApiService(Dio());
  late final Isar _isar;

  RxList<Movie> trendingMovies = RxList<Movie>();
  RxList<Movie> nowPlayingMovies = RxList<Movie>();
  RxList<Movie> bookmarkedMovies = RxList<Movie>();
  RxList<Movie> searchMovieList = RxList<Movie>();
  TextEditingController searchTextController = TextEditingController();
  Timer? debounce;

  @override
  void onInit() async {
    super.onInit();
    await _initDb().then((_) {
      fetchTrendingMovies();
      fetchNowPlayingMovies();
    });
    await loadBookmarkedMovies();
    _initDeepLinks();
  }

  Future<void> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [MovieSchema, BookmarkedMovieSchema],
      directory: dir.path,
    );
  }

  Future<void> fetchTrendingMovies() async {
    try {
      final response = await _apiService.getTrendingMovies(Constants.apiKey);
      final movies = response.data.results;

      await _isar.writeTxn(() async {
        await _isar.movies.clear(); // Optional: clear old trending data
        await _isar.movies.putAll(movies);
      });

      trendingMovies.assignAll(movies);
    } catch (e, stackTrace) {
      print('Error fetching trending movies: $e');
      print(stackTrace);

      final localData = await _isar.movies.where().findAll();
      trendingMovies.assignAll(localData);
    }
  }

  Future<void> fetchNowPlayingMovies() async {
    try {
      final response = await _apiService.getNowPlayingMovies(Constants.apiKey);
      final movies = response.data.results;

      // Store in Isar database
      await _isar.writeTxn(() async {
        await _isar.movies.putAll(movies);
      });

      // Update RxList
      nowPlayingMovies.assignAll(movies);
    } catch (e, stackTrace) {
      print('Error fetching now playing movies: $e');
      print(stackTrace);

      // Fallback to local cache
      final localData = await _isar.movies.where().findAll();
      nowPlayingMovies.assignAll(localData);
    }
  }

  Future<void> loadBookmarkedMovies() async {
    final localBookmarks = await _isar.bookmarkedMovies.where().findAll();
    bookmarkedMovies.value = localBookmarks.map((b) => b.toMovie()).toList();
  }

  Future<void> toggleBookmark(Movie movie) async {
    final isBookmarked =
        bookmarkedMovies.any((m) => m.movieId == movie.movieId);
    if (isBookmarked) {
      // Remove from DB
      final local = await _isar.bookmarkedMovies
          .filter()
          .movieIdEqualTo(movie.movieId)
          .findFirst();
      if (local != null) {
        await _isar.writeTxn(() => _isar.bookmarkedMovies.delete(local.id));
      }
      bookmarkedMovies.removeWhere((m) => m.movieId == movie.movieId);
    } else {
      // Add to DB
      final bookmarked = BookmarkedMovie.fromMovie(movie);
      await _isar.writeTxn(() => _isar.bookmarkedMovies.put(bookmarked));
      bookmarkedMovies.add(movie);
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      searchMovieList.clear();
      return;
    }

    try {
      final response = await _apiService.searchMovies(Constants.apiKey, query);
      final movies = response.data.results;
      searchMovieList.assignAll(movies);
    } catch (e) {
      print("Error during search: $e");
      searchMovieList.clear();
    }
  }

  void _initDeepLinks() async {
    try {
      final initialLink = await getInitialLink();
      _handleDeepLink(initialLink);

      linkStream.listen((String? link) {
        _handleDeepLink(link);
      });
    } on PlatformException {
      // Handle error
    }
  }

  void _handleDeepLink(String? link) async {
    if (link == null) return;

    final uri = Uri.parse(link);
    if (uri.scheme == 'https' && uri.host == 'flutflix.com') {
      final movieId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      if (movieId == null) return;

      final allMovies = [
        ...trendingMovies,
        ...nowPlayingMovies,
        ...bookmarkedMovies,
      ];

      final matchedMovie = allMovies
          .firstWhereOrNull((movie) => movie.movieId.toString() == movieId);

      if (matchedMovie != null) {
        Get.to(() => DetailsScreen(movie: matchedMovie));
      } else {
        final localMovie =
            await _isar.movies.filter().movieIdEqualTo(movieId).findFirst();
        if (localMovie != null) {
          Get.to(() => DetailsScreen(movie: localMovie));
        } else {
          Get.snackbar("Movie Not Found", "Couldn't open the shared movie.");
        }
      }
    }
  }
}
