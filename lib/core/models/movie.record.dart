import 'single_movie.dart';
class MovieRecord {
  final int id;
  final String title;
  final String? posterPath;
  final int? releaseYear;
  final double voteAverage;

  const MovieRecord({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseYear,
    required this.voteAverage,
  });

  factory MovieRecord.fromSingleMovie(SingleMovie movie) => MovieRecord(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        releaseYear: movie.releaseDate?.year,
        voteAverage: movie.voteAverage,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'release_year': releaseYear,
        'vote_average': voteAverage,
      };

  factory MovieRecord.fromMap(Map<String, dynamic> map) => MovieRecord(
        id: map['id'] as int,
        title: map['title'] as String,
        posterPath: map['poster_path'] as String?,
        releaseYear: map['release_year'] as int?,
        voteAverage: (map['vote_average'] as num).toDouble(),
      );
}