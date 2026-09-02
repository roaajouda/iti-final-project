import 'package:flutter_application_2/core/models/single_movie.dart';
import 'package:hive/hive.dart';

part 'movie_record.g.dart';

@HiveType(typeId: 0)
class MovieRecord extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? posterPath;

  @HiveField(3)
  final int? releaseYear;

  @HiveField(4)
  final double voteAverage;

  MovieRecord({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseYear,
    required this.voteAverage,
  });

  factory MovieRecord.fromSingleMovie(SingleMovie movie) {
    return MovieRecord(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      releaseYear: movie.releaseDate?.year,
      voteAverage: movie.voteAverage,
    );
  }
}