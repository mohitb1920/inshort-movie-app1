import 'package:isar/isar.dart';

part 'movie.g.dart';

@collection
class Movie {
  Id id = Isar.autoIncrement; // required for isar

  late String movieId;
  late String title;
  late String backDropPath;
  late String originalTitle;
  late String overview;
  late String posterPath;
  late String releaseDate;
  late double voteAverage;

  Movie();

  Movie.full({
    required this.id,
    required this.movieId,
    required this.title,
    this.backDropPath = '',
    this.originalTitle = '',
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    movieId = json["id"].toString();
    title = json["title"];
    backDropPath = json["backdrop_path"] ?? '';
    originalTitle = json["original_title"];
    overview = json["overview"];
    posterPath = json["poster_path"] ?? '';
    releaseDate = json["release_date"];
    voteAverage = (json["vote_average"] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "backdrop_path": backDropPath,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "vote_average": voteAverage,
      };
}
