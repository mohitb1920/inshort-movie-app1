import 'package:flutflix/models/movie.dart';
import 'package:isar/isar.dart';

part 'bookmarked_movie.g.dart';

@collection
class BookmarkedMovie {
  Id id; // Isar requires an `id` field

  String movieId;
  String title;
  String posterPath;
  String overview;
  String releaseDate;
  double voteAverage;

  BookmarkedMovie({
    this.id = Isar.autoIncrement,
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
  });

  // Helper to convert from Movie model
  factory BookmarkedMovie.fromMovie(Movie movie) {
    return BookmarkedMovie(
      movieId: movie.movieId,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
    );
  }

  // Convert back to Movie if needed
  Movie toMovie() => Movie.full(
        id: id,
        movieId: movieId,
        title: title,
        posterPath: posterPath,
        overview: overview,
        releaseDate: releaseDate,
        voteAverage: voteAverage,
      );
}
