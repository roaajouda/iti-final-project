import 'package:flutter_application_2/core/models/movie_record.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/models/single_movie.dart';
import '../../../core/models/movies.dart';

class MovieDetailsController {
  final int movieId;

  final APIService _apiService = APIService();
  final HiveService _db = HiveService();

  MovieDetailsController({required this.movieId});

  Future<SingleMovie> getMovieDetails() =>
      _apiService.getMovieDetails(movieId);

  Future<List<Result>> getSimilarMovies() async {
  final movies = await _apiService.getSimilarMovies(movieId);
  return movies.results ?? [];
}

  Future<bool> isFavourite() async {
    return _db.isFavourite(movieId);
  }

  Future<void> addFavourite(MovieRecord record) =>
      _db.addFavourite(record);

  Future<void> removeFavourite() =>
      _db.removeFavourite(movieId);

  Future<bool> isWatchNow() async {
    return _db.isWatchNow(movieId);
  }

  Future<void> addWatchNow(MovieRecord record) =>
      _db.addWatchNow(record);

  Future<void> removeWatchNow() =>
      _db.removeWatchNow(movieId);

  Future<bool> isWatchLater() async {
    return _db.isWatchLater(movieId);
  }

  Future<void> addWatchLater(MovieRecord record) =>
      _db.addWatchLater(record);

  Future<void> removeWatchLater() =>
      _db.removeWatchLater(movieId);

  Future<bool> isWatched() async {
    return _db.isWatched(movieId);
  }

  Future<void> addWatched(MovieRecord record) =>
      _db.addWatched(record);

  Future<void> removeWatched() =>
      _db.removeWatched(movieId);
}